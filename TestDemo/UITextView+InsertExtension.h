//
//  UITextView+InsertExtension.h
//  小菜微博
//
//  Created by 蔡凌云 on 15-6-30.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//  插入文字到光标

#import <UIKit/UIKit.h>

@interface UITextView (InsertExtension)

/** 插入文字到光标 */
- (void)insertAttributeText:(NSAttributedString *)text;

- (void)insertAttributeText:(NSAttributedString *)text settingBlock:(void(^)(NSMutableAttributedString *attributedText))settingBlock;

@end
