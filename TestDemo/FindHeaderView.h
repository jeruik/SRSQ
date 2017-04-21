//
//  FindHeaderView.h
//  TestDemo
//
//  Created by dzb on 17/2/4.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindHeaderView : UIView

@property (nonatomic, copy) void (^pageViewClick)(NSInteger index);
@property (nonatomic,strong,nullable) NSArray *imageArray;
@property (nonatomic,strong,nullable) NSArray *titleArray;
@property (nonatomic,strong,nullable) NSArray *localArray;
@end
