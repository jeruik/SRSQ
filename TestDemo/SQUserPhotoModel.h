//
//  SQUserPhotoModel.h
//  TestDemo
//
//  Created by 小菜 on 17/2/6.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQUserPhotoModel : NSObject<NSCoding>

@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *local;
@property (nonatomic, strong) NSString *time;
@end
