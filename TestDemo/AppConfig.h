//
//  AppConfig.h
//  TestDemo
//
//  Created by 小菜 on 17/4/20.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h
   
// sharesdk
#define ShareSDKAppKey @"13f71f620a96f"

// 友盟统计
#define UMAPP_KEY @"58d0df6b677baa7d37001a70"

// 激光推送
#define YMAppKey        @"6f6e45544959ad9ce88231df"

// 七牛图片前缀，后缀
#define QiniuHeader     @"http://olt49m07v.bkt.clouddn.com/"
#define QiniuSub        @"?imageView2/1/w/150/h/150/interlace/0/q/100"

// 七牛token 和 Secret
#define QNToken         @""
#define QNSecretKey     @""

// 融云appkey 和 appsecret
#ifdef DEBUG
// 测试
#define RCIN_APP_KEY    @"m7ua80gbm72um"
#define RCIN_APP_Secret @"fcSfdbqiuuU"
#else
// 上线
#define RCIN_APP_KEY    @"xxxx"
#define RCIN_APP_Secret @"xxxx"
#endif

#endif /* AppConfig_h */
