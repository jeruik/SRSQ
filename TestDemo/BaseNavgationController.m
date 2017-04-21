//
//  MyWeiBoNavgationController.m
//  0001-微博-框架搭建
//
//  Created by 蔡凌云 on 15-6-15.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import "BaseNavgationController.h"
@interface BaseNavgationController ()

@end

@implementation BaseNavgationController

//创建这个控制器的时候会加载一个，只加载一次
+ (void)initialize
{
    // 在这个方法里面设置主题
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    item.tintColor = THEME_COLOR;
    //设置普通状态
    NSMutableDictionary *textAttrs = [[NSMutableDictionary alloc] init];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.tintColor = THEME_COLOR;
//    [bar setBackgroundImage:[UIImage imageWithColor:[UIColor purpleColor ]] forBarMetrics:UIBarMetricsDefault];
    
//    //设置不可用状态
//    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
//    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
//    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    /*
     颜色知识补充
     //  每一个像素都有自己的颜色，每一种颜色都可以由RGB3色组成
     //  12bit颜色: #f00  #0f0 #00f #ff0
     
     //  24bit颜色: #ff0000 #ffff00  #000000  #ffffff
     // #ff ff ff
     // R:255
     // G:255
     // B:255
     
     // RGBA
        32bit颜色: #556677
     
        #ff00ff
     */
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {  //第一个进来的时viewcontrol
        //自动显示和隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    [super pushViewController:viewController animated:animated];
}


@end
