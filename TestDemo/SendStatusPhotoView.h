//
//  SendStatusPhotoView.h
//  0001-微博-框架搭建
//
//  Created by 蔡凌云 on 15-6-27.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendStatusPhotoView : UIView

@property (nonatomic, strong) UIImageView *addBtn;

- (void)addPhoto:(UIImage *)photo tag:(NSInteger)tag;

@property (nonatomic, strong, readonly) NSMutableArray *photos;

@property (nonatomic, copy) void (^imageViewClickBlock)(UIImageView *imageView);

@property (nonatomic, copy) void (^addBtnClickBlock)();

@property (nonatomic, copy) void (^subViewChangeBlock)();

@end
