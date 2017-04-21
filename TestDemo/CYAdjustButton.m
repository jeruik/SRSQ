//
//  CYAdjustButton.m
//  Junengwan
//
//  Created by 董招兵 on 16/3/10.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import "CYAdjustButton.h"

@interface CYAdjustButton  ()

@end

@implementation CYAdjustButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self setup];
        
    }
    return self;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment  = textAlignment;
    self.titleLabel.textAlignment = _textAlignment;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont  = titleFont;
    self.titleLabel.font    = _titleFont;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _titleLabelFrame = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
    _imageViewFrame = CGRectMake(10.0f, 0.0f, 10.0f, 10.0f);
    _highLightEnable    = YES;
}

- (void)setImageViewFrame:(CGRect)frame {
    _imageViewFrame = frame;
    [self setNeedsDisplay];
}

- (void)setTitleLabelFrame:(CGRect)frame {
    _titleLabelFrame = frame;
    [self setNeedsDisplay];
}

/**
 *  只设置图片,而且显示位置居中
 */
- (void)setImageViewSizeEqualToCenter:(CGSize)size {
    self.imageViewFrame = CGRectMake((self.frame.size.width-size.width)/2,( self.frame.size.height-size.height)/2, size.width, size.height);
    [self setNeedsLayout];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return self.imageViewFrame;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return self.titleLabelFrame;
}

- (void)setHighlighted:(BOOL)highlighted {
    if (!self.highLightEnable) return;
    [super setHighlighted:highlighted];
}
@end
