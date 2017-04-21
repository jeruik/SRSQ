//
//  TextInputView.h
//  0001-微博-框架搭建
//
//  Created by 蔡凌云 on 15-6-27.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextInputView : UITextView

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, strong) UIColor *placeholderColor;

@end
