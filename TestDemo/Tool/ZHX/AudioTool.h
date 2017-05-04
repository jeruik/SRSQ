//
//  AudioTool.h
//  25-音频处理
//
//  Created by 蔡凌云 on 15-7-10.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioTool : NSObject

/**
 *  是否正在播放当前音乐
 *
 *  @param filename 音乐的文件名
 */

+ (BOOL)playMusic:(NSString *)filename audioDurtion:(void(^)(NSInteger time))durtionBlock;

/**
 *  停止正在播放当前音乐
 *
 *  @param filename 音乐的文件名
 */

+ (void)pauseMusic:(NSString *)filename;
/**
 *  停止音乐
 */
+ (void)stopMusic:(NSString *)filename;

+ (void)removeAllPlayer;

/**
 *  播放音效 (音效一般比较短暂，没有暂停功能)
 *
 *  @param filename 音效的文件名
 */
+ (void)playSound:(NSString *)filename;
/**
 *  销毁音效
 *
 *  @param filename 音效的文件名
 */
+ (void)disposeSound:(NSString *)filename;
@end
