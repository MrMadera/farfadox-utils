package farfadox.utils.macro;

import sys.io.Process;
import sys.io.File;

using StringTools;

class Build
{
    public static function main() 
    {
        var args = Sys.args();

        if (args.length == 0) {
            Sys.println("Usage: haxelib run <library-name> <command>");
            return;
        }

        switch (args[0]) {
            case "build":
                build();
            case "setup":
                Sys.println("Setup started!");
                setup();
            default:
                Sys.println("Unknown command: " + args[0]);
        }    
    }

    static function build()
    {
        Sys.print('Are you sure do you want to use the build helper (BETA)? (Y/N):');
        var buildHelperRead = Sys.stdin().readLine();
        if(["yes", "y"].contains(buildHelperRead.toLowerCase().trim()))
        {
            log('Helper started!');
            log('');
            Sys.print('Are you building or testing? (build/test):');
            var buildTestRead = Sys.stdin().readLine();
            var isBuilding:Bool = false;
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

                var curDirectory = Sys.args().copy().pop();
                Sys.setCwd(curDirectory);

                var command:Dynamic;
                if(isBuilding) command = Sys.command('lime build windows -D SKIP_MACRO');
                else command = Sys.command('lime test windows -D SKIP_MACRO');

                Sys.exit(1);
            }
            else if(["mac", "m"].contains(systemsRead.toLowerCase().trim()))
            {
                // mac whit
                log('Bulding at ${Date.now()}');

                var curDirectory = Sys.args().copy().pop();
                Sys.setCwd(curDirectory);

                var command:Dynamic;
                if(isBuilding) command = Sys.command('lime build mac -D SKIP_MACRO');
                else command = Sys.command('lime test mac -D SKIP_MACRO');

                Sys.exit(1);
            }
            else if(["linux", "l"].contains(systemsRead.toLowerCase().trim()))
            {
                // linux shit
                log('Bulding at ${Date.now()}');
                
                var curDirectory = Sys.args().copy().pop();
                Sys.setCwd(curDirectory);

                var command:Dynamic;
                if(isBuilding) command = Sys.command('lime build linux -D SKIP_MACRO');
                else command = Sys.command('lime test linux -D SKIP_MACRO');

                Sys.exit(1);
            }
        }
        else if(["no", "n"].contains(buildHelperRead.toLowerCase().trim()))
        {
            log("Aborting...");
            Sys.exit(1);
        }
    }

    static function setup() 
    {
        var cmdContent = '@haxelib --global run farfadox-utils %*\n';

        var haxePath = Sys.getEnv("HAXEPATH");
        if(haxePath == null)
        {
            // aborting...
            log("ERROR: HAXEPATH is not defined. Aborting...");
            Sys.exit(1);
        }
        var filePath = haxePath + '/farfadox-utils.cmd';

        File.saveContent(filePath, cmdContent);

        log("Done.");
    }

    public static function log(?log:String = "") {
        #if sys
        Sys.println(log);
        #else
        trace('\n' + log);
        #end
    }
}