//
//  MHNetworkManager.m
//  MHProject
//
//  Created by yons on 15/9/22.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "CYNetworkHandle.h"
#import "CYResponseError.h"
#import "CYResponse.h"
#import "NSObject+Blocks.h"
#import "NSObject+IvarNull.h"

@implementation CYNetworkHandle

#pragma mark - GET 请求的三种回调方法
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
                  params:(NSDictionary*)params
            successBlock:(CYNetworkSuccessBlock)successBlock
            failureBlock:(CYNetworkFailureBlock)failureBlock
                 showHUD:(BOOL)showHUD
{
    [self showHUDWithFlag:showHUD];
    [CYNetworkManager getRequestWithURL:url params:params success:^(id result) {
        [self hiddenHud:showHUD];
        [self resuetWithData:result success:successBlock];
    } faildBlock:^(NSError *error) {
        [self hiddenHud:showHUD];
        if (failureBlock) {
            failureBlock([CYNetworkHandle getCyError:error]);
        }
    }];
}

+ (CYResponseError *)getCyError:(NSError *)error {
    CYResponseError *cyError    = [[CYResponseError alloc] init];
    [cyError setValue:error.domain forKey:@"domain"];
    cyError.errorCode           = error.code;
    cyError.errorMsg = error.localizedDescription;
    return cyError;
}
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
                    params:(NSDictionary*)params
              successBlock:(CYNetworkSuccessBlock)successBlock
              failureBlock:(CYNetworkFailureBlock)failureBlock
                   showHUD:(BOOL)showHUD {
    [self showHUDWithFlag:showHUD];
    [CYNetworkManager postRequestWithURL:url params:params success:^(id result) {
        [self hiddenHud:showHUD];
        [self resuetWithData:result success:successBlock];
    } faildBlock:^(NSError *error) {
        [self hiddenHud:showHUD];
        if (failureBlock) {
            failureBlock([CYNetworkHandle getCyError:error]);
        }
    }];
}
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
                     showHUD:(BOOL)showHUD
{
    [self showHUDWithFlag:showHUD];
    [CYNetworkManager postOperationWithURL:url params:paramsDict success:^(id result) {
        [self hiddenHud:showHUD];
        [self resuetWithData:result success:successBlock];
    } faildBlock:^(NSError *error) {
        [self hiddenHud:showHUD];
        if (failureBlock) {
            failureBlock([CYNetworkHandle getCyError:error]);
        }
    }];
}
/**
 *  公共方法处理统一处理请求结果
 *
 *  @param result  返回结果
 *  @param success 处理完成后的回调
 */
+ (void)resuetWithData:(id)result success:(CYNetworkSuccessBlock)success
{
    @try {
      CYAsyncRun(^{
          NSDictionary *dict = (NSDictionary*)result;
          dict = [self replaceNullValueWithDictionary:dict];
          NSString *desc = dict[@"Desc"];
          if (desc) {
              desc = [NSString unicodeToUtf8:desc];
          }else {
              desc = @"连接服务器错误!";
          }
          
          CYAsyncRunInMain(^{
              NSNumber *resultNumber                   = dict[@"Result"];
              NSInteger result                  = resultNumber ? resultNumber.integerValue : 1000000;
              CYResponse *responseObject        = [[CYResponse alloc] init];
              responseObject.data               = dict[@"Data"];
              responseObject.result             = result;
              responseObject.responseData       = dict;
              responseObject.desc               = desc;
              if (success) {
                  success(responseObject);
              }
          });
      });
    } @catch (NSException *exception) {
        LxDBAnyVar(exception);
    }

}
/**
 *  对服务器返回的参数<null>值进行过滤
 */
+ (__kindof NSDictionary*)replaceNullValueWithDictionary:(__kindof NSDictionary*)dict
{
    __block id data = dict[@"Data"];
    if ([data isKindOfClass:[NSDictionary class]]) {
        data = [data checkValueNull];
    }else if ([data isKindOfClass:[NSArray class]])
    {
        NSArray *array = (NSArray*)data;
        NSMutableArray *dataArray = [NSMutableArray array];
        for (id object in array) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic  = [object checkValueNull];
                [dataArray addObject:dic];
            }
        }
        data = dataArray;
    }else if (!data || data == (id)[NSNull null]){
        data = @{};
    }
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mutableDict setObject:data forKey:@"Data"];
    return mutableDict;
}

+ (void)showHUDWithFlag:(BOOL)flag
{
    if (!flag || ![NSThread isMainThread])return;
    UIView *view = [[[UIApplication sharedApplication] delegate]window];
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}

+ (void)hiddenHud:(BOOL)flag
{
    if (!flag || ![NSThread isMainThread])return;
    [self dispatch_get_main_queue:^{
        UIView *view = [[[UIApplication sharedApplication] delegate]window];
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
    }];
}

@end
