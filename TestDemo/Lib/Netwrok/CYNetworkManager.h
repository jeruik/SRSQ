//
//  CYNetworkManager.h
//  CyNuomi
//
//  Created by 董招兵 on 16/1/5.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYNetworkDefine.h"
@interface CYNetworkManager : NSObject

/**
 *  得到网络请求管理者的实例
 *
 *  @return 返回单例
 */
+ (instancetype)manager;

/**
 *  网络是否可用
 */
@property (nonatomic,assign) BOOL  networkEnable;
@property (nonatomic,assign) BOOL  netMark;
@property (nonatomic,strong) AFHTTPSessionManager *httpSessionManager;
/**
 *  GET 请求
 *
 *  @param url              url
 *  @param params           参数字典
 *  @param successBlock     成功
 *  @param failed           失败
 */
+ (void)getRequestWithURL:(NSString*)url
                   params:(NSDictionary*)params
                  success:(CYNetworkSuccess)successBlock
               faildBlock:(CYNetworkFailure)failed;
/**
 *  GET请求时用这个可以设置操作直接的依赖关系,根据调用顺序设置依赖
 *  @param url              url
 *  @param params           参数字典
 *  @param successBlock     成功
 *  @param failed           失败
 */
+ (void)getOperationWithURL:(NSString*)url
                      params:(NSDictionary*)params
                     success:(CYNetworkSuccess)successBlock
                  faildBlock:(CYNetworkFailure)failed;
/**
 *  POST 请求
 *
 *  @param url              url
 *  @param params           参数字典
 *  @param successBlock     成功
 *  @param failed           失败
 */
+ (void)postRequestWithURL:(NSString*)url
                    params:(NSDictionary*)params
                   success:(CYNetworkSuccess)successBlock
                faildBlock:(CYNetworkFailure)failed;
/**
 *  POST多请求时用这个可以设置操作直接的依赖关系,根据调用顺序设置依赖
 *  @param url              url
 *  @param params           参数字典
 *  @param successBlock     成功
 *  @param failed           失败
 */
+ (void)postOperationWithURL:(NSString*)url
                      params:(NSDictionary*)params
                     success:(CYNetworkSuccess)successBlock
                  faildBlock:(CYNetworkFailure)failed;


/**
 *  开始监听网络状态
 */
+ (void)startMonitoring;

/**
 *  下载文件
 */
+ (NSURLSessionDownloadTask *)download:(NSString *)sourceUrl savePath:(NSString *)savePath completed:(void(^)(NSString *_Nullable path,NSError * _Nullable error))callBack;
@end
