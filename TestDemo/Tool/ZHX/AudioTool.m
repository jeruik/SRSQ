
//
//  AudioTool.m
//  25-音频处理
//
//  Created by 蔡凌云 on 15-7-10.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import "AudioTool.h"
#import <AVFoundation/AVFoundation.h>
@implementation AudioTool

/**
 *  存放所有音效的ID
 */

static NSMutableDictionary *_soundIDs;

+ (NSMutableDictionary *)soundIDs
{
    if (!_soundIDs) {
        _soundIDs = [NSMutableDictionary dictionary];
    }
    return _soundIDs;
}
/**
 *  存放所有的音乐播放器，一个播放器只能播放一个音效文件
 */
static NSMutableDictionary *_musicPlayers;
+ (NSMutableDictionary *)musicPlayers
{
    if (!_musicPlayers) {
        _musicPlayers = [NSMutableDictionary dictionary];
    }
    return _musicPlayers;
}
/**
 *  播放音乐
 *
 *  @param filename 音乐的文件名
 */
+ (BOOL)playMusic:(NSString *)filename audioDurtion:(void (^)(NSInteger time))durtionBlock
{
    if (!filename) return NO;
    
    // 1.取出对应的播放器，进行初始化
    AVAudioPlayer *player = [self musicPlayers][filename]; //这个播放器字典对应音乐文件名
    
    // 2.播放器没有创建，进行初始化
    if (!player) {
        NSURL *url = [NSURL URLWithString:filename];
        if (url == nil)  return NO;
        
        //创建播放器（一个AVAudioPlayer只能播放一个URL）
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        NSInteger time = round(player.duration);
        if (durtionBlock) {
            durtionBlock(time);
        }
        //缓冲
        if (![player prepareToPlay]) return NO;  //如果内有缓冲直接返回no
        
        //存入字典
        [self musicPlayers][filename] = player;  //这个字典里面的这个音频文件名key对应播放器这个值
    }
    
    // 3.播放
    if (!player.isPlaying) {
        return [player play];
    }
    
    //这在播放
    return YES;
}

/**
 *  暂停
 */
+ (void)pauseMusic:(NSString *)filename
{
    if (!filename) return;
    AVAudioPlayer *player = [self musicPlayers][filename];
    if (player.isPlaying) [player pause];
    
}
/**
 *  停止音乐
 */
+ (void)stopMusic:(NSString *)filename
{
    if (!filename) return;

    
    // 1.取出对应的播放器 (对应的文件名取出对应的播放器key)
    AVAudioPlayer *player = [self musicPlayers][filename];
    
    // 2.停止
    [player stop];
    
    // 3.从字典中移除
    [[self musicPlayers] removeObjectForKey:filename];
}
+ (void)removeAllPlayer {
    [[self musicPlayers] enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        // 1.取出对应的播放器 (对应的文件名取出对应的播放器key)
        AVAudioPlayer *player = [self musicPlayers][key];
        // 2.停止
        [player stop];
        // 3.从字典中移除
        [[self musicPlayers] removeObjectForKey:key];
    }];
}
/**
 *  播放音效
 */

+ (void)playSound:(NSString *)filename
{
     if (!filename) return;
    
    
    //取出音效对应的ID
    SystemSoundID soundID = [[self soundIDs][filename] unsignedLongValue];
    
    if (!soundID) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        if (!url) return;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        
        //存入字典
        [self soundIDs][filename] = @(soundID);
    }
    //播放音效
    AudioServicesPlaySystemSound(soundID);
    
}

/**
 *  销毁音效
 */

+ (void)disposeSound:(NSString *)filename
{
    if (!filename) return;
    
    SystemSoundID soundID = [[self soundIDs][filename] unsignedLongValue];
    
    if (soundID) {
        //销毁
        AudioServicesDisposeSystemSoundID(soundID);
        
        //移除
        [[self soundIDs] removeObjectForKey:filename];
    }
}

@end
