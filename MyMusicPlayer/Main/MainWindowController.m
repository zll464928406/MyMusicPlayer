//
//  MainWindowController.m
//  MyMusicPlayer
//
//  Created by sunny on 2018/7/2.
//  Copyright © 2018年 moxtra. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MainWindowController.h"
#import "MXMusicModel.h"
#import "MXMusicListView.h"
#import "Masonry.h"
#import "MXAppConfigureManager.h"

@interface MainWindowController ()

@property (weak) IBOutlet NSView *leftView;
@property (weak) IBOutlet NSView *rightView;
@property (weak) IBOutlet NSView *bottomView;

@property (weak) IBOutlet NSImageView *musicImageView;
@property (weak) IBOutlet NSButton *playButton;
@property (weak) IBOutlet NSSlider *progressSlider;
@property (weak) IBOutlet NSTextField *timeLabel;

@property (nonatomic, strong) MXMusicListView *musicListView;


@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *playingTimer;
@property (nonatomic, strong) NSMutableArray *musicList;

@end

@implementation MainWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    self.window.title = @"MyMusicPlayer";
    [self.window setBackgroundColor: [NSColor grayColor]];
    self.window.movableByWindowBackground = YES;
    
    // Title Bar
    self.window.titlebarAppearsTransparent = YES;
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.styleMask |= NSFullSizeContentViewWindowMask;
    
    // Drag and drop
    [self.window registerForDraggedTypes:@[NSFilenamesPboardType]];
    [self.musicImageView unregisterDraggedTypes];
    
    NSColor *backColor = [MXAppConfigureManager sharedInstace].backgroundColor;
    self.leftView.wantsLayer = YES;
    self.leftView.layer.backgroundColor = backColor.CGColor;
    self.rightView.wantsLayer = YES;
    self.rightView.layer.backgroundColor = backColor.CGColor;
    self.bottomView.wantsLayer = YES;
    self.bottomView.layer.backgroundColor = backColor.CGColor;
    
    // 添加播放列表
    self.musicListView = [[MXMusicListView alloc] initWithFrame:self.leftView.frame];
    [self.leftView addSubview:self.musicListView];
    [self.musicListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftView).offset(20.0f);
        make.bottom.left.right.equalTo(self.leftView);
    }];
    
    // 计算播放时间的timer
    self.playingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playingTimerHandle:) userInfo:nil repeats:YES];
}

- (MXMusicModel *)loadMusicWithFileURL:(NSURL *)url
{
    [self.player stop];
    MXMusicModel *musicModel = [[MXMusicModel alloc] initWithFile:url];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    return musicModel;
}

- (void)playingTimerHandle:(NSTimer *)timer
{
    NSTimeInterval currentTime = self.player.currentTime;
    NSTimeInterval totalTime = self.player.duration;
    NSInteger currentMin = currentTime / 60;
    NSInteger currentSec = (int)round(currentTime) % 60;
    NSInteger totalMin = totalTime / 60;
    NSInteger totalSec = (int)round(totalTime) % 60;
    
    self.timeLabel.stringValue = [NSString stringWithFormat:@"%02ld:%02ld / %02ld:%02ld",currentMin, currentSec, totalMin, totalSec];
    self.progressSlider.doubleValue = currentTime / totalTime;
}

#pragma mark - User Action
// 播放 & 暂停
- (IBAction)playAction:(id)sender
{
    if (self.player.url)
    {
        if (self.player.playing)
        {
            [self.player pause];
        }else
        {
            [self.player play];
        }
    }
    else
    {
        [self openMusicWithDialog];
    }
    
    [self.playButton setImage:[NSImage imageNamed:self.player.playing ? @"pause" : @"play"]];
}


- (IBAction)previousAction:(id)sender
{
    // 上一首
}

- (IBAction)nextAction:(id)sender
{
    // 下一首
}

- (IBAction)progressSliderAction:(NSSlider *)sender
{
    NSTimeInterval time = self.progressSlider.doubleValue * self.player.duration;
    self.player.currentTime = time;
}

- (IBAction)soundVolumeSliderChangeAction:(id)sender
{
    //音量调节 - Slider
    NSSlider *slider = (NSSlider *)sender;
    [self.player setVolume:slider.doubleValue];
}


- (void)openMusicWithDialog
{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:NO];
    [openDlg setAllowsMultipleSelection:NO];
    NSArray *urlArray;
    
    if ([openDlg runModal] == NSModalResponseOK)
    {
        urlArray = [openDlg URLs];
    }
    
    for (NSURL *url in urlArray)
    {
        [self loadMusicWithFileURL:url];
        [self.player play];
        return;
    }
}



//Tableview
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    MXMusicModel *music = self.musicList[row];
    
    if( [tableColumn.identifier isEqualToString:@"number"] )
    {
        cellView.textField.stringValue = [NSString stringWithFormat:@"%ld",row];
    }
    else if ([tableColumn.identifier isEqualToString:@"name"])
    {
        cellView.textField.stringValue = music.title;
    }
    else if ([tableColumn.identifier isEqualToString:@"time"])
    {
        cellView.textField.stringValue = [NSString stringWithFormat:@"%d:%.2d",(int)music.duration / 60, (int)music.duration % 60];
    }
    
    return cellView;
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.musicList count];
}

@end
