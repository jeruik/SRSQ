//
//  CYLayoutConstraint.m
//  Junengwan
//
//  Created by 董招兵 on 16/2/25.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import "CYLayoutConstraint.h"
#import "ScreenLayoutAdapter.h"

@interface CYLayoutConstraint ()

@end

@implementation CYLayoutConstraint

+ (instancetype)shareInstance
{
    static CYLayoutConstraint *_constraint;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _constraint = [[CYLayoutConstraint alloc] init];
        _constraint->_deviceType = [_constraint currentDeviceType];
    });
    return _constraint;
}

/**  以6p 作为基础来计算其他屏幕的约束 */
+ (CGFloat)getConstrainlWithValue:(CGFloat)value
{
    CYLayoutConstraint *layoutConstraint = [self shareInstance];
    CGFloat constraint = 0;
    switch (layoutConstraint.deviceType) {
        case CYDeviceTypeIphone6:
            constraint = (CGFloat)((value *0.60335196f)/2);
            break ;
        case CYDeviceTypeIphone6p:
            constraint = (CGFloat)(value/3);
            break;
        default:
            constraint = (CGFloat)((value *0.51396648f)/2);
            break;
    }
    return constraint;
}

/**  根据不同屏幕尺寸得到一个相对应的 font */
+ (UIFont * _Nullable)getAdjustsFont:(CGFloat)fontSize {
    return [UIFont systemFontOfSize:[self getAdjustFontSize:fontSize]];
}

+ (CGFloat)getAdjustFontSize:(CGFloat)fontSize
{
    CYLayoutConstraint *layoutConstraint = [self shareInstance];
    CGFloat size = 0.0f;
    switch (layoutConstraint.deviceType) {
        case CYDeviceTypeIphone6:
            size = (fontSize *0.9);
            break ;
        case CYDeviceTypeIphone6p:
            size = fontSize;
            break ;
        default:
            size = (fontSize *0.7);
            break ;
    }
    return size;
}
/**
 *  当前设备型号
 */
- (CYDeviceType)currentDeviceType {
    if (DEF_SCREEN_HEIGHT == 480.0f) {
        return CYDeviceTypeIphone4s;
    }else if (DEF_SCREEN_HEIGHT == 568.0f){
        return CYDeviceTypeIphone5s;
    }else if (DEF_SCREEN_HEIGHT == 667.0f) {
        return CYDeviceTypeIphone6;
    }
    return CYDeviceTypeIphone6p;
}
/**
 *  根据标准得到一个合适的字体
 */
+ (CGFloat)getConstrainlFontSize:(CGFloat)size {
    
    CGFloat currentSize = [self changeScreenLayoutRefer:size referWithHeight:2208 ScreenHeight:[UIScreen mainScreen].bounds.size.height];
    return currentSize;
}
/**
 *  计算不同屏幕下字体尺寸的大小
 */
+ (CGFloat)changeScreenLayoutRefer:(CGFloat)referFloat
                   referWithHeight:(CGFloat)referToHeight
                      ScreenHeight:(CGFloat)ScreenHeight {
    if (referFloat == 0) {
        return 0;
    }
    CGFloat result = 0;
    CGFloat scale = 0;
    CYLayoutConstraint *layoutConstraint = [self shareInstance];
    switch (layoutConstraint.deviceType) {
        case CYDeviceTypeIphone6:
        {
            scale = 0.60335196f;
            result = referFloat * scale * (0.5);
        }
            break;
        case CYDeviceTypeIphone6p:
        {
            scale = 0.333f;
            result = referFloat * scale;
        }
            break;
        default:
        {
            scale = 0.515f;
            result = referFloat * scale * (0.5);
        }
            break;
    }
    return result;
}

+ (UIFont *_Nullable)getConstrainlFont:(CGFloat)size {
    UIFont *font = [UIFont systemFontOfSize:[self getConstrainlFontSize:size]];
    return font;
}

@end
