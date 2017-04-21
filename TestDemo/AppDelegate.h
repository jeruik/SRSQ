//
//  AppDelegate.h
//  TestDemo
//
//  Created by 小菜 on 16/6/17.
//  Copyright © 2016年 蔡凌云. All rights reserved.
//

#import <UIKit/UIKit.h>

static BOOL isProduction = FALSE;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate*)appDelegate;

@end

