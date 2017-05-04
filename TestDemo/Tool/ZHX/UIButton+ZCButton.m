//
//  UIButton+ZCButton.m
//  missnow
//
//  Created by nimingM on 16/5/8.
//  Copyright © 2016年 dantou. All rights reserved.
//

#import "UIButton+ZCButton.h"

@implementation UIButton (ZCButton)

+ (UIButton *)ZCButton:(NSString *)title image:(NSString *)imageName backGroundColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius target:(id)target sel:(SEL)sel {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:imageName ? imageName : @"zhxBtnBg"] forState:UIControlStateNormal];
    [btn setBackgroundColor:color];
    btn.layer.cornerRadius = cornerRadius/2;
    btn.layer.masksToBounds = YES;
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

@end
