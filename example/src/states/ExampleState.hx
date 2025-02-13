package states;

import substates.DownloadingSubState;
import farfadox.utils.net.downloads.MediafireDownloader;
import farfadox.utils.net.downloads.GoogleDriveDownloader;
import farfadox.utils.ui.gamepad.GamepadInstructions;
import farfadox.utils.net.ConnectionChecker;
import farfadox.utils.ui.CustomButton;
import farfadox.utils.ui.CustomNumericStepperUI;

import flixel.FlxState;
import flixel.util.FlxTimer;
import flixel.text.FlxText;

class ExampleState extends FlxState
{
    public var south_button_ps4:GamepadInstructions;
    public var west_button_ps4:GamepadInstructions;
    public var east_button_ps4:GamepadInstructions;
    public var north_button_ps4:GamepadInstructions;
    public var directional_pad_up_button_ps4:GamepadInstructions;
    public var directional_pad_down_button_ps4:GamepadInstructions;
    public var directional_pad_left_button_ps4:GamepadInstructions;
    public var directional_pad_right_button_ps4:GamepadInstructions;
    public var left_stick_ps4:GamepadInstructions;
    public var right_stick_ps4:GamepadInstructions;
    public var left_stick_button_ps4:GamepadInstructions;
    public var right_stick_button_ps4:GamepadInstructions;
    public var left_bumper_button_ps4:GamepadInstructions;
    public var right_bumper_button_ps4:GamepadInstructions;
    public var left_trigger_button_ps4:GamepadInstructions;
    public var right_trigger_button_ps4:GamepadInstructions;

    public var stepper:CustomNumericStepperUI;

    public var connectionAvaible:FlxText;

