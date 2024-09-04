package substates;

import farfadox.utils.net.downloads.GoogleDriveDownloader;

import flixel.util.FlxColor;
import flixel.ui.FlxBar;
import flixel.text.FlxText;
import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.FlxG;

enum DownloadType
{
    GDRIVE;
    MEDIAFIRE;
} 

class DownloadingSubState extends FlxSubState
{
    public var isGDrive:Bool;

    public var downloadStatus:FlxText;
    public var downloadBytesStatus:FlxText;
    public var processBar:FlxBar;

    public var percent:Float;

    public function new(_isGDrive:Bool) 
    {
        super();

        isGDrive = _isGDrive;
        
        var bg:FlxSprite = new FlxSprite().makeGraphic(1920, 1080, 0xFF000000);
        bg.alpha = 0.6;
        add(bg);

        downloadStatus = new FlxText(0, 400, 0, '');
		downloadStatus.setFormat("VCR OSD Mono", 70, FlxColor.WHITE, LEFT);
        add(downloadStatus);

        downloadBytesStatus = new FlxText(0, 500, 0, '');
		downloadBytesStatus.setFormat("VCR OSD Mono", 70, FlxColor.WHITE, LEFT);
        add(downloadBytesStatus);

        processBar = new FlxBar(0, 600, LEFT_TO_RIGHT, 1000, 40, this, 'percent', 0, 1);
        processBar.screenCenter(X);
        add(processBar);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        updateTexts(isGDrive ? DownloadType.GDRIVE : DownloadType.MEDIAFIRE);
    }

    public function updateTexts(type:DownloadType)
    {
        switch(type)
        {
            case GDRIVE:
                downloadStatus.text = GoogleDriveDownloader.downloadStatus;
                downloadStatus.screenCenter(X);

                downloadBytesStatus.visible = GoogleDriveDownloader.downloadStatus == 'Downloading...';
                downloadBytesStatus.text = GoogleDriveDownloader.loadedBytes(GoogleDriveDownloader.bytesDownloaded) + '/' + GoogleDriveDownloader.loadedBytes(GoogleDriveDownloader.totalBytes);
                downloadBytesStatus.screenCenter(X);

                percent = GoogleDriveDownloader.bytesDownloaded / GoogleDriveDownloader.totalBytes;
                
            case MEDIAFIRE:
                // nothing
        }
    }
}