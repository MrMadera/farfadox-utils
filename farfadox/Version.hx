package farfadox;

import sys.FileSystem;
import farfadox.utils.macro.Macro;
import haxe.Http;
import sys.io.Process;
import sys.io.File;

using StringTools;

class Version
{
    public static var newVer:String = '';

    public static function fetchVersion():Bool
    {
        var url = "https://raw.githubusercontent.com/MrMadera/farfadox-utils/main/gitVer.txt";

        if(!FileSystem.exists('gitVer.txt')) File.saveContent('gitVer.txt', Macro.currentVersion);

        var command = "curl";
        var args = ["-o", "gitVer.txt", url];

        var process = new Process(command, args);
        process.close();

        
        #if debug
        Sys.println('[DEBUG]: Waiting...');
        #end
        Sys.sleep(0.15);

        var downloadedVersion = File.getContent("gitVer.txt").trim();
        #if debug
            Sys.println('[DEBUG]: Version => $downloadedVersion');
            Sys.println('[DEBUG]: Deleted temp file');
        #end
        if(downloadedVersion != Macro.currentVersion)
        {
            FileSystem.deleteFile('gitVer.txt');
            newVer = downloadedVersion;
            return false;
        }
        else 
        {
            FileSystem.deleteFile('gitVer.txt');
            return true;
        }
    }
}