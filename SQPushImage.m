//
//  SQPushImage.m
//  TestDemo
//
//  Created by 小菜 on 17/2/6.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "SQPushImage.h"

@implementation SQPushImage


+ (void)loadPushImageViewWithWindow:(UIWindow *)window {
    
    NSString *startUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"startImage"];
    LxDBAnyVar(startUrl);
    // 0.创建要显示的图片
    __block UIView *fullView = [[UIView alloc] initWithFrame:window.bounds];
    fullView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *showImageView = [[UIImageView alloc] initWithFrame:fullView.bounds];
    [fullView addSubview:showImageView];
    showImageView.userInteractionEnabled = YES;
    UIImage *img = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:startUrl];
    if (img) {
        [showImageView setImage:img];
    }
    __block UIButton *btn = [[UIButton alloc] initWithFrame:FRAME(CDRViewWidth-20-60, 30, 60, 20)];
    btn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [btn setTitle:@"3 跳过" forState:UIControlStateNormal];
    [btn.titleLabel setFont:FONT_SIZE(14)];
    [fullView addSubview:btn];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [fullView removeFromSuperview];
    }];
    
    if (img) {
        [window addSubview:fullView];
        // 定时器
        __block NSInteger index = 2;
        RACSignal *sendCodeEnableSignal = [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] take:3];
        [sendCodeEnableSignal subscribeNext:^(id x) {
            [btn setTitle:[NSString stringWithFormat:@"%ld 跳过",index] forState:UIControlStateNormal];
            index --;
            LxDBAnyVar(x);
            LxDBAnyVar(index);
            if (index < 0) {
                [fullView removeFromSuperview];
            }
        }];
    }
}

@end
