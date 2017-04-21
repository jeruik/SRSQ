//
//  SQUser.h
//  TestDemo
//
//  Created by 小菜 on 17/2/4.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SQUserPhotoModel;
@interface SQUser : NSObject<NSCoding>

@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *pwd;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *headimgurl;
@property (nonatomic, strong) NSString *openid;
@property (nonatomic, strong) NSString *way;
@property (nonatomic, strong) NSString *rcuserid;
@property (nonatomic, strong) NSString *rctoken;
@property (nonatomic, strong) NSString *GM;
@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *tags;

@property (nonatomic, strong) NSArray<SQUserPhotoModel *> *photos;
@property (nonatomic, strong) NSArray *activity;

@property (nonatomic, strong) NSMutableArray<CYUserModel *> *rcChatDatesource;

+ (instancetype)sharedUser;
+ (void)userDealloc;
@end
