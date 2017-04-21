//
//  MSTool.h
//  TestDemo
//
//  Created by 小菜 on 17/2/20.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSTool : NSObject

+ (instancetype)sharedMSTool;
-(NSString *)getRandomNonce;
-(NSString *)getTimestamp;
-(NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to;
-(NSString *)sha1WithKey:(NSString *)key;
-(NSString *)getSignatureWithAppSecret:(NSString *)appSecret nonce:(NSString *)nonce timestamp:(NSString *)timestamp;

@end
