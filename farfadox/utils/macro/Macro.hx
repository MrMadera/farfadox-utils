package farfadox.utils.macro;

import sys.io.Process;
import farfadox.Version;

using StringTools;

class Macro {

    public static var currentVersion:String = '0.3.0';

    macro
    public static function initiateMacro()
    {
        #if !debug
        function checkAnswer()
        {
            if (["yes", "y"].contains(Sys.stdin().readLine().toLowerCase().trim()))
                return true;

            return false;
        }

        log('Checking farfadox-utils version...');

        var v:Bool = Version.fetchVersion();
        var newVer:String = Version.newVer;

        Sys.sleep(0.2); // lil sleep so macro can get the shit

        if(v)
        {
            log('You have the lastest update.');
        }
        else
        {
            Sys.print('You are using the version $currentVersion. Would you like to upgrade to $newVer? (Y/N):');
            var r = Sys.stdin().readLine();
            if(["yes", "y"].contains(r.toLowerCase().trim()))
            {
                log();
                Sys.print('Would you like to download the release or the git version? (github/release):');
                var GOR = Sys.stdin().readLine();
                if(["github"].contains(GOR.toLowerCase().trim()))
                {
                    var p = new Process("haxelib remove farfadox-utils && haxelib git farfadox-utils https://github.com/MrMadera/farfadox-utils.git");
                    while (true) 
                    {
                        var o = p.stdout.readLine();
                        if (o.trim() == "Done")
                        {
                            p.close();
                            break;
                        }
                        p = null;

                        log();
                        log("Ready. (Restart the compilation)");
                        Sys.exit(1);
                    }
                }
                else if(["release"].contains(GOR.toLowerCase().trim()))
                {
                    var p = new Process("haxelib remove farfadox-utils && haxelib install farfadox-utils");
                    while (true) 
                    {
                        var o = p.stdout.readLine();
                        if (o.trim() == "Done")
                        {
                            p.close();
                            break;
                        }
                        p = null;

                        log();
                        log("Ready. (Restart the compilation)");
                        Sys.exit(1);
                    }
                }
            }
            else
            {
                log('Starting with current version.');
            }
        }
        #end

        return macro {};
    }
    
    public static function log(?log:String = "") {
        #if sys
        Sys.println(log);
        #else
        trace('\n' + log);
        #end
    }
}