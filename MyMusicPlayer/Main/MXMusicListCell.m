//
//  MXMusicListCell.m
//  MyMusicPlayer
//
//  Created by sunny on 2018/7/3.
//  Copyright © 2018年 moxtra. All rights reserved.
//

#import "MXMusicListCell.h"
#import "MainConstants.h"
#import "Masonry.h"

@interface MXMusicListCell ()

@property(nonatomic, strong) NSTextField *titleField;
@property(nonatomic, strong) NSTextField *singerField;
@property(nonatomic, strong) NSTextField *timeField;

@end

@implementation MXMusicListCell

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    [self addSubview:self.titleField];
    [self addSubview:self.singerField];
    [self addSubview:self.timeField];
    
    [self.titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kLeftMargin);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(kMusicLabelWidth);
    }];
    [self.singerField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleField.mas_right).offset(kLeftMargin);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(kSigerLabelWidth);
    }];
    [self.timeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.singerField.mas_right).offset(kLeftMargin);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(kTimeLabelWidth);
        make.right.equalTo(self).offset(-kRightMargin);
    }];
}

#pragma mark - Public Methods
- (void)updateContents
{
    self.titleField.stringValue = @"王贰浪 - 往后余生（翻自 马良";
    self.singerField.stringValue = @"王贰浪";
    self.timeField.stringValue = @"04:50";
}

#pragma mark - Private Methods
- (NSTextField *)fetchTextField
{
    NSTextField *textField = [[NSTextField alloc] init];
    textField.lineBreakMode = NSLineBreakByTruncatingTail;
    textField.editable = NO;
    textField.bordered = NO;
    textField.backgroundColor = [NSColor clearColor];
    textField.alignment = NSTextAlignmentCenter;
    
    return textField;
}

#pragma mark - Lazy Load
-(NSTextField *)titleField
{
    if (!_titleField)
    {
        _titleField = [self fetchTextField];
    }
    
    return _titleField;
}

-(NSTextField *)singerField
{
    if (!_singerField)
    {
        _singerField = [self fetchTextField];
    }
    
    return _singerField;
}

-(NSTextField *)timeField
{
    if (!_timeField)
    {
        _timeField = [self fetchTextField];
    }
    
    return _timeField;
}

@end
