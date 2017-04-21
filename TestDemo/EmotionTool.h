//
//  EmotionTool.h
//  小菜微博
//
//  Created by 蔡凌云 on 15-6-30.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EmotionModel;
@interface EmotionTool : NSObject

//添加最近表情
+ (void)addRecentEmotion:(EmotionModel *)emotion;

//最近表情数组
+ (NSArray *)recentEmotions;
+ (NSArray *)emojiEmotions;
+ (NSArray *)defaultEmotions;
+ (NSArray *)lxhEmotions;

+ (EmotionModel *)emotionWithChs:(NSString *)chs;
@end
