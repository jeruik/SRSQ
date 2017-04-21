
//
//  EmoltionAttachment.m
//  小菜微博
//
//  Created by 蔡凌云 on 15-6-30.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import "EmoltionAttachment.h"
#import "EmotionModel.h"
@implementation EmoltionAttachment

- (void)setEmotion:(EmotionModel *)emotion
{
    _emotion = emotion;
    
    self.image = [UIImage imageNamed:emotion.png];
}

@end
