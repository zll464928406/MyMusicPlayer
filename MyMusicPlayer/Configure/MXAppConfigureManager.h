//
//  MXAppConfigureManager.h
//  MyMusicPlayer
//
//  Created by sunny on 2018/7/3.
//  Copyright © 2018年 moxtra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface MXAppConfigureManager : NSObject

@property (nonatomic, strong) NSColor *backgroundColor;

+ (instancetype)sharedInstace;

@end
