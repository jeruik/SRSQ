//
//  UIView+Extension.h
//  MJRefreshExample
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

NS_ASSUME_NONNULL_BEGIN

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;

/**
 *  获取左上角横坐标
 *
 *  @return 坐标值
 */
- (CGFloat)left;

/**
 *  获取左上角纵坐标
 *
 *  @return 坐标值
 */
- (CGFloat)top;

/**
 *  获取视图右下角横坐标
 *
 *  @return 坐标值
 */
- (CGFloat)right;

/**
 *  获取视图右下角纵坐标
 *
 *  @return 坐标值
 */
- (CGFloat)bottom;

/**
 *  获取视图宽度
 *
 *  @return 宽度值（像素）
 */
- (CGFloat)width;

/**
 *  获取视图高度
 *
 *  @return 高度值（像素）
 */
- (CGFloat)height;

/**
 *	@brief	删除所有子对象
 */
- (void)removeAllSubviews;

/**
 *  快速修改对象的单个属性值
 *
 *  @param view  要修改的view、imageView、button、...
 *  @param key   要修改的属性，例如：@"x",@"y",@"w",@"h"
 *  @param value 被修改属性的新值
 */
- (void)frameSet:(NSString *)key value:(CGFloat)value;

/**
 *  快速修改对象的多个属性值
 *
 *  @param view   要修改的view、imageView、button、...
 *  @param key1   要修改的属性1，例如：@"x",@"y",@"w",@"h"
 *  @param value1 属性1的新值
 *  @param key2   要修改的属性2，例如：@"x",@"y",@"w",@"h"
 *  @param value2 属性2的新值
 */
- (void)frameSet:(NSString *)key1 value1:(CGFloat)value1 key2:(NSString *)key2 value2:(CGFloat)value2;

/**
 *  从 bundle 加载一个 view
 *
 *  @param className 类名称
 *
 *  @return 返回一个 view
 */
+ (instancetype)viewFromBundle;

/**  得到一条横线 */
- (UIView *)getLineView;

/**
 *  屏幕截图到指定区域
 */
- (UIImage*)screenshotInRect:(CGRect)rcct;
+ (instancetype)viewFromXib;
/**
 *  根据点击的 view 找到合适的控制器
 */
- (__kindof UIViewController*)findViewControler;
/**
 *  点击事件
 */
- (void)addTarget:(nonnull id)target action:(nonnull SEL)action;

/**
 *  判断一个点是否是在view 上边
 *
 *  @param locationPoint
 */
- (BOOL)pointInView:(CGPoint)locationPoint;

@end


NS_ASSUME_NONNULL_END
