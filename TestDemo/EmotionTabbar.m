//
//  EmotionTabbar.m
//  0001-微博-框架搭建
//
//  Created by 蔡凌云 on 15-6-28.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import "EmotionTabbar.h"
#import "EmotionTabbarButton.h"

@interface EmotionTabbar ()
@property (nonatomic, weak) EmotionTabbarButton *selectedBtn;
@end
@implementation EmotionTabbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self setUpBtn:@"最近" buttonType:EmotionTabBarButtonTypeRecent];
//        [self setUpBtn:@"默认" buttonType:EmotionTabBarButtonTypeDefault];
        [self setUpBtn:@"Emoji" buttonType:EmotionTabBarButtonTypeEmoji];
//        [self setUpBtn:@"浪小花" buttonType:EmotionTabBarButtonTypeLxh];
        
    }
    return self;
}

/**
 *  创建一个按钮  快捷方法
 */

- (EmotionTabbarButton *)setUpBtn:(NSString *)title buttonType:(EmotionTabBarButtonType)buttontype
{
    EmotionTabbarButton *btn = [[EmotionTabbarButton alloc] init];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    btn.tag = buttontype;
    [btn setTitle:title forState:UIControlStateNormal];
    [self addSubview:btn];
    
    //默认选中"默认"按钮
    if (buttontype == EmotionTabBarButtonTypeEmoji) {
        [self btnClick:btn];
    }
    
    //设置背景图片
    NSString *image = @"compose_emotion_table_mid_normal";
    NSString *selectImage = @"compose_emotion_table_mid_selected";
    if (self.subviews.count == 1) {
        image = @"compose_emotion_table_left_normal";
        selectImage = @"compose_emotion_table_left_selected";
    } else if (self.subviews.count == 4) {
        image = @"compose_emotion_table_right_normal";
        selectImage = @"compose_emotion_table_right_selected";
    }
    
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateDisabled];
    
    return btn;
}

- (void)btnClick:(EmotionTabbarButton *)btn
{
    //三部曲
    
    self.selectedBtn.enabled = YES;
    btn.enabled = NO;
    self.selectedBtn = btn;
    
    //通知代理
    if ([self.delegate respondsToSelector:@selector(emotionTabbar:didSelectButton:)]) {
        [self.delegate emotionTabbar:self didSelectButton:btn.tag];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置按钮的frame
    NSUInteger btnCount = self.subviews.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i<btnCount; i++) {
        EmotionTabbarButton *btn = self.subviews[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i * btnW;
        btn.height = btnH;
    }
}

- (void)setDelegate:(id<EmotionTabbarDelegate>)delegate
{
    _delegate = delegate;
    
    //选中默认按钮
    [self btnClick:(EmotionTabbarButton *)[self viewWithTag:EmotionTabBarButtonTypeEmoji]];
}

@end
