//
//  CYUserDataSource.m
//  TestDemo
//
//  Created by 小菜 on 17/1/26.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "CYUserDataSource.h"

@interface CYUserDataSource ()

@end

@implementation CYUserDataSource

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    
    [[SQUser sharedUser].rcChatDatesource enumerateObjectsUsingBlock:^(CYUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.rcuserid isEqualToString:userId]) {
            *stop = YES;
            RCUserInfo *rcUser = [[RCUserInfo alloc] initWithUserId:obj.rcuserid name:obj.username portrait:obj.headimgurl];
            completion(rcUser);
        }
    }];
}

@end
