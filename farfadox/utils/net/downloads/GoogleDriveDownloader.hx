package farfadox.utils.net.downloads;

import flixel.math.FlxMath;
import haxe.io.Eof;
import haxe.io.Error;
import haxe.Http;
import sys.io.File;
import sys.ssl.Socket;
import sys.net.Host;
import sys.thread.Thread;
import htmlparser.HtmlDocument;
import haxe.zip.Uncompress;
import sys.io.FileOutput;
import sys.FileSystem;

// Direct link:
//https://download1326.mediafire.com/bxesialfjqvgNZFE0xL0GqPEisM1mE5dhDS1-zzNhDem5gRYS_H9SAAX31svImmMS161gRg8tZTDOfUiJFrte7q-S-giRrOMrPDOmpLco7VLv0xkmqcKmRO19P_rKHuRWCtpz-on0nBbXkduIvc5t97pp55rqQGFEwNm-mT8J08/teq6fgks0mzhnm4/bin.zip

class GoogleDriveDownloader 
{
    public function new(url:String, _fileName:String) 
    {
        Thread.create(function() 
        {
            fetchGoogleDriveData(url);
        });
        fileName = _fileName;
        trace("Fetching data...");
    }

    /**
     * While downloading, this variable will be `true`
    **/
    public static var isDownloading:Bool = false;
    /**
     * Socket variable. Main handler of downloads
    **/
    public static var socket:Socket;

    /**
     * Domain of the URL
    **/
    public static var domain:String;
    /**
     * Path of the URL
     * The path is the part which come after the domain.
     * e.g. https://download1326.mediafire.com`/bxesialfjqvgNZFE0xL0GqPEisM1mE5dhDS1...` is the path, the other part 
    **/
    public static var path:String;

    /**
     * The current amount of bytes written during the download
    **/
    public static var bytesDownloaded:Float;
    
    /**
     * The output file
    **/
	public static var file:FileOutput;

    /**
     * The extension of the file
    **/
    public static var extension:String;

    /**
     * The name of the output file
    **/
    public static var fileName:String;

    /**
     * String telling you about the current status of the download
    **/
    public static var downloadStatus:String;

    /**
     * Function which downloads files from an url
     @param url the DIRECT url of the file
    **/
    public static function downloadFile(url:String)
    {
        socket = new Socket();

        var oldoutputFilePath:String = Sys.programPath();

        var index = oldoutputFilePath.lastIndexOf("\\");

        var outputFilePath = oldoutputFilePath.substr(0, index);
        trace('Path before: ' + outputFilePath);
        outputFilePath += '/downloads/' + fileName + '.' + extension;

        isDownloading = true;
        
        setDomains(url);

        trace('PATH: ' + outputFilePath + ', EXTENSION: ' + extension);

		var headers:String = "";
		headers += '\nHost: ${domain}:443';
		headers += '\nUser-Agent: haxe';
		headers += '\nConnection: close';
        trace('Headers: ' + headers);

		socket.setTimeout(5);
		socket.setBlocking(true);

        var tries:Int = 0;
        while(isDownloading)
        {
            tries++;
            try
            {
                // Lil guide cuz im so idiot to undestand this without my comments :(
    
                // Connect to the server
                downloadStatus = 'Connecting...';
                socket.connect(new Host(domain), 443);
                trace('Successfully connected to Network!');
                
                // Write shit to the server so i can download stuff
                socket.write('GET ${path} HTTP/1.1${headers}\n\n');
    
                // The http status shit that sucks sjak fasjfkl 
        
                var httpStatus:String = null;
                httpStatus = socket.input.readLine();
                httpStatus = StringTools.ltrim(httpStatus.substr(httpStatus.indexOf(" ")));
        
                if (httpStatus == null || StringTools.startsWith(httpStatus, "4") || StringTools.startsWith(httpStatus, "5")) 
                {
                    trace('Network error! - $httpStatus');
                    downloadStatus = 'Network error!';
                }
                trace('GET method successfully done!');

				break;
            }
            catch(e)
            {
                if(tries <= 4)
                {
                    downloadStatus = 'Retrying...';
                    trace('Network Error! ' + e + ', Retrying... ' + tries);
                }
                else
                {
                    trace('Many tries! Network has been closed...');
                    socket.close();
                    isDownloading = false;
                    return;
                }

                Sys.sleep(1);
            }
        }

        // Creating the direcory in case it doesn't exist
        var downloadOutput = StringTools.replace(outputFilePath, '/' + fileName + '.' + extension, ''); 
        if(!FileSystem.exists(downloadOutput))
        {
            FileSystem.createDirectory(downloadOutput);
        }

        // Instance the file
        try
        {
            downloadStatus = 'Creating file...';
            file = File.append(outputFilePath, true);
            trace('File created');
        }
        catch(exc)
        {
            downloadStatus = 'Error creating file...';
            file = null;
            trace('Error creating file!');
            // TODO: add OnCancel function or similar
            return;
        }

        // Now let's get the headers
        var headers:Map<String, String> = new Map<String, String>();
        while(isDownloading && !canceledDownload)
        {
            downloadStatus = 'Getting headers...';
			var read:String = socket.input.readLine();
			if (StringTools.trim(read) == "") 
            {
				break;
			}
			var splitHeader = read.split(": ");
            headers.set(splitHeader[0].toLowerCase(), splitHeader[1]);
            trace('Headers map: ' + headers);

            #if debug
                var outputFilePath:String = StringTools.replace(Sys.programPath(), 'farfadox-utils-example.exe', '');
                outputFilePath += 'downloads/headers.txt';

                File.saveContent(outputFilePath, headers.toString());
            #end
        }
		if (headers.exists("content-length")) // take max bytes length
        {
			totalBytes = Std.parseFloat(headers.get("content-length"));
            trace('TOTAL BYTES: ' + totalBytes);
		}

		//var buffer:haxe.io.Bytes = haxe.io.Bytes.alloc(1024);
        var buffer:haxe.io.Bytes = haxe.io.Bytes.alloc(65536);
		var bytesWritten:Int = 1;
        if(totalBytes > 0)
        {
            while(bytesDownloaded < totalBytes && isDownloading && !canceledDownload)
            {
                try
                {
                    downloadStatus = 'Downloading...';
                    bytesWritten = socket.input.readBytes(buffer, 0, buffer.length);
                    file.writeBytes(buffer, 0, bytesWritten);
                    bytesDownloaded += bytesWritten;
                    //trace('Downloading! ' + loadedBytes(bytesDownloaded) + '/' + loadedBytes(totalBytes));
                    Sys.print('\rDownloading! ' + loadedBytes(bytesDownloaded) + '/' + loadedBytes(totalBytes));
                }
                catch (e:Dynamic) 
                {
                    if (e is Eof || e == Error.Blocked) 
                    {
                        // Ignoring eof & error
                        continue;
                    }
                    throw e;
                }
            }

            canCancelDownloads = false;
            if(canceledDownload)
            {
                // If download is canceled

                downloadStatus = 'Cancelling...';
                trace('Cancelling...');
                trace('Closing network...');
                socket.close();
                resetInfo();
            }
            else
            {
                // If download is completed

                trace('Download complete!');
                trace('Closing network...');
                socket.close();

                checkFormat();
                resetInfo();
            }
        }
        else
        {
			while (bytesWritten > 0 && !canceledDownload) {
                trace('Written bytes: $bytesWritten');
				try 
                {
					bytesWritten = Std.parseInt('0x' + socket.input.readLine());
					file.writeBytes(socket.input.read(bytesWritten), 0, bytesWritten);
					bytesDownloaded += bytesWritten;
                    trace('Downloading! Starting to download content: ' + bytesDownloaded);
				}
				catch (e:Dynamic) 
                {
					if (e is Eof || e == Error.Blocked) 
                    {
						// Ignoring eof & error
						continue;
					}
					throw e;
				}
			}
        }
    }

