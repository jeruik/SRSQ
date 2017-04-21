//
//  QNTokenHelper.m
//  TestDemo
//
//  Created by 小菜 on 17/2/23.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "QNTokenHelper.h"
#import "QiniuSDK.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
@implementation QNTokenHelper

+ (instancetype)shared {
    
    static QNTokenHelper *_user;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _user = [[self alloc] init];
    });
    return _user;
}
- (NSString*)dictionryToJSONString:(NSMutableDictionary *)dictionary
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//AccessKey  以及SecretKey
- (NSString *)token{
    return [self makeToken:QNToken secretKey:QNSecretKey];
}

- (NSString *) hmacSha1Key:(NSString*)key textData:(NSString*)text
{
    const char *cData  = [text cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    NSString *hash = [QNUrlSafeBase64 encodeData:HMAC];
    return hash;
}

- (NSString *)makeToken:(NSString *)accessKey secretKey:(NSString *)secretKey
{
    //名字
    NSString *baseName = [self marshal];
    baseName = [baseName stringByReplacingOccurrencesOfString:@" " withString:@""];
    baseName = [baseName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSData   *baseNameData = [baseName dataUsingEncoding:NSUTF8StringEncoding];
    NSString *baseNameBase64 = [QNUrlSafeBase64 encodeData:baseNameData];
    NSString *secretKeyBase64 =  [self hmacSha1Key:secretKey textData:baseNameBase64];
    NSString *token = [NSString stringWithFormat:@"%@:%@:%@",  accessKey, secretKeyBase64, baseNameBase64];
    
    return token;
}
- (NSString *)marshal {
    time_t deadline;
    time(&deadline);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"srsq" forKey:@"scope"];
    NSNumber *escapeNumber = [NSNumber numberWithLongLong:3464706673];
    [dic setObject:escapeNumber forKey:@"deadline"];
    NSString *json = [self dictionryToJSONString:dic];
    return json;
}
@end
