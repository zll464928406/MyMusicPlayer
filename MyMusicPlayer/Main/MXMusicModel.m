//
//  MXMusicModel.m
//  MyMusicPlayer
//
//  Created by sunny on 2018/7/2.
//  Copyright © 2018年 moxtra. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MXMusicModel.h"

@implementation MXMusicModel

-(instancetype)initWithFile:(NSURL *)url
{
    if (self=[super init])
    {
        self.fileURL = url;
        NSDictionary *musicDic = [self fetchMusicInfoFromFile:url];
        self.title = musicDic[@"title"];
        self.artist = musicDic[@"artist"];
        self.comments = musicDic[@"comments"];
        self.duration = [musicDic[@"approximate duration in seconds"] doubleValue];
    }
    
    return self;
}

- (NSData *)readData
{
    return [NSData dataWithContentsOfURL:self.fileURL];
}

- (NSDictionary *)fetchMusicInfoFromFile:(NSURL *)fileName
{
    NSDictionary *resultDic;
    //    NSURL *audioURL = [NSURL fileURLWithPath:fileName];
    AudioFileID audioFile;
    OSStatus theErr = noErr;
    theErr = AudioFileOpenURL((__bridge CFURLRef)fileName,
                              kAudioFileReadPermission,
                              0,
                              &audioFile);
    assert (theErr == noErr);
    UInt32 dictionarySize = 0;
    theErr = AudioFileGetPropertyInfo (audioFile,
                                       kAudioFilePropertyInfoDictionary,
                                       &dictionarySize,
                                       0);
    assert (theErr == noErr);
    CFDictionaryRef dictionary;
    theErr = AudioFileGetProperty (audioFile,
                                   kAudioFilePropertyInfoDictionary,
                                   &dictionarySize,
                                   &dictionary);
    assert (theErr == noErr);
    resultDic = (__bridge NSDictionary *)(dictionary);  //Convert
    CFRelease (dictionary);
    theErr = AudioFileClose (audioFile);
    assert (theErr == noErr);
    
    return resultDic;
}


-(void)getMp3InformationFromFile:(NSString *)filePath
{
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSString *fileExtension = [[fileUrl path] pathExtension];
    if ([fileExtension isEqualToString:@"mp3"])
    {
        AudioFileID fileID = nil;
        OSStatus error = noErr;
        
        error = AudioFileOpenURL((__bridge CFURLRef)fileUrl, kAudioFileReadPermission, 0, &fileID);
        if (error != noErr)
        {
            NSLog(@"open error");
        }
        
        UInt32 id3DataSize = 0;
        error = AudioFileGetPropertyInfo(fileID, kAudioFilePropertyID3Tag, &id3DataSize, NULL);
        if (error != noErr)
        {
            NSLog(@"AudioFileGetPropertyInfo Failed!");
        }
        
        NSDictionary *musicDict = nil;
        UInt32 piDataSize = sizeof(musicDict);
        error = AudioFileGetProperty(fileID, kAudioFilePropertyInfoDictionary, &piDataSize, &musicDict);
        if (error != noErr)
        {
            NSLog(@"AudioFileGetProperty Failed!");
        }
        
        CFDataRef albumPic = nil;
        UInt32 picDataSize = sizeof(albumPic);
        error = AudioFileGetProperty(fileID, kAudioFilePropertyAlbumArtwork, &picDataSize, &albumPic);
        if (error != noErr) {
            NSLog(@"AudioFileGetProperty failed!(album)");
        }
        
        NSData *imageData = (__bridge NSData *)albumPic;
        
        NSImage *img = [[NSImage alloc] initWithData:imageData];
        self.iconImage = img;
        
        NSString *album = [(NSDictionary *)musicDict objectForKey:[NSString stringWithUTF8String:kAFInfoDictionary_Album]];
        NSString *artlist = [(NSDictionary *)musicDict objectForKey:[NSString stringWithUTF8String:kAFInfoDictionary_Artist]];
        NSString *title = [(NSDictionary *)musicDict objectForKey:@kAFInfoDictionary_Title];
    }
}


@end