    /**
     * The total amount of bytes of the file
    **/
    public static var totalBytes:Float = 0;

    //Get google drive data

    /**
     * Function which gets the direct url from a normal url
     @param url the normal url
    **/
    public static function fetchGoogleDriveData(url:String)
    {
		var id = url.substr("https://drive.google.com/file/d/".length).split("/")[0];
		var newURL = 'https://drive.usercontent.google.com/download?id=$id&export=download&confirm=t';
        Thread.create(function() 
        {
            downloadFile(newURL);
        });
    }

    /**
     * Function which uncompress .zip files
    **/
    public static function unZip()
    {
        // code ...
        trace('Unzipping!');
        downloadStatus = 'Unzipping...';
    }

    /**
     * Set `domain` and `path` from the direct url
    **/
    public static function setDomains(url:String)
    {
        // example: https://drive.google.com/file/d/1sFS2MCOhDW8WEcyhZnx2VM1iJK6a9ByL/view?usp=sharing

        // domain
        var fdom:String = url.substr(8, 28);
        domain = fdom; //drive.usercontent.google.com

        // path
        var fpath = url.substr(36, url.length);
        trace('path???',fpath);
        path = fpath;
    }

    private static function checkFormat()
    {
        if(extension == 'zip')
        {
            unZip();
        }
        else downloadStatus = 'Download complete!';
    }

    private static function resetInfo()
    {
        if (file != null)
            file.close();
        extension = null;
        isDownloading = false;
        domain = '';
        path = '';
        bytesDownloaded = 0;
        canceledDownload = false;
        canCancelDownloads = true;
    }

    public static function loadedBytes(b:Float):String
    {
        if(b > 1024000000) return FlxMath.roundDecimal(b / 1024000000, 2) + "GB";
        else if (b > 1024000) return FlxMath.roundDecimal(b / 1024000, 2) + "MB";
        else if (b > 1024) return FlxMath.roundDecimal(b / 1024, 0) + "kB";
        else return FlxMath.roundDecimal(b, 0) + "B";
    }

    /**
     * If download is canceled, this will turn `true`
    **/
    public static var canceledDownload:Bool = false;

    /**
     * If download is finished, you cannot delete the file and cancel the download
    **/
    public static var canCancelDownloads:Bool = true;
}