

#import "AppDelegate+UMengAnalytics.h"
#import <UMMobClick/MobClick.h>

@implementation AppDelegate (UMengAnalytics)

- (void)initWithUMengAnalytics
{
    UMAnalyticsConfig *config = [[UMAnalyticsConfig alloc] init];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
#if DEBUG
    // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setLogEnabled:YES];
#endif
    [MobClick setCrashReportEnabled:YES];
    
    config.appKey             = UMAPP_KEY;
    config.ePolicy            = BATCH;
    [MobClick startWithConfigure:config];

}

/**
 *  app 被杀掉了通知友盟统计用户离开 app
 */
- (void)applicationWillTerminate:(UIApplication *)application
{
    [MobClick profileSignOff];
}
/**
 *  开启后台模式
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    SHOW_ALERT(@"被唤醒了");
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[SDImageCache sharedImageCache] clearMemory];
}
@end
