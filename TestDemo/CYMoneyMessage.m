//
//  CYMoneyMessage.m
//  TestDemo
//
//  Created by 小菜 on 17/1/26.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "CYMoneyMessage.h"

@implementation CYMoneyMessage

- (instancetype)initWith:(double)amount description:(NSString *)desc {
    if ([super init]) {
        _amount = amount;
        _desc = desc;
    }
    return self;
}

- (NSData *)encode {
    return [NSJSONSerialization dataWithJSONObject:@{@"amount":@(_amount),@"desc":_desc} options:NSJSONWritingPrettyPrinted error:nil];
}

- (void)decodeWithData:(NSData *)data {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    _amount = [(NSNumber *)dic[@"amount"] doubleValue];
    _desc = (NSString *)dic[@"desc"];
}

+ (NSString *)getObjectName {
    return NSStringFromClass([self class]);
}

+ (RCMessagePersistent)persistentFlag {
    return MessagePersistent_ISCOUNTED;
}

- (NSString *)conversationDigest {
    return @"[srsq:红包]";
}

@end
