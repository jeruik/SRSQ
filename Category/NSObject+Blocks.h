//
//  NSObject+MHBlock.h
//  MHProject
//
//  Created by MengHuan on 15/6/5.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Blocks)

// 在主线程中执行block1，在后台完成后执行block2
+ (void)perform:(void(^)())block1 withCompletionHandler:(void (^)())block2;
- (void)perform:(void(^)())block1 withCompletionHandler:(void (^)())block2;

/**
 *  在主线程延时执行并回调一段代码
 *
 *  @param time   时间
 *  @param block1 回调的block
 */
- (void)dispatch_afterMainQueue:(long long)time withCompletionHandler:(void (^)())block1;
/**
 *  在分线程延时执行并回调一段代码
 *
 *  @param time   时间
 *  @param block1 回调的block
 */
- (void)dispatch_afterSubQueue:(long long)time withCompletionHandler:(void (^)())block1;

/**
 *   开启分线程
 *
 *   @param block1 分线程
 */
- (void)dispatch_get_global_queue:(void(^)())block1;
/**
 *   回到主线程
 *
 *   @param block1 回调
 */
- (void)dispatch_get_main_queue:(void(^)())block1;
+ (void)dispatch_get_main_queue:(void(^)())block;
+ (void)dispatch_get_global_queue:(void(^)())block1;

typedef void (^CYRun)(void);

void CYAsyncRun(CYRun run);

void CYAsyncRunInMain(CYRun run);





@end
