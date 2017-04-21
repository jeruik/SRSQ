//
//  FindUserPhotoModel.h
//  TestDemo
//
//  Created by dzb on 17/2/6.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindUserPhotoModel : NSObject

/** 缩略图地址 */
@property (nonatomic, copy) NSString *thumbnailPic;
@property (nonatomic, copy) NSString *bigPic;

@property (nonatomic, strong) UIImage *oneImage;


@end
