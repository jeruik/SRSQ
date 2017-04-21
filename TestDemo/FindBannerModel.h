//
//  FindBannerModel.h
//  TestDemo
//
//  Created by dzb on 17/2/4.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, BannerType){
    BannerTypeWeb = 1,
    BannerTypePeople,
    BannerTypeOther
};


@interface FindBannerModel : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nullable, nonatomic, copy) NSString *imgurl;
@property (nullable, nonatomic, copy) NSString *squserid;
@property (nullable, nonatomic, copy) NSString *neturl;
@property (nullable, nonatomic, copy) NSString *bannertext;
@property (nonatomic, assign) NSInteger btype;
@property (nonatomic, assign) BannerType bannerType;

@end
