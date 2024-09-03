package farfadox.utils.net.downloads;

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

class MediafireDownloader 
{
    public function new(url:String) 
    {
        Thread.create(function() 
        {
            fetchMediafireData(url);
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
        extension = url.substr(url.length - 3, url.length);
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

		var buffer:haxe.io.Bytes = haxe.io.Bytes.alloc(1024);
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
                    trace('Downloading! Content: ' + bytesDownloaded);
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

    //Get mediafire data
    public static function fetchMediafireData(url:String)
    {
        var http:Http = new Http(url);
        http.onData = function(d)
        {
            var doc:HtmlDocument = new HtmlDocument(d, true);
            var titles = doc.find("#downloadButton");
            var newURL = titles[0].getAttribute("href");
            @:privateAccess
            var fileSize = titles[0].get_innerHTML();

            #if debug
                var outputFilePath:String = StringTools.replace(Sys.programPath(), 'farfadox-utils-example.exe', '');
                outputFilePath += 'html_data.txt';

                File.saveContent(outputFilePath, d);
            #end

            trace('NEW URL: ' + newURL);
            trace('File size: ' + fileSize);
            Thread.create(function() 
            {
                downloadFile(newURL);
            });
            trace("Starting download...");
        }
        http.request();
    }

    public static function unZip()
    {
        // code ...
        trace('Unzipping!');
    }

    public static function setDomains(url:String)
    {
        // example: https://download1326.mediafire.com/bxesialfjqvgNZFE0xL0GqPEisM1mE5dhDS1-zzNhDem5gRYS_H9SAAX31svImmMS161gRg8tZTDOfUiJFrte7q-S-giRrOMrPDOmpLco7VLv0xkmqcKmRO19P_rKHuRWCtpz-on0nBbXkduIvc5t97pp55rqQGFEwNm-mT8J08/teq6fgks0mzhnm4/bin.zip

        // domain

        // not gonna be calculating stuff depending on url when this'll be only for mediafire files...
        //domain = 'mediafire.com';

        var fdom:String = url.substr(8, 26);
        domain = fdom; //downloadXXXX.mediafire.com

        // path
        var fpath = url.substr(34, url.length);
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
}