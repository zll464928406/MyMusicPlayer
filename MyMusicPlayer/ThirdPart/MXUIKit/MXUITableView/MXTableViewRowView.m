//
//  MXTableViewRowView.m
//  MXUIKit
//
//  Created by sunny on 2018/6/8.
//  Copyright © 2018年 moxtra. All rights reserved.
//

#import "MXTableViewRowView.h"

@interface MXTableViewRowView ()

@property (nonatomic, strong) NSTrackingArea *trackingArea;

@end

@implementation MXTableViewRowView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    if (self.trackingArea)
    {
        [self removeTrackingArea:self.trackingArea];
    }
    self.trackingArea = [[NSTrackingArea alloc] initWithRect:dirtyRect options:(NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow ) owner:self userInfo:nil];
    [self addTrackingArea:self.trackingArea];
}

/**
 color for select

 @param dirtyRect dirtyRect description
 */
-(void)drawSelectionInRect:(NSRect)dirtyRect
{
    if (self.selectionHighlightStyle != NSTableViewSelectionHighlightStyleNone)
    {
        [self.selectedColor setFill];
        NSBezierPath *path = [NSBezierPath bezierPathWithRect:NSInsetRect(self.bounds, 0, 0)];
        [path fill];
        [path stroke];
    }
}

/**
 background color

 @param backgroundColor backgroundColor description
 */
- (void)setBackgroundColor:(NSColor *)backgroundColor
{
    super.backgroundColor = [NSColor whiteColor];
}

#pragma mark - mouse releated
-(void)mouseMoved:(NSEvent *)event
{
    super.backgroundColor = self.selectedColor;
}

-(void)mouseExited:(NSEvent *)event
{
    super.backgroundColor = [NSColor whiteColor];
}

@end
