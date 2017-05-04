//
//  UIView+Extension.m
//  MJRefreshExample
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}
- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)y
{
    return self.frame.origin.y;
}
- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)width
{
    return self.frame.size.width;
}
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)height
{
    return self.frame.size.height;
}
- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)size
{
    return self.frame.size;
}
- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (CGFloat)top
{
    return self.frame.origin.y;
    
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}
- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}
- (void)removeAllSubviews
{
    while (self.subviews.count)
    {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

- (void)frameSet:(NSString *)key value:(CGFloat)value
{
    CGRect rect = self.frame;
    if ([@"x" isEqualToString:key]) {
        rect.origin.x = value;
        
    } else if ([@"y" isEqualToString:key]) {
        rect.origin.y = value;
        
    } else if ([@"w" isEqualToString:key]) {
        rect.size.width = value;
        
    } else if ([@"h" isEqualToString:key]) {
        rect.size.height = value;
    }
    self.frame = rect;
}
- (void)frameSet:(NSString *)key1 value1:(CGFloat)value1 key2:(NSString *)key2 value2:(CGFloat)value2
{
    [self frameSet:key1 value:value1];
    [self frameSet:key2 value:value2];
}
/**
 *  从 bundle 加载一个 view
 *
 *  @param name 名字
 *
 *  @return 返回一个 view
 */
+ (instancetype)viewFromBundle
{
    NSString *className = NSStringFromClass([self class]);
    id object = [[[NSBundle mainBundle]loadNibNamed:className owner:nil options:nil]lastObject];
    if ([object isKindOfClass:[self class]]) {
        return object;
    }
    return  nil;
}
+ (instancetype)viewFromXib {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}
/**  得到一条横线 */
- (UIView *)getLineView {
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    bottomLine.alpha   = 0.5;
    [self addSubview:bottomLine];
    return bottomLine;
}

- (UIImage *)screenshotInRect:(CGRect)rcct {

    // 1.开启位图上下文
    UIGraphicsBeginImageContext(rcct.size);
    // 2.当前控制器的view画在位图上下文
    // render 渲染
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    // 3.获取图片
    UIImage *captureImg = UIGraphicsGetImageFromCurrentImageContext();
    // 4.结束位图编辑
    UIGraphicsEndImageContext();
    NSData *data = UIImageJPEGRepresentation(captureImg, 1);
    [data writeToFile:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] atomically:YES];
    
    return captureImg;
}

/**
 *  点击事件
 */
- (void)addTarget:(nonnull id)target action:(nonnull SEL)action
{
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:target action:action]];
}

/**
 *  根据点击的 view 找到合适的控制器
 */
- (__kindof UIViewController*)findViewControler
{
    id target = self;
    while (target) {
        target = [(UIResponder*)target nextResponder];
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

/**
 *  判断一个点是否是在view 上边
 *
 *  @param locationPoint
 */
- (BOOL)pointInView:(CGPoint)locationPoint {
    
    CGFloat top         = self.top;
    CGFloat left        = self.left;
    CGFloat bottom      = self.bottom;
    CGFloat right       = self.right;
    if (locationPoint.x>=left && locationPoint.x<= right && locationPoint.y >= top && locationPoint.y <= bottom) {
        return YES;
    }
    return NO;
}
@end
