//
//  CYUserModel.m
//  TestDemo
//
//  Created by 小菜 on 17/1/30.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "CYUserModel.h"


@implementation CYUserModel

MJExtensionCodingImplementation

- (void)setPhotos:(NSString *)photos {
    _photos = photos;
    
    if (photos.length > 1) {

        self.userPhotos = [photos mj_JSONObject];
        
        NSMutableArray *bigImgArr = [NSMutableArray array];
        NSMutableArray *thimbArr = [NSMutableArray array];
        for (NSString *str in self.userPhotos) {
            NSString *imgurl = [NSString stringWithFormat:@"%@%@",QiniuHeader,str];
            NSString *thimg = [NSString stringWithFormat:@"%@%@",imgurl,QiniuSub];
            [bigImgArr addObject:imgurl];
            [thimbArr addObject:thimg];
        }
        self.userPhotos = [NSArray arrayWithArray:bigImgArr]; // 大图
        if (self.userPhotos.count == 1) {
            self.thimbimgPhotos = [NSArray arrayWithArray:bigImgArr];
        } else {
            self.thimbimgPhotos = [NSArray arrayWithArray:thimbArr];
        }
    }
}

- (void)setActivities:(NSString *)activities {
    _activities = activities;
    self.userAct = [activities componentsSeparatedByString:@","];
}

@end
