package farfadox.utils.net.downloads;

import haxe.Http;
import sys.io.File;
import sys.ssl.Socket;
import sys.net.Host;
import sys.thread.Thread;
import htmlparser.HtmlDocument;

// Direct link:
//https://download1326.mediafire.com/bxesialfjqvgNZFE0xL0GqPEisM1mE5dhDS1-zzNhDem5gRYS_H9SAAX31svImmMS161gRg8tZTDOfUiJFrte7q-S-giRrOMrPDOmpLco7VLv0xkmqcKmRO19P_rKHuRWCtpz-on0nBbXkduIvc5t97pp55rqQGFEwNm-mT8J08/teq6fgks0mzhnm4/bin.zip

class MediafireDownloader {
    public function new() 
    {
        var url:String = "https://www.mediafire.com/file/teq6fgks0mzhnm4/bin.zip/file";
        Thread.create(function() 
        {
            fetchMediafireData(url);
        });
        trace("Fetching data...");
    }

    public static function downloadFile(url:String)
    {
        var http:Http = new Http(url);

        var outputFilePath:String = StringTools.replace(Sys.programPath(), 'farfadox-utils-example.exe', '');
        var extension:String = url.substr(url.length - 3, url.length);
        outputFilePath += 'TheGrefg.' + extension;

        trace('PATH: ' + outputFilePath + ', EXTENSION: ' + extension);

        http.onData = function(data:String) {
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
        }

        http.request(false);
    }

    //Get mediafire data

    public static function fetchMediafireData(url:String)
    {
        var http:Http = new Http(url);
        http.onData = function(d)
        {
            trace('data', d);
            var doc:HtmlDocument = new HtmlDocument(d, true);
            var titles = doc.find("#downloadButton");
            var newURL = titles[0].getAttribute("href");
            trace('NEW URL: ' + newURL);
            Thread.create(function() 
            {
                downloadFile(newURL);
            });
            trace("Starting download...");
        }
        http.request();
    }
}
