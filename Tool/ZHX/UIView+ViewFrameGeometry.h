//
//  UIView+ViewFrameGeometry.h
//  Cinderella
//
//  Created by mac on 15/5/30.
//  Copyright (c) 2015年 cloudstruct. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ViewFrameGeometry)
@property CGPoint origin;
@property CGSize size;

@property(readonly) CGPoint midpoint;

@property(readonly) CGPoint bottomLeft;
@property(readonly) CGPoint bottomRight;
@property(readonly) CGPoint topRight;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

- (void)moveBy:(CGPoint)delta;

- (void)scaleBy:(CGFloat)scaleFactor;

- (void)fitInSize:(CGSize)aSize;

- (void)setY:(CGFloat)y;
- (void)setX:(CGFloat)x;

- (void)removeAllSubviews;

@end
