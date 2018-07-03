//
//  MXUITableView.h
//  MXUIKit
//
//  Created by sunny on 2018/6/1.
//  Copyright © 2018年 moxtra. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MXUITableView;

@protocol MXUITableViewDataSource <NSObject>

- (NSInteger)numberOfRowsInTableView:(MXUITableView *)tableView;
- (id)tableView:(MXUITableView *)tableView cellForRow:(NSInteger)row;

@end

@protocol MXUITableViewDelegate <NSObject>

@optional
- (CGFloat)tableView:(MXUITableView *)tableView heightForRow:(NSInteger)row;
- (void)tableView:(MXUITableView *)tableView didSelectRow:(NSInteger)row;

@end

@interface MXUITableView : NSView

@property(nonatomic,weak) id<MXUITableViewDataSource> dataSource;
@property(nonatomic,weak) id<MXUITableViewDelegate> delegate;

@property(nonatomic, strong) NSColor *backgroundColor;
@property(nonatomic, strong) NSColor *rowSelectedColor;


- (__kindof NSView *)makeViewWithIdentifier:(NSUserInterfaceItemIdentifier)identifier owner:(id)owner;
- (void)reload;

@end
