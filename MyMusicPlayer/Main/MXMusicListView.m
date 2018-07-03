//
//  MXMusicListView.m
//  MyMusicPlayer
//
//  Created by sunny on 2018/7/3.
//  Copyright © 2018年 moxtra. All rights reserved.
//

#import "MXMusicListView.h"
#import "MXUITableView.h"
#import "MXMusicListCell.h"
#import "MainConstants.h"
#import "MXAppConfigureManager.h"
#import "Masonry.h"

@interface MXMusicListView () <MXUITableViewDelegate, MXUITableViewDataSource>

@property (nonatomic, strong) NSView *headerView;
@property (nonatomic, strong) MXUITableView *tableView;

@end

@implementation MXMusicListView

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupUI];
        self.dataArray = @[@"123", @"123"];
        [self.tableView reload];
    }
    return self;
}

- (void)setupUI
{
    [self addSubview:self.headerView];
    [self addSubview:self.tableView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(kSmallMargin);
        make.right.equalTo(self).offset(-kSmallMargin);
        make.height.mas_equalTo(30.0f);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(1.0f);
        make.left.equalTo(self).offset(kSmallMargin);
        make.right.equalTo(self).offset(-kSmallMargin);
        make.bottom.equalTo(self).offset(-kSmallMargin);
    }];
}

#pragma mark - MXUITableViewDataSource
-(NSInteger)numberOfRowsInTableView:(MXUITableView *)tableView
{
    return self.dataArray.count;
}

-(id)tableView:(MXUITableView *)tableView cellForRow:(NSInteger)row
{
    MXMusicListCell *cell = [tableView makeViewWithIdentifier:NSStringFromClass(MXMusicListCell.class) owner:nil];
    if (!cell)
    {
        cell = [[MXMusicListCell alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    }
    [cell updateContents];
    
    return cell;
}

#pragma mark - MXUITableViewDelegate

#pragma mark - Private Methods
- (NSView *)fetchHeaderView
{
    NSView *headerView = [[NSView alloc] initWithFrame:NSZeroRect];
    headerView.wantsLayer = YES;
    headerView.layer.backgroundColor = [NSColor lightGrayColor].CGColor;
    
    NSTextField *musicLabel = [self fetchTextFieldWithTitle:@"歌曲"];
    NSTextField *singerLabel = [self fetchTextFieldWithTitle:@"歌手"];
    NSTextField *timeLabel = [self fetchTextFieldWithTitle:@"时长"];
    
    [headerView addSubview:musicLabel];
    [headerView addSubview:singerLabel];
    [headerView addSubview:timeLabel];
    
    [musicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(kLeftMargin);
        make.centerY.equalTo(headerView);
        make.width.mas_equalTo(kMusicLabelWidth);
    }];
    [singerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(musicLabel.mas_right).offset(kLeftMargin);
        make.centerY.equalTo(headerView);
        make.width.mas_equalTo(kSigerLabelWidth);
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(singerLabel.mas_right).offset(kLeftMargin);
        make.centerY.equalTo(headerView);
        make.width.mas_equalTo(kTimeLabelWidth);
        make.right.equalTo(headerView).offset(-kRightMargin);
    }];
    
    return headerView;
}

- (NSTextField *)fetchTextFieldWithTitle:(NSString *)title
{
    NSTextField *textField = [[NSTextField alloc] init];
    textField.lineBreakMode = NSLineBreakByTruncatingTail;
    textField.editable = NO;
    textField.bordered = NO;
    textField.backgroundColor = [NSColor clearColor];
    textField.stringValue = title;
    textField.alignment = NSTextAlignmentCenter;
    
    return textField;
}

#pragma mark - Lazy Load
-(NSView *)headerView
{
    if (!_headerView)
    {
        _headerView = [self fetchHeaderView];
    }
    
    return _headerView;
}

-(MXUITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[MXUITableView alloc] initWithFrame:self.frame];
        _tableView.backgroundColor = [MXAppConfigureManager sharedInstace].backgroundColor;;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

@end
