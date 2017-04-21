//
//  EmotionTool.m
//  小菜微博
//
//  Created by 蔡凌云 on 15-6-30.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import "EmotionTool.h"
#import "EmotionModel.h"
#import "MJExtension.h"
//最近表情的存储路径
#define RecentEmotionsPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"emotionss.archive"]

@implementation EmotionTool

static NSMutableArray *_recentEmotions;

+ (void)initialize
{
    //加载沙盒中得表情数据
    _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:RecentEmotionsPath];
    if (_recentEmotions == nil) {
        _recentEmotions = [NSMutableArray array];
      }
}

+ (void)addRecentEmotion:(EmotionModel *)emotion
{
    [_recentEmotions removeObject:emotion];
    
    //将表情插到数组最前面
    [_recentEmotions insertObject:emotion atIndex:0];
    
    //将所有表情数据写入沙盒
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:RecentEmotionsPath];
}

+ (NSArray *)recentEmotions
{

    return _recentEmotions;
}

static NSArray *_emojiEmotions, *_defaultEmotions, *_lxhEmotions;

+ (NSArray *)emojiEmotions
{
    if (!_emojiEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/infoe.plist" ofType:nil];
        _emojiEmotions = [EmotionModel objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _emojiEmotions;
}

+ (NSArray *)defaultEmotions
{
    if (!_defaultEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/infoe.plist" ofType:nil];
        _defaultEmotions = [EmotionModel objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _defaultEmotions;
}

+ (NSArray *)lxhEmotions
{
    if (!_lxhEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/infoe.plist" ofType:nil];
        _lxhEmotions = [EmotionModel objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _lxhEmotions;
}

+ (EmotionModel *)emotionWithChs:(NSString *)chs
{
    NSArray *defaults = [self defaultEmotions];
    for (EmotionModel *emotion in defaults) {
        if ([emotion.chs isEqualToString:chs]) return emotion;
    }
    
    NSArray *lxhs = [self lxhEmotions];
    for (EmotionModel *emotion in lxhs) {
        if ([emotion.chs isEqualToString:chs]) return emotion;
    }
    return nil;
}

@end
