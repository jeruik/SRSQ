//
//  MHNetworkManager.h
//  MHProject
//
//  Created by yons on 15/9/22.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYNetworkDefine.h"
#import <AFNetworking/AFNetworking.h>

/// 请求管理者
@interface CYNetworkHandle : NSObject

/**
 *  请求成功回调
 *
 *  @param returnData 回调block
 */
typedef void (^CYNetworkSuccessBlock)(CYResponse *responseObject);
/**
 *  请求失败回调
 *
 *  @param error 回调block
 */
typedef void (^CYNetworkFailureBlock)(CYResponseError *cyNetworkError);


/**
 *  进度
 */
typedef void (^CYNetworkProgressBlock)(CGFloat progress);


#pragma mark - 发送 GET 请求的方法
/**
 *   GET请求通过Block 回调结果
 *
 *   @param url          url
 *   @param paramsDict   paramsDict
 *   @param successBlock  成功的回调
 *   @param failureBlock  失败的回调
 *   @param showHUD      是否加载进度指示器
 */
+ (void)getRequstWithURL:(NSString*)url
                  params:(NSDictionary*)paramsDict
            successBlock:(CYNetworkSuccessBlock)successBlock
            failureBlock:(CYNetworkFailureBlock)failureBlock
                 showHUD:(BOOL)showHUD;

#pragma mark - 发送 POST 请求的方法
/**
 *   通过 Block回调结果
 *
 *   @param url           url
 *   @param paramsDict    请求的参数字典
 *   @param successBlock  成功的回调
 *   @param failureBlock  失败的回调
 *   @param showHUD       是否加载进度指示器
 */
+ (void)postReqeustWithURL:(NSString*)url
                    params:(NSDictionary*)paramsDict
              successBlock:(CYNetworkSuccessBlock)successBlock
              failureBlock:(CYNetworkFailureBlock)failureBlock
                   showHUD:(BOOL)showHUD;
/**
 *   设置了操作直接的依赖 适用于依次请求网络数据
 *
 *   @param url           url
 *   @param paramsDict    请求的参数字典
 *   @param successBlock  成功的回调
 *   @param failureBlock  失败的回调
 *   @param showHUD       是否加载进度指示器
 */
+ (void)postOperationWithURL:(NSString *)url
                      params:(NSDictionary *)paramsDict
                successBlock:(CYNetworkSuccessBlock)successBlock
                failureBlock:(CYNetworkFailureBlock)failureBlock
                     showHUD:(BOOL)showHUD;



@end
