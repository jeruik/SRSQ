//
//  CYAllUserTableViewCell.h
//  TestDemo
//
//  Created by 小菜 on 17/2/4.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYAllUserTableViewCell : UITableViewCell

@property (nonatomic, strong) CYUserModel *model;
@property (nonatomic, strong) void(^headerViewBlock)(CYUserModel *);
@end
