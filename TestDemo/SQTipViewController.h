//
//  SQTipViewController.h
//  TestDemo
//
//  Created by 小菜 on 17/2/27.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTTextView.h"

@interface SQTipViewController : UIViewController

@property(nonatomic, strong) DTTextView *textView;

@property (nonatomic, strong) NSString *tags;

@property (nonatomic, copy) void(^tagsBlock)(NSString *);

@end
