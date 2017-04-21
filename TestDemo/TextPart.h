//
//  TextPart.h
//  小菜微博
//
//  Created by 蔡凌云 on 15-7-5.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//  这个模型用来存放带有属性的字符串

#import <Foundation/Foundation.h>

@interface TextPart : NSObject

/** 这段文字的内容 */
@property (nonatomic, copy) NSString *text;
/** 这段文字的范围 */
@property (nonatomic, assign) NSRange range;
/** 是否为特殊文字 */
@property (nonatomic, assign, getter = isSpecical) BOOL special;
/** 是否为表情 */
@property (nonatomic, assign, getter = isEmotion) BOOL emotion;

@end
