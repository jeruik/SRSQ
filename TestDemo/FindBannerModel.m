//
//  FindBannerModel.m
//  TestDemo
//
//  Created by dzb on 17/2/4.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "FindBannerModel.h"
#import "MJExtension.h"

@implementation FindBannerModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

- (void)setBtype:(NSInteger)btype {
    _btype = btype;
    self.bannerType = btype;
}

@end
