//
//  CYNetworkManager.m
//  CyNuomi
//
//  Created by 董招兵 on 16/1/5.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import "CYNetworkManager.h"
#import "AFNetworking.h"
#import "LCProgressHUD.h"
@interface CYNetworkManager ()

@property (nonatomic,strong) NSOperationQueue *networkImteQueue;
@property (nonatomic,strong) NSMutableArray   *networkBuffer;

@end

@implementation CYNetworkManager
+ (AFSecurityPolicy*)customSecurityPolicy
{
    // 1.先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    NSSet *cerSet = [NSSet setWithObjects:certData, nil];

    // 2.AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];

    // 3.allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;

    // 4.validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;

    // 5.添加证书
//    [securityPolicy setPinnedCertificates:cerSet];

    return securityPolicy;
}
- (AFHTTPSessionManager *)httpSessionManager {
    if (!_httpSessionManager) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 10.0;
        _httpSessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
        // 2.申明返回的结果是text/html类型
        _httpSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        // 加上这行代码，https ssl 验证。
//        [_httpSessionManager setSecurityPolicy:[CYNetworkManager customSecurityPolicy]];
    }
    return _httpSessionManager;
}

+ (instancetype)manager
{
    static CYNetworkManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[super alloc] init];
        _manager.networkEnable = YES;
    });
    return _manager;
}

- (NSOperationQueue *)networkImteQueue
{
    if (!_networkImteQueue) {
        _networkImteQueue = [[NSOperationQueue alloc] init];
        _networkImteQueue.maxConcurrentOperationCount = 5;
    }
    return _networkImteQueue;
}
- (NSMutableArray*)networkBuffer
{
    if (!_networkBuffer) {
        _networkBuffer = [NSMutableArray array];
    }
    return _networkBuffer;
}
/**
 *  开始监听网络状态
 */
+ (void)startMonitoring {
    CYNetworkManager *manager = [CYNetworkManager manager];
        AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                manager.networkEnable  = YES;
                manager.netMark = NO;
                DTLog(@"未知的网络状态");
            }
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
            {
                // 未知网络
                [LCProgressHUD showStatus:LCProgressHUDStatusError text:@"网络连接断开!"];
                manager.networkEnable  = NO;
                manager.netMark = NO;
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
            {
                manager.networkEnable  = YES;
                manager.netMark = YES;
                DTLog(@"手机自带网络");
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
            {
                manager.networkEnable  = YES;
                manager.netMark = NO;
                DTLog(@"WIFI");
            }
                break;
        }
    }];
    
    // 3.开始监控
    [mgr startMonitoring];
    
}

#pragma mark - GET请求的方法
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
               faildBlock:(CYNetworkFailure)failed {
//    CYNetworkManager *manager = [CYNetworkManager manager];
//    [manager.networkImteQueue addOperation:operation];
}
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
                 faildBlock:(CYNetworkFailure)failed
{
    [self publicOpeartionReqeust:url networkType:CYNetworkTypeGET params:params success:successBlock faildBlock:failed];
}

#pragma mark - POST请求的方法

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
                faildBlock:(CYNetworkFailure)failed
{
    CYNetworkManager *manager = [CYNetworkManager manager];
    NSBlockOperation *networkOpeartion = [NSBlockOperation blockOperationWithBlock:^{
        // 参数拼接
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:params];
        DTLog(@"\n请求参数->%@\n",dict);
        LxDBAnyVar(url);
        NSURLSessionDataTask *dataTask = [manager.httpSessionManager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            LxDBAnyVar(responseObject);
            if (successBlock) {
                successBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failed) {
                failed(error);
            }
        }];
        [dataTask resume];
        
    }];
    
    [manager.networkImteQueue addOperation:networkOpeartion];
    
}

+ (void)postOperationWithURL:(NSString*)url
                      params:(NSDictionary*)params
                     success:(CYNetworkSuccess)successBlock
                  faildBlock:(CYNetworkFailure)failed
{
    [self publicOpeartionReqeust:url networkType:CYNetworkTypePOST params:params success:successBlock faildBlock:failed];
}
/**
 *  多网络请求时设置每个 operaton 之间的依赖关系
 *
 *  @param url              请求 url
 *  @param networkType      网络请求的类型
 *  @param params           参数
 *  @param successBlock     成功
 *  @param failed           失败
 */
+ (void)publicOpeartionReqeust:(NSString *)url
                   networkType:(CYNetworkType)networkType
                        params:(NSDictionary*)params
                       success:(CYNetworkSuccess)successBlock
                    faildBlock:(CYNetworkFailure)failed
{
    @synchronized(self) {
       __weak CYNetworkManager *manager = [CYNetworkManager manager];
        NSBlockOperation *lastOperation = [manager.networkBuffer lastObject];
       __block  NSBlockOperation *networkOperation = [NSBlockOperation blockOperationWithBlock:^{
           // 参数拼接
           NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:params];
           DTLog(@"\n请求参数->%@\n",dict);
           LxDBAnyVar(url);
            NSURLSessionDataTask *dataTask = [manager.httpSessionManager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                LxDBAnyVar(responseObject);
                if (successBlock) {
                    successBlock(responseObject);
                }
                [manager.networkBuffer removeObject:networkOperation];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failed) {
                    failed(error);
                }
            }];
           
           manager.httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
           AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
           serializer.removesKeysWithNullValues = YES;
           [dataTask resume];
           
        }];
    
        if (lastOperation) {
            [networkOperation addDependency:lastOperation];
        }
        [manager.networkImteQueue addOperation:networkOperation];
        [manager.networkBuffer addObject:networkOperation];
        
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
