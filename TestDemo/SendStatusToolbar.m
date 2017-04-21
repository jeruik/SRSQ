//
//  SendStatusToolbar.m
//  0001-微博-框架搭建
//
//  Created by 蔡凌云 on 15-6-27.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import "SendStatusToolbar.h"

@interface SendStatusToolbar ()

@property (nonatomic, weak) UIButton *emotionButton;

@end

@implementation SendStatusToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        // 初始化按钮
        [self setupBtn:@"compose_camerabutton_background" highImage:@"compose_camerabutton_background_highlighted" type:SendStatusToolbarButtonTypeCamera];
        [self setupBtn:@"compose_toolbar_picture" highImage:@"compose_toolbar_picture_highlighted" type:SendStatusToolbarButtonTypePicture];
        [self setupBtn:@"compose_mentionbutton_background" highImage:@"compose_mentionbutton_background_highlighted" type:SendStatusToolbarButtonTypeMention];
        [self setupBtn:@"compose_trendbutton_background" highImage:@"compose_trendbutton_background_highlighted" type:SendStatusToolbarButtonTypeTrend];
        self.emotionButton = [self setupBtn:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted" type:SendStatusoolbarButtonTypeEmotion];
    }
    return self;
}

/**
 * 创建一个按钮
 */

- (UIButton *)setupBtn:(NSString *)image highImage:(NSString *)highImage type:(SendStatusToolbarButtonType)buttonType
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    
    [btn addTarget:self  action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    btn.tag = buttonType;
    
    if (buttonType == SendStatusToolbarButtonTypeMention || buttonType == SendStatusToolbarButtonTypeTrend) {
        btn.hidden = YES;
    }
    
    [self addSubview:btn];
    
    return btn;
}

- (void)btnClick:(UIButton *)btn
{
    NSUInteger btnTag;
    btnTag = btn.tag;
    
    if ([self.delegate respondsToSelector:@selector(sendStatusToolbar:didclickButton:)]) {
        [self.delegate sendStatusToolbar:self didclickButton:btnTag];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    
    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    
    for (NSUInteger i = 0; i<count; i++) {
        UIButton *btn = self.subviews[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i * btnW;
        btn.height = btnH;
    }
}

- (void)setShowKeyboardButton:(BOOL)showKeyboardButton
{
    _showKeyboardButton = showKeyboardButton;
    
    //默认图片名
    NSString *image = @"compose_emoticonbutton_background";
    NSString *highImage = @"compose_emoticonbutton_background_highlighted";
    
    //显示键盘图标
    if (showKeyboardButton) {
        image = @"compose_keyboardbutton_background";
        highImage = @"compose_keyboardbutton_background_highlighted";
    }
    
    // 设置图片
    [self.emotionButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self.emotionButton setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];}

@end
