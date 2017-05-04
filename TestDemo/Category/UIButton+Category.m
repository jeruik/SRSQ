//
//  UIButton+Category.m
//  missnow
//
//  Created by nimingM on 16/4/13.
//  Copyright © 2016年 dantou. All rights reserved.
//

#import "UIButton+Category.h"

@implementation UIButton (Category)

+ (UIButton *)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action height:(CGFloat)height {
    
    UIButton *btn          = [[UIButton alloc] init];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    btn.layer.cornerRadius = height / 2;
    btn.clipsToBounds      = YES;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font    = [UIFont systemFontOfSize:14];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (UIButton *)initWithButton:(NSString *)title image:(NSString *)imageName backGroundColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius target:(id)target sel:(SEL)sel {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:imageName ? imageName : @"zhxBtnBg"] forState:UIControlStateNormal];
    [btn setBackgroundColor:color];
    btn.layer.cornerRadius = cornerRadius/2;
    btn.layer.masksToBounds = YES;
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
+ (UIButton *)buttonWithTitle:(NSString *)title image:(NSString *)imageName backGroundColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius target:(id)target sel:(SEL)sel {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName ? imageName : @""] forState:UIControlStateNormal];
    [btn setBackgroundColor:color];
    btn.layer.cornerRadius = cornerRadius/2;
    btn.layer.masksToBounds = YES;
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
}
- (void)setborderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color {
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = color.CGColor;
}
@end
