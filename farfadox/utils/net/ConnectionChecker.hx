package farfadox.utils.net;

import sys.io.Process;

using StringTools;

enum ConnectionType
{
    WIFI;
    LAN;
    BOTH;
}

class ConnectionChecker
{
    public static var command:String;
    public static var process:Process;
    public static var output:String;

    public static function checkWiFiConnection():Bool
    {
        command = '';

        #if windows
        command = "cmd /c netsh wlan show interfaces";
        #elseif linux
        command = "nmcli -t -f active,ssid dev wifi";
        #elseif mac
        command = "networksetup -getinfo Wi-Fi";
        #else
        trace("Unsupported platform");
        return false;
        #end

        process = new Process(command);
        output = process.stdout.readAll().toString();
        process.close();

        trace(output);

        // Parse the output to determine if WiFi is connected
        if (output != null && !output.contains("disconnected")) 
        {
            trace("WiFi is active.");
            return true;
        } 
        else 
        {
            trace("No active WiFi connection.");
            return false;
        }
    }

    public static function checkLANConnection():Bool
    {
        command = '';

        #if windows
        command = "ipconfig";
        #elseif linux
        command = "nmcli device";
        #elseif mac
        command = "ifconfig";
        #else
        trace("Unsupported platform");
        return false;
        #end

        process = new Process(command, []);
        output = process.stdout.readAll().toString();
        process.close();

        trace(output);

        // Parse the output to determine if LAN is connected
        if (output != null && (output.indexOf("Ethernet") != -1 || output.indexOf("connected") != -1)) 
        {
            trace("LAN is active.");
            return true;
        } 
        else 
        {
            trace("No active LAN connection.");
            return false;
        }
    }

    public static function checkConnection(type:ConnectionType):Bool
    {
        switch(type)
        {
            case WIFI: return checkWiFiConnection(); 

            case LAN: return checkLANConnection();

            case BOTH: return (checkWiFiConnection() || checkLANConnection());

            default: trace('Not supported network!'); return false;
        }
    }
}