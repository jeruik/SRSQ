//
//  CYBackMessage.m
//  TestDemo
//
//  Created by 小菜 on 17/1/26.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "CYBackMessage.h"


@implementation CYBackMessage

- (instancetype)initWithBackUID:(NSString *)uid {
    if (self = [super init]) {
        self.backMessageUID = uid;
    }
    return self;
}

- (NSData *)encode {
    return [NSJSONSerialization dataWithJSONObject:@{@"uid":self.backMessageUID} options:NSJSONWritingPrettyPrinted error:nil];
}

- (void)decodeWithData:(NSData *)data {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    _backMessageUID = (NSString *)dic[@"uid"];
}

+ (NSString *)getObjectName {
    return NSStringFromClass([self class]);
}

+ (RCMessagePersistent)persistentFlag {
    return MessagePersistent_ISPERSISTED;
}

- (NSString *)conversationDigest {
    return @"[srsq:撤回消息]";
}

@end
