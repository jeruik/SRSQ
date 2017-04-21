//
//  AppDelegate.m
//  TestDemo
//
//  Created by 小菜 on 16/6/17.
//  Copyright © 2016年 蔡凌云. All rights reserved.
//

#import "AppDelegate.h"
#import "CYHomeViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "CYUserDataSource.h"
#import "CYMoneyMessage.h"
#import "CYBackMessage.h"
#import "AppDelegate+ShareSDK.h"
//#import <JSPatchPlatform/JSPatch.h>
#import "CoreNewFeatureVC.h"
#import "SQPushImage.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioTool.h"
#import "JPUSHService.h"
#import "MainTabBarController.h"
#import "CYDataCache.h"
#import "AppDelegate+UMengAnalytics.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<JPUSHRegisterDelegate>
@property (nonatomic, strong) CYUserDataSource *userDataSource;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#warning demo 完整功能需要 APPconfig里面补齐对应的key
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self setupJSPatch];                                    // JSPatch
    [self getChatDateSource];                               // 配置融云数据源
    [self showImage];                                       // 展示新特性
    [self setupRCIM:application launch:launchOptions];      // 初始化融云sdk
    [self initShareSDK];                                    // 初始化第三方登陆
    [self initJpush:launchOptions];                         // 初始化极光推送
    [self.window makeKeyAndVisible];
    [SQPushImage loadPushImageViewWithWindow:self.window];  // 启动广告
    [self initWithUMengAnalytics];                          // 初始化友盟统计分析
    return YES;
}
- (void)showImage {
    NSMutableArray *models = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        NewFeatureModel *m = [NewFeatureModel model:[UIImage imageNamed:[NSString stringWithFormat:@"f%d",i+1]]];
        [models addObject:m];
    }
    WEAKSELF
    BOOL canshow = [CoreNewFeatureVC canShowNewFeature];
    if (canshow) {
        CoreNewFeatureVC *vc = [CoreNewFeatureVC newFeatureVCWithModels:models enterBlock:^{
            [weakSelf setRootVc];
        }];
        self.window.rootViewController = vc;
    } else {
        [weakSelf setRootVc];
    }
}
- (void)setRootVc {
    SQUser *squser = [CYDataCache cy_ObjectForKey:@"srsq"];
    if (squser.openid.length > 1) {
        LxDBObjectAsJson(squser);
        self.window.rootViewController = [[MainTabBarController alloc] init];
    } else {
        self.window.rootViewController = [[CYHomeViewController alloc] init];
    }
}
- (void)initJpush:(NSDictionary *)launchOptions {
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:YMAppKey
                          channel:@"Publish channel"
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
}


- (void)setupRCIM:(UIApplication *)application launch:(NSDictionary *)launchOptions {
    // 注册融云sdk
    [[RCIM sharedRCIM] initWithAppKey:RCIN_APP_KEY];
    
    // 注册自定义数据源，用于历史聊天界面用户信息获取及展示
    self.userDataSource = [CYUserDataSource new];
    [[RCIM sharedRCIM] setUserInfoDataSource:self.userDataSource];
    
    // 注册自定义红包插件
    [[RCIM sharedRCIM] registerMessageType:[CYMoneyMessage class]];
    
    // 注册自定义功能，撤回消息
    [[RCIM sharedRCIM] registerMessageType:[CYBackMessage class]];
    /**
     * 统计推送打开率
     */
    [[RCIMClient sharedRCIMClient] recordLaunchOptionsEvent:launchOptions];
    
    /**
     * 获取融云推送服务扩展字段
     * nil 表示该启动事件不包含来自融云的推送服务
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromLaunchOptions:launchOptions];
    if (pushServiceData) {
        NSLog(@"该启动事件包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"%@", pushServiceData[key]);
        }
    } else {
        NSLog(@"该启动事件不包含来自融云的推送服务");
    }
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    NSDictionary *remoteNotificationUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    DTLog(@"%@",remoteNotificationUserInfo);
}
- (void)showNewFeature{
    //判断是否需要显示：（内部已经考虑版本及本地版本缓存）
    BOOL canShow = [CoreNewFeatureVC canShowNewFeature];
    WEAKSELF
    if(canShow){
        NewFeatureModel *m1 = [NewFeatureModel model:[UIImage imageNamed:@"f1"]];
        NewFeatureModel *m2 = [NewFeatureModel model:[UIImage imageNamed:@"f2"]];
        NewFeatureModel *m3 = [NewFeatureModel model:[UIImage imageNamed:@"f3"]];
        self.window.rootViewController = [CoreNewFeatureVC newFeatureVCWithModels:@[m1,m2,m3] enterBlock:^{
            NSLog(@"进入主页面");
            [weakSelf enter];
        }];
    }else{
        [weakSelf enter];
    }
}
- (void)enter {
    
    
}
//注册用户通知设置
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}
/**
 * 推送处理3
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
     [JPUSHService registerDeviceToken:deviceToken];
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // userInfo为远程推送的内容
}
- (void)setupJSPatch {
//    [JSPatch startWithAppKey:@"4dff174424886e9a"];
//    [JSPatch sync];
}
+ (AppDelegate*)appDelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication]delegate];
}
- (void)applicationDidEnterBackground:(UIApplication *)application{
    
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)getChatDateSource {
    [[CYNetworkManager manager].httpSessionManager GET:DEF_AllFriends parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [LCProgressHUD hide];
        NSString *startUrl = responseObject[@"pic"];
        [[NSUserDefaults standardUserDefaults] setObject:safityObject(startUrl) forKey:@"startImage"];
        
        NSString *color = responseObject[@"color"];
        [[NSUserDefaults standardUserDefaults] setObject:safityObject(color) forKey:@"color"];
        
        [SQUser sharedUser].rcChatDatesource = [CYUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        if (startUrl) {
            if (startUrl.length > 0) {
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:startUrl] options:SDWebImageAvoidAutoSetImage progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                }];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [LCProgressHUD hide];
    }];
    
//    NSString *str = @"clypic:1.png";
//    str = [str base64EncodedString];
//    NSString *url = [NSString stringWithFormat:@"http://rs.qiniu.com/delete/%@",str];
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
//    
//    NSString *Authorization = [NSString stringWithFormat:@"QBox %@",[[QNTokenHelper shared] token]];
//    [manager.requestSerializer setValue:Authorization forHTTPHeaderField:@"Authorization"];
//    
//    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        LxDBAnyVar(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
    //xcrun agvtool next-version -all
}
@end


