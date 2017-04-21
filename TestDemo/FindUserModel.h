//
//  FindUserModel.h
//  TestDemo
//
//  Created by dzb on 17/2/5.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindUserModel : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *headimgurl;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *actcontent;
@property (nonatomic, assign) NSInteger zancount;
@property (nonatomic, assign) NSInteger commoncount;
@property (nonatomic, copy) NSString *photostr;
@property (nonatomic, copy) NSString *sqlocal;
@property (nonatomic, copy) NSString *acttime;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSArray *thimbimgPhotos;

@property (nonatomic, assign) CGSize photoViewLayotSize;

@property (nonatomic, assign) CGSize photoViewSize;
@property (nonatomic, assign) CGFloat contentLabBottom;

@property (nonatomic, assign) CGFloat cellH;

@property (nonatomic, strong) NSAttributedString *attActcontent;

// 富文本高度
@property (nonatomic, assign) CGFloat contentLabH;

@property (nonatomic, assign) BOOL zan;

@property (nonatomic, assign) NSString *shareUrl;
@property (nonatomic, copy) NSString *rcuserid;

@property (nonatomic, assign) NSInteger index;

- (void)calculate;

@end
