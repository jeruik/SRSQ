//
//  SQEditViewController.h
//  TestDemo
//
//  Created by 小菜 on 17/2/27.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQEditViewController : UIViewController
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, copy) void(^callBlock)(NSString *str);

@end
