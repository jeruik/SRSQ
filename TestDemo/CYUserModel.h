//
//  CYUserModel.h
//  TestDemo
//
//  Created by 小菜 on 17/1/30.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYUserModel : NSObject<NSCoding>

@property (nonatomic, strong) NSString *phonenum;
@property (nonatomic, strong) NSString *pwd;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *headimgurl;
@property (nonatomic, strong) NSString *way;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *rcuserid;
@property (nonatomic, strong) NSString *deviceno;

@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *aboutme;
/* 融云注册的ID **/
@property (nonatomic, strong) NSString *rctoke;

@property (nonatomic, strong) NSString *photos;
@property (nonatomic, strong) NSString *activities;
@property (nonatomic, strong) NSString *tags;

@property (nonatomic, strong) NSArray *userPhotos;
@property (nonatomic, strong) NSArray *thimbimgPhotos;

@property (nonatomic, strong) NSArray *userAct;

@property (nonatomic, assign) CGFloat cellH;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) NSString *GM;

@property (nonatomic, assign) NSInteger zannum;

@property (nonatomic, assign) BOOL zan;

@property (nonatomic, assign) BOOL isSelf;

@end
