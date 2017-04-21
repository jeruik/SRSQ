//
//  SQUrls.h
//  TestDemo
//
//  Created by 小菜 on 17/2/17.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//



#ifdef DEBUG
//    #define                   SQAPI @"http://cly.local:8080"        // 测试
    #define                   SQAPI @"https://srsq.herokuapp.com"  // 上线
#else
    #define                   SQAPI @"https://srsq.herokuapp.com"  // 上线
#endif

#define    PATH(_path)  [NSString stringWithFormat:_path, SQAPI]

// 第三方用户登录
#define DEF_ThirdUSER_Login  PATH(@"%@/friends/friendLogin")

// 获取cookie
#define DEF_User_cookie  PATH(@"%@/friends/secure")

// 保存融云token
#define DEF_SaveRctoken      PATH(@"%@/friends/rctoken")

// 广场
#define DEF_AllFriends       PATH(@"%@/allUsers/allFriends")
// 广场赞
#define DEF_All_ZAN          PATH(@"%@/friends/zan")

// 获取Banner 条数据
#define DEF_SQBanner         PATH(@"%@/sqbanner/banner")
// 添加banner 条
#define DEF_SQAddBanner      PATH(@"%@/sqbanner/addbanner")

// 获取剧圈列表
#define DEF_ACT_List         PATH(@"%@/sqacitves/act")
// 获取剧圈列表
#define DEF_ACT_Zan          PATH(@"%@/sqacitves/zan")
// 发剧圈
#define DEF_ACT_Release      PATH(@"%@/sqacitves/release")

// 个人中心
#define DEF_User_Profile     PATH(@"%@/user/profile")
// 更新昵称
#define DEF_User_UpdateNick     PATH(@"%@/user/updateNick")
// 更新签名
#define DEF_User_UpdateAboutMe     PATH(@"%@/user/updateAboutMe")
// 更新标签
#define DEF_User_UpdateTags     PATH(@"%@/user/updateTags")
// 更新相册
#define DEF_User_UpdatePhotos     PATH(@"%@/user/updatePhotos")

// 更新头像
#define DEF_User_UpdateHeaderImage     PATH(@"%@/user/updateHeaderImage")

// 苹果审核
#define DEF_User_AppleLogin     PATH(@"%@/apple/login")

// 版本更新
#define DEF_Get_Version         PATH(@"%@/version")

