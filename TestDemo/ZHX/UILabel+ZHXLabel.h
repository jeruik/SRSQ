//
//  UILabel+ZHXLabel.h
//  missnow
//
//  Created by nimingM on 16/5/8.
//  Copyright © 2016年 dantou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ZHXLabel)

/**
 *  快捷创建Label
 *
 *  @param labelText       label文字
 *  @param fontSize        label字体
 *  @param textColor       label文字颜色
 *  @param backGroundColor label背景颜色
 *  @param target          监听者
 *  @param action          监听方法
 *
 *  @return 返回一个创建好的label
 */
+ (UILabel *)ZHXLabelLabelText:(NSString *)labelText font:(CGFloat)fontSize textColor:(UIColor *)textColor backGroundColor:(UIColor *)backGroundColor target:(id)target sel:(SEL)action;

@end
