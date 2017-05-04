//
//  DTShowHudView.h
//  Cinderella
//
//  Created by ng on 15/9/7.
//  Copyright (c) 2015年 Dantou. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShareView;

@interface DTShowHudView : NSObject

+ (instancetype)shareView;

/**
 *  展示分享视图
 *
 *  @param data     data
 *  @param success  成功
 */
+ (void)showShareViewWithContents:(id)data successBlock:(void(^)())success;

+ (ShareView*)creatShareInavitationView:(id)data successBlock:(void(^)())success;
/**
 *  隐藏分享视图
 */
+ (void)hiddenShareView;


@end
