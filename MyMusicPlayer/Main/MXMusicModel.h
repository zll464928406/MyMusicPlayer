//
//  MXMusicModel.h
//  MyMusicPlayer
//
//  Created by sunny on 2018/7/2.
//  Copyright © 2018年 moxtra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXMusicModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *comments;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, strong) NSImage *iconImage;
@property (nonatomic, strong) NSURL *fileURL;

- (instancetype)initWithFile:(NSURL *)url;
- (NSData *)readData;

@end
