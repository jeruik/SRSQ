//
//  SQPhotoTableViewCell.h
//  TestDemo
//
//  Created by 小菜 on 17/2/6.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQPhotoTableViewCell : UITableViewCell

@property (nonatomic, copy) void(^addPhotoBlock)();
@property (nonatomic, copy) void(^delectPhotoBlock)(NSInteger index);
@property (nonatomic, strong) NSArray *photosArray;

@property (nonatomic, assign) BOOL isSelf;

@end
