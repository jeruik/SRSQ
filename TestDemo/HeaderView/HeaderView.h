//
//  HeaderView.h
//  JSMineHomePage
//
//  Created by normal on 2016/12/5.
//  Copyright © 2016年 WZB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView

/*
 * 初始化方法
 * frame: HeaderView的frame
 **/
+ (instancetype)headerView:(CGRect)frame userModel:(CYUserModel *)model;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *descLab;

@property (nonatomic, strong) CYUserModel *model;
@property (nonatomic, copy) void(^desLabBlock)();
@property (nonatomic, copy) void(^userNameBlock)();
@end
