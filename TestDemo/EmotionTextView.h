//
//  EmotionTextView.h
//  小菜微博
//
//  Created by 蔡凌云 on 15-6-30.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//  插入字符View

#import "TextInputView.h"

@class EmotionModel;

@interface EmotionTextView : TextInputView

- (void)insertEmotion:(EmotionModel *)emotion;


- (NSString *)fullText;
@end
