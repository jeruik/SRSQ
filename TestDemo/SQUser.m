//
//  SQUser.m
//  TestDemo
//
//  Created by 小菜 on 17/2/4.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "SQUser.h"


@implementation SQUser

MJCodingImplementation

static SQUser *_instance = nil;
static dispatch_once_t onceToken;
+ (instancetype)sharedUser {
    
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    });
    return _instance;
}
    
+ (id)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
    
+ (instancetype)sharedUploadHelper {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
    
- (id)copyWithZone:(NSZone *)zone {
    
    return _instance;
}
  
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

+ (void)userDealloc {

}

- (NSMutableArray *)rcChatDatesource {
    if (!_rcChatDatesource) {
        _rcChatDatesource = [NSMutableArray array];
    }
    return _rcChatDatesource;
}

@end
