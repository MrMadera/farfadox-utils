package farfadox;

import haxe.Http;

class Version
{
    public static var newVer:String = '';

    public static function fetchVersion():Bool
    {
        var v = false;
        var http:Http = new Http('https://raw.githubusercontent.com/MrMadera/farfadox-utils/main/gitVer.txt');
        http.onData = function (d) 
        {
            newVer = d;
            if(farfadox.utils.macro.Macro.currentVersion == d) v = true;
            else false;
        }
        http.onError = function(e)
        {
            v = true;
            Sys.println('There was an error getting the last update.');
            //Sys.exit(1);
        }
        http.request(false);

        return v;
    }
}