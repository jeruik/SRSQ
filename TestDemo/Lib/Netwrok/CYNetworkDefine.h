//
//  CYNetworkDefine.h
//  CyNuomi
//
//  Created by 董招兵 on 16/1/5.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#ifndef CYNetworkDefine_h
#define CYNetworkDefine_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CYResponseError.h"
#import "CYResponse.h"

/**
 *  请求成功回调
 *
 *  @param returnData 回调block
 */
typedef void (^CYNetworkSuccess)(id responseOjbect);
/**
 *  请求失败回调
 *
 *  @param error 回调block
 */
typedef void (^CYNetworkFailure)(NSError *error);


/**
 *  进度
 */
typedef void (^CYNetworkProgress)(CGFloat progress);

/**
 *  请求类型
 */
typedef enum {
    CYNetworkTypeGET = 1,   /**< GET请求 */
    CYNetworkTypePOST       /**< POST请求 */
} CYNetworkType;

typedef NS_ENUM(NSInteger,CYNetworkStatus){
    CYNetworkStatusNotReachable,     /**< 断网 */
    CYNetworkStatusReachableViaWiFi, /**< WIFI */
    CYNetworkStatusReachableViaWWAN  /**< 手机网络 */
};

/**
 *  网络请求超时的时间
 */
#define CYNetworkReqeust_TIME_OUT 15.0f




#endif /* CYNetworkDefine_h */
