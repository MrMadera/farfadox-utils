package farfadox.utils.net.downloads;

import haxe.Http;
import sys.io.File;
import sys.ssl.Socket;
import sys.net.Host;
import sys.thread.Thread;

// Direct link:
//https://download1326.mediafire.com/bxesialfjqvgNZFE0xL0GqPEisM1mE5dhDS1-zzNhDem5gRYS_H9SAAX31svImmMS161gRg8tZTDOfUiJFrte7q-S-giRrOMrPDOmpLco7VLv0xkmqcKmRO19P_rKHuRWCtpz-on0nBbXkduIvc5t97pp55rqQGFEwNm-mT8J08/teq6fgks0mzhnm4/bin.zip

class MediafireDownloader {
    public function new() 
    {
        var url:String = "https://download1530.mediafire.com/mo0j9mvhgaqgtFg-q8ro9QekuPqljEvtTj8pNAGCRt0lqkVT0KR9shX8idDlcavwByAy-J_DI9OaWImEjLd9eMlq1bany71LtBXO4I1NNyGqYr0FqLMRmgU2V1SlS2NiMfi5Y6XVltt_RdrxeAVSChmUQo6uzpiQBY5MvPYRjnc/r9d03vvig4ayjoj/lider+de+la+haxe+gang+ligero.mp4";
        Thread.create(function() 
        {
            downloadFile(url);
        });
        trace("Download started...");
    }

    public function downloadFile(url:String)
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
}
