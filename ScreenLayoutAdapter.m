//
//  ScreenLayoutAdapter.m
//  微信朋友圈
//
//  Created by 刘森 on 16/3/7.
//  Copyright © 2016年 刘森. All rights reserved.
//

#import "ScreenLayoutAdapter.h"

@implementation ScreenLayoutAdapter


+ (CGFloat)changeScreenLayoutRefer:(CGFloat)referFloat referWithHeight:(CGFloat)referToHeight ScreenHeight:(CGFloat)ScreenHeight
{
    if (referFloat == 0) {
        return 0;
    }
    CGFloat result = 0;
    CGFloat scale = 0;
    if (referToHeight == 2208) {
        if (ScreenHeight == 480) {
            scale = 0.515;
            result = referFloat * scale * (0.5);
            return result;
        } else if (ScreenHeight == 568) {
            scale = 0.515;
            result = referFloat * scale * (0.5);
            return result;
        } else if (ScreenHeight == 667) {
            scale = 0.604;
            result = referFloat * scale * (0.5);
            return result;
        } else if (ScreenHeight == 736) {
            scale = 0.333;
            result = referFloat * scale;
            return result;
        }
    }
    
    return result;
}




@end
