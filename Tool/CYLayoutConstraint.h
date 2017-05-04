//
//  CYLayoutConstraint.h
//  Junengwan
//
//  Created by 董招兵 on 16/2/25.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  主屏的宽
 */
#define DEF_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

/**
 *  主屏的高
 */
#define DEF_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

/**
 *  主屏的size
 */
#define DEF_SCREEN_SIZE   [[UIScreen mainScreen] bounds].size
// 根据比例设置约束
#define CYLayoutConstraintEqualTo(constraint)   [CYLayoutConstraint getConstrainlWithValue:constraint]
/// 设置不同的尺寸的字体对象
#define CYAdjustFont(fontSize)                  [CYLayoutConstraint getAdjustsFont:fontSize]
// 得到一个不同字体的字号大小
#define CYAdjuestFontSize(size)                 [CYLayoutConstraint getAdjustFontSize:size]
// 根据 UI标注的字体 px 换算成实际的 font
#define CYLayountConstraintFontSize(size)       [CYLayoutConstraint getConstrainlFontSize:size]

#define CYLayoutConstranitFont(size)            [CYLayoutConstraint getConstrainlFont:size]

typedef NS_ENUM(NSInteger,CYDeviceType) {
    /** iphone4s */
    CYDeviceTypeIphone4s,
    /** iphone5s */
    CYDeviceTypeIphone5s,
    /** iphone6 */
    CYDeviceTypeIphone6,
    /** iphone6p */
    CYDeviceTypeIphone6p
};

/**
 *  AutoLayout提高约束计算的类
 */
@interface CYLayoutConstraint : NSObject

/**  返回一个单例 */
+ (_Nullable instancetype)shareInstance;
/**  以6p 作为基础来计算其他屏幕的约束 */
+ (CGFloat)getConstrainlWithValue:(CGFloat)value;
/**  根据不同屏幕尺寸得到一个相对应的 font */
+ (UIFont * _Nullable)getAdjustsFont:(CGFloat)fontSize;
/**  得到字体的字号大小 */
+ (CGFloat)getAdjustFontSize:(CGFloat)fontSize;
/**
 *  根据 UI标注的字体 px 换算成实际的 font
 */
+ (CGFloat )getConstrainlFontSize:(CGFloat)size;

+ (UIFont *_Nullable)getConstrainlFont:(CGFloat)size;

/**  当前的设备型号 */
@property (nonatomic,assign,readonly)CYDeviceType deviceType;


@end
