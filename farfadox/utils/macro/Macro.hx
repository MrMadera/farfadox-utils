package farfadox.utils.macro;

import sys.io.Process;
import sys.io.File;
import farfadox.Version;

using StringTools;

class Macro {

    public static var currentVersion:String = File.getContent('gitVer.txt').trim();

    macro
    public static function initiateMacro()
    {
        #if (!SKIP_MACRO)
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

        Sys.print('Would you like to use the build helper? (BETA) (Y/N):');
        var buildHelperRead = Sys.stdin().readLine();
        if(["yes", "y"].contains(buildHelperRead.toLowerCase().trim()))
        {
            log('Helper started!');
            log('');
            Sys.print('Are you building or testing? (build/test):');
            var buildTestRead = Sys.stdin().readLine();
            var isBuilding:Bool;
            if(["build", "b"].contains(buildTestRead.toLowerCase().trim()))
            {
                isBuilding = true;
            }
            else if(["test", "b"].contains(buildTestRead.toLowerCase().trim()))
            {
                isBuilding = false;
            }

            log('');
            Sys.print('Which systems would you like to compile? (windows, mac, linux):');
            var systemsRead = Sys.stdin().readLine();
            if(["windows", "w"].contains(systemsRead.toLowerCase().trim()))
            {
                // windows shit
                log('Bulding at ${Date.now()}');

                var command:Dynamic;
                if(isBuilding) command = Sys.command('lime build windows -D SKIP_MACRO');
                else command = Sys.command('lime test windows -D SKIP_MACRO');

                Sys.exit(1);
            }
            else if(["mac", "m"].contains(systemsRead.toLowerCase().trim()))
            {
                // mac whit
                log('Bulding at ${Date.now()}');

                var command:Dynamic;
                if(isBuilding) command = Sys.command('lime build mac -D SKIP_MACRO');
                else command = Sys.command('lime test mac -D SKIP_MACRO');

                Sys.exit(1);
            }
            else if(["linux", "l"].contains(systemsRead.toLowerCase().trim()))
            {
                // linux shit
                log('Bulding at ${Date.now()}');

                var command:Dynamic;
                if(isBuilding) command = Sys.command('lime build linux -D SKIP_MACRO');
                else command = Sys.command('lime test linux -D SKIP_MACRO');

                Sys.exit(1);
            }

        }
        else if(["no", "n"].contains(buildHelperRead.toLowerCase().trim()))
        {
            log("Skipping building helper...");
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