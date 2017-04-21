//
//  MyWeiBoTabBarController.m
//  0001-微博-框架搭建
//
//  Created by 蔡凌云 on 15-6-15.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseNavgationController.h"
#import "CYConnectListViewController.h"
#import "CYFindViewController.h"
#import "CYUserViewController.h"
@interface MainTabBarController ()

@end

@implementation MainTabBarController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITabBar *item = [UITabBar appearance];
    item.tintColor = THEME_COLOR;
    
    // 3.设置子控制器
    CYConnectListViewController *home = [[CYConnectListViewController alloc] init];
    //设置需要显示哪些类型的会话
    [home setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [home setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    [self addChildVc:home title:@"消息" image:@"icon_chat" selectedImage:@"icon_chat_hover"];
    
    CYFindViewController *messageCenter = [[CYFindViewController alloc] init];
    [self addChildVc:messageCenter title:@"社区" image:@"square" selectedImage:@"square_hover"];
    
    CYUserViewController *mine = [[CYUserViewController alloc] init];
    mine.account = [SQUser sharedUser].account;
    [self addChildVc:mine title:@"我" image:@"icon_me" selectedImage:@"icon_me_hover"];
}
// 颜色转图片
- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];  //图片
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];  //选中图片
    
//    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//    textAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
//    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
//    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor blueColor];
//    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];

    BaseNavgationController *nav = [[BaseNavgationController alloc] initWithRootViewController:childVc];
    // 设置导航栏
    [nav.navigationBar setBackgroundImage:[self imageFromColor:[UIColor whiteColor]]
                           forBarPosition:UIBarPositionAny
                               barMetrics:UIBarMetricsDefault];
    //添加为子控制器
    [self addChildViewController:nav];
}


@end