    override function create()
    {
        super.create();

        south_button_ps4 = new GamepadInstructions(50, 50, 'Jump', 30, SOUTH_BUTTON, true, true);
        add(south_button_ps4);
        
        west_button_ps4 = new GamepadInstructions(50, 100, 'Interact', 30, WEST_BUTTON, true, true);
        add(west_button_ps4);
        
        east_button_ps4 = new GamepadInstructions(50, 150, 'Back', 30, EAST_BUTTON, true, true);
        add(east_button_ps4);
        
        north_button_ps4 = new GamepadInstructions(50, 200, 'Talk', 30, NORTH_BUTTON, true, true);
        add(north_button_ps4);

        directional_pad_up_button_ps4 = new GamepadInstructions(50, 250, 'Move up', 30, DIRECTIONAL_PAD_UP, true, true);
        add(directional_pad_up_button_ps4);
        
        directional_pad_down_button_ps4 = new GamepadInstructions(50, 300, 'Move down', 30, DIRECTIONAL_PAD_DOWN, true, true);
        add(directional_pad_down_button_ps4);
        
        directional_pad_left_button_ps4 = new GamepadInstructions(50, 350, 'Move left', 30, DIRECTIONAL_PAD_LEFT, true, true);
        add(directional_pad_left_button_ps4);
        
        directional_pad_right_button_ps4 = new GamepadInstructions(50, 400, 'Move right', 30, DIRECTIONAL_PAD_RIGHT, true, true);
        add(directional_pad_right_button_ps4);
        
        left_stick_ps4 = new GamepadInstructions(50, 450, 'Left stick', 30, LEFT_STICK, true, true);
        add(left_stick_ps4);
        
        right_stick_ps4 = new GamepadInstructions(50, 500, 'Right stick', 30, RIGHT_STICK, true, true);
        add(right_stick_ps4);
        
        left_stick_button_ps4 = new GamepadInstructions(50, 550, 'Left stick button', 30, LEFT_STICK_BUTTON, true, true);
        add(left_stick_button_ps4);
        
        right_stick_button_ps4 = new GamepadInstructions(50, 600, 'Right stick button', 30, RIGHT_STICK_BUTTON, true, true);
        add(right_stick_button_ps4);
        
        left_bumper_button_ps4 = new GamepadInstructions(50, 650, 'Left bumper button', 30, LEFT_BUMPER, true, true);
        add(left_bumper_button_ps4);
        
        right_bumper_button_ps4 = new GamepadInstructions(350, 50, 'Right bumper button', 30, RIGHT_BUMPER, true, true);
        add(right_bumper_button_ps4);
        
        left_trigger_button_ps4 = new GamepadInstructions(350, 100, 'Left trigger button', 30, LEFT_TRIGGER, true, true);
        add(left_trigger_button_ps4);
        
        right_trigger_button_ps4 = new GamepadInstructions(350, 150, 'Right trigger button', 30, RIGHT_TRIGGER, true, true);
        add(right_trigger_button_ps4);

        stepper = new CustomNumericStepperUI(800, 600, 0.005, 0.05);
		stepper.minValue = 0.005;
		stepper.maxValue = 0.5;
		stepper.callback = function()
		{

		}
        add(stepper);

        if(ConnectionChecker.checkConnection(BOTH))
        {
            connectionAvaible = new FlxText(0, 1000, 0, 'Connection is avaible!', 40);
            connectionAvaible.screenCenter(X);
            add(connectionAvaible);
        }

        var button2:CustomButton = new CustomButton(600, 720, 200, 66, 0xFFFFFFFF, 'Video', 32, 0xFF000000, function()
        {
            MediafireDownloader.customOutputPath = 'C:/Users/User/Desktop';
            new MediafireDownloader("https://www.mediafire.com/file/r9d03vvig4ayjoj/lider_de_la_haxe_gang_ligero.mp4/file", 'haxe_gang');
            openSubState(new DownloadingSubState(false));
        });
        button2.antialiasing = true;
        button2.bgSelectedColor = 0xFF000000;
        button2.txtSelectedColor = 0xFFFFFFFF;
        add(button2);

        var button3:CustomButton = new CustomButton(820, 650, 200, 66, 0xFFFFFFFF, 'Zip', 32, 0xFF000000, function()
        {
            GoogleDriveDownloader.extension = 'zip';
            GoogleDriveDownloader.autoUnzip = true;
            GoogleDriveDownloader.customOutputPath = 'C:/Users/User/Desktop';
            GoogleDriveDownloader.onSuccess = function()
            {
                trace('ON SUCCESS!!!! DOWNLOAD DONE');
            }
            GoogleDriveDownloader.onCancel = function()
            {
                trace('ON CANCEL!!!! DOWNLOAD CANCELLED');
            }
            new GoogleDriveDownloader("https://drive.google.com/file/d/1RsTuBQ_7UtlfxxT2H-hlH_3roMVmtzfD/view", 'codename');
            openSubState(new DownloadingSubState(true));
        });
        button3.antialiasing = true;
        button3.bgSelectedColor = 0xFF000000;
        button3.txtSelectedColor = 0xFFFFFFFF;
        add(button3);

        var button3:CustomButton = new CustomButton(820, 720, 200, 66, 0xFFFFFFFF, 'Zip mediafire', 32, 0xFF000000, function()
            {
                MediafireDownloader.autoUnzip = true;
                MediafireDownloader.customOutputPath = 'C:/Users/User/Desktop';
                MediafireDownloader.onSuccess = function()
                {
                    trace('ON SUCCESS!!!! DOWNLOAD DONE');
                }
                MediafireDownloader.onCancel = function()
                {
                    trace('ON CANCEL!!!! DOWNLOAD CANCELLED');
                }
                new MediafireDownloader("https://www.mediafire.com/file/etmab2imhyxfrd1/bin.zip/file", 'grefg');
                openSubState(new DownloadingSubState(false));
            });
            button3.antialiasing = true;
            button3.bgSelectedColor = 0xFF000000;
            button3.txtSelectedColor = 0xFFFFFFFF;
            add(button3);
    }
}