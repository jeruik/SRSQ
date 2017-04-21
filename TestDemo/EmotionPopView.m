//
//  EmotionPopView.m
//  小菜微博
//
//  Created by 蔡凌云 on 15-6-30.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import "EmotionPopView.h"
#import "EmotionModel.h"
#import "EmotionButton.h"
@interface EmotionPopView ()

@property (weak, nonatomic) IBOutlet EmotionButton *emotionButton;


@end

@implementation EmotionPopView



+ (instancetype)popView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"EmotionPopView" owner:nil options:nil] lastObject];;
}

- (void)setEmotion:(EmotionModel *)emotion
{
    _emotion = emotion;
    
    //给弹框按钮传递模型
    self.emotionButton.emotion = emotion;
}

- (void)showFrom:(EmotionButton *)button
{
    if (button == nil) return;
    
    // 给popView传递数据
    self.emotionButton.emotion = button.emotion;
    
    // 取得最上面的window
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    
    // 计算出被点击的按钮在window中的frame
    CGRect btnFrame = [button convertRect:button.bounds toView:nil];
    self.y = CGRectGetMidY(btnFrame) - self.height; // 100
    self.centerX = CGRectGetMidX(btnFrame);
    
}

@end
