//
//  CYNetworkUploadParam.m
//  CyNuomi
//
//  Created by 董招兵 on 16/1/5.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import "CYNetworkUploadParam.h"
#import <CommonCrypto/CommonDigest.h>

@implementation CYNetworkUploadParam

//- (NSString *)fileName
//{
//    NSDate *currentDate = [NSDate date];
//    
//    NSTimeInterval time = [currentDate timeIntervalSince1970];
//    NSString *token         = DEF_TOKEN;
//    NSString *sign          = [NSString signStringByArray:@[DEF_ACCOUNT,token,[NSString stringWithFormat:@"%f",time]]];
//    NSString *qnKey = [[NSString stringWithFormat:@"%@?data/%d/chuyingCommpany",sign,arc4random_uniform(10000000)] md5];
//    return qnKey;
//}

- (NSString *)mimeType
{
    return @"image/png";
}



- (void)dealloc {
    
    
}

@end
