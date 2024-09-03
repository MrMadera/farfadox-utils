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
    public function new(url:String) 
    {
        Thread.create(function() 
        {
            fetchGoogleDriveData(url);
        });
        trace("Fetching data...");
    }

    public static var isDownloading:Bool = false;
    public static var downloadingRn:Bool = false;
    public static var socket:Socket;

    public static var domain:String;
    public static var path:String;

    public static var bytesDownloaded:Float;
    
	public static var file:FileOutput;

    public static var extension:String;

    public static function downloadFile(url:String)
    {
        socket = new Socket();

        var outputFilePath:String = StringTools.replace(Sys.programPath(), 'farfadox-utils-example.exe', '');
        outputFilePath += 'downloads/TheGrefg.' + extension;

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
                }
                trace('GET method successfully done!');

				break;
            }
            catch(e)
            {
                if(tries <= 4) trace('Network Error! ' + e + ', Retrying... ' + tries);
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
        var downloadOutput = StringTools.replace(outputFilePath, '/TheGrefg.' + extension, ''); 
        if(!FileSystem.exists(downloadOutput))
        {
            FileSystem.createDirectory(downloadOutput);
        }

        // Instance the file
        try
        {
            file = File.append(outputFilePath, true);
            trace('File created');
        }
        catch(exc)
        {
            file = null;
            trace('Error creating file!');
            // TODO: add OnCancel function or similar
            return;
        }

        // Now let's get the headers
        var headers:Map<String, String> = new Map<String, String>();
        while(isDownloading)
        {
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
        var buffer:haxe.io.Bytes = haxe.io.Bytes.alloc(8192);
		var bytesWritten:Int = 1;
        downloadingRn = true;
        if(totalBytes > 0)
        {
            while(bytesDownloaded < totalBytes && isDownloading)
            {
                try
                {
                    bytesWritten = socket.input.readBytes(buffer, 0, buffer.length);
                    file.writeBytes(buffer, 0, bytesWritten);
                    bytesDownloaded += bytesWritten;
                    trace('Downloading! ' + loadedBytes(bytesDownloaded) + '/' + loadedBytes(totalBytes));
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

            trace('Download complete!');
            trace('Closing network...');
            socket.close();

            checkFormat();
            resetInfo();
        }
        else
        {
			while (bytesWritten > 0) {
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
        downloadingRn = false;
    }

    public static var totalBytes:Float = 0;

    //Get google drive data
    public static function fetchGoogleDriveData(url:String)
    {
		var id = url.substr("https://drive.google.com/file/d/".length).split("/")[0];
		var newURL = 'https://drive.usercontent.google.com/download?id=$id&export=download&confirm=t';
        Thread.create(function() 
        {
            downloadFile(newURL);
        });
    }

    public static function unZip()
    {
        // code ...
        trace('Unzipping!');
    }

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
        if(extension == 'zip') unZip();
    }

    private static function resetInfo()
    {
        if (file != null)
            file.close();
        extension = null;
        isDownloading = false;
        downloadingRn = false;
        domain = '';
        path = '';
        bytesDownloaded = 0;
    }

    private static function loadedBytes(b:Float):String
    {
        if(b > 1000000000) return FlxMath.roundDecimal(b / 1000000000, 2) + "GB";
        else if (b > 1000000) return FlxMath.roundDecimal(b / 1000000, 2) + "MB";
        else if (b > 1000) return FlxMath.roundDecimal(b / 1000, 0) + "kB";
        else return FlxMath.roundDecimal(b, 0) + "kB";
    }
}