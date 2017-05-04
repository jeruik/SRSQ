//
//  DTShowHudView.m
//  Cinderella
//
//  Created by ng on 15/9/7.
//  Copyright (c) 2015年 Dantou. All rights reserved.
//

#import "DTShowHudView.h"
#import "ShareView.h"
#import "AppDelegate.h"

static DTShowHudView *_showHudView;

@implementation DTShowHudView
static ShareView *_showView;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _showHudView = [super allocWithZone:zone];
    });
    return _showHudView;
}

+ (instancetype)shareView {
    return [[super alloc] init];
}
/**
 *  显示分享视图
 *
 *  @param data    需要分享的参数
 *  @param success 成功的回调
 */
+ (void)showShareViewWithContents:(id)data successBlock:(void(^)())success {
    [self creatShareView:data successBlock:success];
}
/**
 *  隐藏这个视图
 */
+ (void)hiddenShareView {
    if (_showView)
    {
        [_showView hiddenShareView];
    }
}
/**
 *  实例化一个分享的 view
 *
 *  @param data     需要分享的参数
 *  @param success 成功的回调
 */
+ (ShareView*)creatShareView:(id)data successBlock:(void(^)())success {
    _showView = [[ShareView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_showView showShareView:data successBlock:success];
    [[AppDelegate appDelegate].window addSubview:_showView];
    return _showView;
}
+ (ShareView*)creatShareInavitationView:(id)data successBlock:(void(^)())success {
    _showView = [[ShareView alloc] init];
    [_showView showShareInavitationView:data successBlock:success];
    return _showView;
}

@end
