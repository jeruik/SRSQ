//
//  UILabel+ZHXLabel.m
//  missnow
//
//  Created by nimingM on 16/5/8.
//  Copyright © 2016年 dantou. All rights reserved.
//

#import "UILabel+ZHXLabel.h"

@implementation UILabel (ZHXLabel)

+ (UILabel *)ZHXLabelLabelText:(NSString *)labelText font:(CGFloat)fontSize textColor:(UIColor *)textColor backGroundColor:(UIColor *)backGroundColor target:(id)target sel:(SEL)action {

    UILabel *lab =[[UILabel alloc] init];
    lab.text = labelText ? labelText : @"";
    [lab sizeToFit];
    lab.numberOfLines =0;
    lab.textColor = textColor ? textColor : [UIColor blackColor];
    lab.backgroundColor = backGroundColor ? backGroundColor : [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.userInteractionEnabled = YES;
    lab.font = [UIFont systemFontOfSize:fontSize ? fontSize : 10];
    if (target && action) {
        [lab addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:target action:action]];
    }
    
    return lab;
}
@end
