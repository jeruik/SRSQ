//
//  UIButton+ZCButton.h
//  missnow
//
//  Created by nimingM on 16/5/8.
//  Copyright © 2016年 dantou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ZCButton)

+ (UIButton *)ZCButton:(NSString *)title image:(NSString *)imageName backGroundColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius target:(id)target sel:(SEL)sel;

@end
