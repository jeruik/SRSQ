
//  Created by xiaocai on 16/06/26.
//  Copyright © 2015年 小菜. All rights reserved.

#import "AppDelegate+ShareSDK.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@implementation AppDelegate (ShareSDK)
/**
 *  初始化shareSDK
 */
- (void)initShareSDK {
    [ShareSDK registerApp: ShareSDKAppKey
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            ]
                 onImport:^ (SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 // 微博
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"2663602480"
                                           appSecret:@"f8e22720901e6fc7510900f36511cb6e"
                                         redirectUri:@"http://www.baidu.com"
                                            authType:SSDKAuthTypeBoth];
                 break;
                 // 微信
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxbb0449f49ce3cbc6"
                                       appSecret:@"6b0d0270ee94065e5596c992a8eaf254"];
                 break;
             case SSDKPlatformTypeQQ:
                 // QQ
                 [appInfo SSDKSetupQQByAppId:@"1105477680"
                                      appKey:@"t0gL1YGZP5JHBPgT"
                                    authType:SSDKAuthTypeSSO];
                 break;
             default:
                 break;
         }
     }];
}

@end
