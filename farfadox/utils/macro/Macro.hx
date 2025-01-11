package farfadox.utils.macro;

import sys.io.Process;
import sys.io.File;

using StringTools;

class Macro {
    public static var currentVersion:String = '0.4.1';

    macro
    public static function initiateMacro()
    {
        #if (!SKIP_MACRO)
            
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