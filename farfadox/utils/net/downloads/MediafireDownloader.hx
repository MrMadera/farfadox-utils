package farfadox.utils.net.downloads;

import haxe.Http;
import sys.io.File;
import sys.ssl.Socket;
import sys.net.Host;
import sys.thread.Thread;
import htmlparser.HtmlDocument;
import haxe.zip.Uncompress;

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

    public static function downloadFile(url:String)
    {
        var http:Http = new Http(url);

        var outputFilePath:String = StringTools.replace(Sys.programPath(), 'farfadox-utils-example.exe', '');
        var extension:String = url.substr(url.length - 3, url.length);
        outputFilePath += 'TheGrefg.' + extension;

        isDownloading = true;

        trace('PATH: ' + outputFilePath + ', EXTENSION: ' + extension);

        http.onData = function(data:String) {

            #if debug
            var outputFilePath:String = StringTools.replace(Sys.programPath(), 'farfadox-utils-example.exe', '');
            outputFilePath += 'htmldata.txt';

            File.saveContent(outputFilePath, data);

            #end

            var bytes = haxe.io.Bytes.ofString(data);
            trace("Received chunk of size: " + bytes.length);
        }

        http.onError = function(error:String) {
            trace("Error downloading file: " + error);
        }

        http.onStatus = function(status:Int) {
            if (status != 200) {
                trace("HTTP request failed with status code: " + status);
            }
        }

        http.onBytes = function(b:haxe.io.Bytes) {
            trace('Downloaded bytes:', b.length);
            File.saveBytes(outputFilePath, b);
            if(extension == 'zip') unZip(b);
            isDownloading = false;
        }

        http.request(false);
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

            trace('NEW URL: ' + newURL);
            trace('File size: ' + fileSize);
            totalBytes = convertMediafireFilesizeDataToBytes(fileSize);
            trace('Total MBs: ' + totalBytes);
            totalBytes *= 1000000;
            trace('Total bytes: ' + totalBytes);
            Thread.create(function() 
            {
                downloadFile(newURL);
            });
            trace("Starting download...");
        }
        http.request();
    }

    public static function unZip(bytes:haxe.io.Bytes)
    {
        // code ...
        trace('Unzipping!');
    }

    private static function convertMediafireFilesizeDataToBytes(string:String):Float
    {
        var trimmedText = StringTools.trim(string);
        var result = StringTools.replace(trimmedText, " ", "");
        var sizeInMBs = result.substr(result.length - 7, result.length - 12);
        var sizeinMBs_int = Std.parseFloat(sizeInMBs);
        var returnBytes:Float = sizeinMBs_int;
        return returnBytes;
    }
}