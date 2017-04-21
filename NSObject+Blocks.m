//
//  NSObject+MHBlock.m
//  MHProject
//
//  Created by MengHuan on 15/6/5.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import "NSObject+Blocks.h"

@implementation NSObject (Blocks)
/**
 *   开启分线程
 *
 *   @param block1 分线程
 */
- (void)dispatch_get_global_queue:(void(^)())block1
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (block1) {
            block1();
        }
    });
}
/**
 *   回到主线程
 *
 *   @param block1 回调
 */
- (void)dispatch_get_main_queue:(void(^)())block1
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (block1) {
            block1();
        }
    });
}

+ (void)dispatch_get_main_queue:(void(^)())block1
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (block1) {
            block1();
        }
    });
}
+ (void)dispatch_get_global_queue:(void(^)())block1
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (block1) {
            block1();
        }
    });
}

#pragma mark - 在主线程中执行block1，在后台完成后执行block2
+ (void)perform:(void(^)())block1 withCompletionHandler:(void (^)())block2
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        block1();
        dispatch_async(dispatch_get_main_queue(),^{
            block2();
        });
    });
}
- (void)perform:(void(^)())block1 withCompletionHandler:(void (^)())block2
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        block1();
        dispatch_async(dispatch_get_main_queue(),^{
            block2();
        });
    });
}
#pragma mark - 延时执行一段代码分主线程和子线程

- (void)dispatch_after:(long long)time with:(void(^)())block1 withCompletionHandler:(NSOperationQueue*)queue
{
    __block NSOperationQueue *completeQuequ = nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!block1) return ;
        completeQuequ = queue;
        [queue addOperationWithBlock:^{
            block1();
        }];
    });
}
/**
 *  在主线程延时执行并回调一段代码
 *
 *  @param time   时间
 *  @param block1 回调的block
 */
- (void)dispatch_afterMainQueue:(long long)time withCompletionHandler:(void (^)())block1
{
    [self dispatch_after:time with:block1 withCompletionHandler:[NSOperationQueue mainQueue]];
}
/**
 *  在分线程延时执行并回调一段代码
 *
 *  @param time   时间
 *  @param block1 回调的block
 */
- (void)dispatch_afterSubQueue:(long long)time withCompletionHandler:(void (^)())block1
{
    [self dispatch_after:time with:block1 withCompletionHandler:[NSOperationQueue new]];
}

void CYAsyncRun(CYRun run) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        run();
    });
}

void CYAsyncRunInMain(CYRun run) {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        run();
    });
}


@end
