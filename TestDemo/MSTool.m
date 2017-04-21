//
//  MSTool.m
//  TestDemo
//
//  Created by 小菜 on 17/2/20.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "MSTool.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation MSTool
+ (instancetype)sharedMSTool {
    
    static MSTool *_user;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _user = [[self alloc] init];
    });
    return _user;
}
//获取随机数
-(NSString *)getRandomNonce
{
    NSInteger randomValue = [self getRandomNumber:100000 to:999999];
    return  [NSString stringWithFormat:@"%ld",randomValue];
}
//获取时间戳 从1970年
-(NSString *)getTimestamp
{
    NSDate *date = [NSDate date];
    NSTimeInterval times =  [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f",times];
}

//获取从 from 到  to 的随机数
-(NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to
{
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

//sha1 加密
- (NSString *)sha1WithKey:(NSString *)key
{
    const char *cstr = [key cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:key.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

//根据appSecret nonce timestamp 获取signature
-(NSString *)getSignatureWithAppSecret:(NSString *)appSecret nonce:(NSString *)nonce timestamp:(NSString *)timestamp
{
    NSString *sha1String = [NSString stringWithFormat:@"%@%@%@",appSecret,nonce,timestamp];
    return [self sha1WithKey:sha1String];
}

@end
