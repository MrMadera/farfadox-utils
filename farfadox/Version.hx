package farfadox;

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

        var command = "curl";
        var args = ["-o", "gitVer.txt", url];

        var process = new Process(command, args);
        process.close();

        var downloadedVersion = File.getContent("gitVer.txt").trim();
        if(downloadedVersion != Macro.currentVersion)
        {
            newVer = downloadedVersion;
            return false;
        }
        else 
        {
            return true;
        }
    }
}