//
//  ThemeHelper.m
//  TestDemo
//
//  Created by 小菜 on 17/3/9.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "ThemeHelper.h"

@implementation ThemeHelper

+ (UIColor *)theme {
    NSString *color = [[NSUserDefaults standardUserDefaults] objectForKey:@"color"];
    if (color.length > 1) {
        return HexColor(color);
    } else {
        return HexColor(@"FC6E5E");
    }
}

@end
