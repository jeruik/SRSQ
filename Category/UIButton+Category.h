//
//  UIButton+Category.h
//  missnow
//
//  Created by nimingM on 16/4/13.
//  Copyright © 2016年 dantou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Category)
/**
 *  快捷创建按钮
 *
 *  @param title  标题
 *  @param target 监听者
 *  @param action 监听方法
 *  @param height 圆角高度
 *
 *  @return 返回创建好的按钮
 */
+ (UIButton *)buttonWithTitle:( NSString *)title target:(id)target action:(SEL)action height:(CGFloat)height;
/**
 *  快捷创建按钮
 */
+ (UIButton *)initWithButton:(NSString *)title image:(NSString *)imageName backGroundColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius target:(id)target sel:(SEL)sel;
/**
 *  快捷创建按钮(适应文字图片上下排列)
 */
+ (UIButton *)buttonWithTitle:(NSString *)title image:(NSString *)imageName backGroundColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius target:(id)target sel:(SEL)sel;
- (void)setCornerRadius:(CGFloat)cornerRadius;
- (void)setborderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color;
@end
