//
//  FindViewCell.h
//  TestDemo
//
//  Created by dzb on 17/2/5.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindUserModel.h"

@interface FindViewCell : UITableViewCell

@property (nonatomic, strong) FindUserModel *userModel;

@property (nonatomic, copy) void(^headerBlock)(NSString *);

@property (nonatomic, copy) void(^shareBlock)(FindUserModel *);

@end
