//
//  EmotionTabbarButton.m
//  0001-微博-框架搭建
//
//  Created by 蔡凌云 on 15-6-28.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import "EmotionTabbarButton.h"

@implementation EmotionTabbarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       //设置文字颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        
        self.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    //实现这个方法按钮就没有高亮效果
}

@end
