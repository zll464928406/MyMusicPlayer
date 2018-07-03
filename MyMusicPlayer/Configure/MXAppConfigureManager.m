//
//  MXAppConfigureManager.m
//  MyMusicPlayer
//
//  Created by sunny on 2018/7/3.
//  Copyright © 2018年 moxtra. All rights reserved.
//

#import "MXAppConfigureManager.h"

@implementation MXAppConfigureManager

+ (instancetype)sharedInstace
{
    static MXAppConfigureManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MXAppConfigureManager alloc] init];
    });
    
    return instance;
}

-(NSColor *)backgroundColor
{
    return [NSColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1.0];
}


@end
