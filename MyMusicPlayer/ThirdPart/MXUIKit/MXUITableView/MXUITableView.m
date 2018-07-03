//
//  MXUITableView.m
//  MXUIKit
//
//  Created by sunny on 2018/6/1.
//  Copyright © 2018年 moxtra. All rights reserved.
//

#import "MXUITableView.h"
#import "MXTableViewRowView.h"
#import "Masonry.h"

@interface MXUITableView () <NSTableViewDelegate, NSTableViewDataSource>

@property(nonatomic, strong) NSScrollView *scrollView;
@property(nonatomic, strong) NSTableView *tableView;

@end

@implementation MXUITableView
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
    self.wantsLayer = YES;
    
    self.scrollView = [[NSScrollView alloc] init];
    self.scrollView.hasVerticalScroller  = YES;
    self.scrollView.frame = self.bounds;
    self.scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0.0f);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    self.tableView = [[NSTableView alloc] init];
    self.tableView.frame = self.scrollView.frame;
    self.tableView.headerView = nil;
    self.tableView.autoresizingMask = YES;
//    self.tableView.gridStyleMask = NSTableViewDashedHorizontalGridLineMask | NSTableViewSolidVerticalGridLineMask;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.scrollView.contentView.documentView = self.tableView;
    [self.tableView registerNib:nil forIdentifier:@"MXSlideTopicCell"];
    // 3.0.创建表列
    NSTableColumn *chatColumen = [[NSTableColumn alloc] initWithIdentifier:NSStringFromClass(NSTableColumn.class)];
    chatColumen.title = @"";
    chatColumen.headerCell.alignment = NSTextAlignmentCenter;
    chatColumen.minWidth =  self.tableView.frame.size.width;
    chatColumen.resizingMask = NSTableColumnUserResizingMask | NSTableColumnAutoresizingMask;
    [self.tableView addTableColumn:chatColumen];
    /*
     NSTableColumnNoResizing        不能改变宽度
     NSTableColumnAutoresizingMask  拉大拉小窗口时会自动布局
     NSTableColumnUserResizingMask  允许用户调整宽度
     */
}

#pragma mark - Public Method
- (void)reload
{
    self.scrollView.hasVerticalScroller = YES;
    self.scrollView.hasVerticalRuler = YES;
    [self.tableView setFrameOrigin:NSZeroPoint];
    [self.tableView reloadData];
}

- (__kindof NSView *)makeViewWithIdentifier:(NSUserInterfaceItemIdentifier)identifier owner:(id)owner
{
    return [self.tableView makeViewWithIdentifier:identifier owner:nil];
}

#pragma mark - NSTableViewDataSource
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if ([self.dataSource respondsToSelector:@selector(numberOfRowsInTableView:)])
    {
        return [self.dataSource numberOfRowsInTableView:self];
    }
    
    return 0;
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row
{
    NSString *identifier = NSStringFromClass(MXTableViewRowView.class);
    MXTableViewRowView *rowView = [tableView makeViewWithIdentifier:identifier owner:self];
    if (rowView == nil)
    {
        rowView = [[MXTableViewRowView alloc] init];
        rowView.selectedColor = self.rowSelectedColor;
        rowView.identifier = identifier;
    }
    return rowView;
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if ([self.dataSource respondsToSelector:@selector(tableView:cellForRow:)])
    {
        return [self.dataSource tableView:self cellForRow:row];
    }
    
    return [NSTableRowView new];
}

#pragma mark - NSTableViewDelegate
-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    if ([self.delegate respondsToSelector:@selector(tableView:heightOfRow:)])
    {
        return [self.delegate tableView:self heightForRow:row];
    }
    
    return 45.0f;
}

#pragma mark - Notifications
- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSTableView *tableView = notification.object;
    NSInteger row = tableView.selectedRow;
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectRow:)])
    {
        [self.delegate tableView:self didSelectRow:row];
    }
}

#pragma mark - Getter & Setter
-(NSColor *)rowSelectedColor
{
    return _rowSelectedColor ? _rowSelectedColor : [NSColor lightGrayColor];
}

-(void)setDelegate:(id<MXUITableViewDelegate>)delegate
{
    _delegate = delegate;
    if (self.dataSource)
    {
        [self.tableView reloadData];
    }
}

-(void)setDataSource:(id<MXUITableViewDataSource>)dataSource
{
    _dataSource = dataSource;
    if (self.delegate)
    {
        [self.tableView reloadData];
    }
}

-(void)setBackgroundColor:(NSColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    self.layer.backgroundColor = backgroundColor.CGColor;
    self.scrollView.backgroundColor = backgroundColor;
    self.tableView.backgroundColor = backgroundColor;
}

@end
