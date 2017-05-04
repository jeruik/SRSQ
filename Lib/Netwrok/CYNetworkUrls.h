 //
//  CYNetworkUrls.h
//  Junengwan
//
//  Created by 董招兵 on 16/1/6.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//
#import "AppDelegate.h"
#ifndef CYNetworkUrls_h
#define CYNetworkUrls_h

#pragma mark - 打包上线步骤
/**
 1.切换正式服务器
 2.检查演员权限取反，检查相册权限取反,检查 todo
 3.检查埋点
 4.检查发布证书是否可用，如果不可用配置最新证书
 5.Archive 选择release模式 profile 选择release模式
 6.打包提交审核 
 7.添加强制更新权限
 8.启动广告校正
 9.NSFontAttributeName:[UIFont boldSystemFontOfSize:18]
 10.清空缓存后要把本地的字典清除掉，不然启动广告会出问题
 
 11.JS配置,js遗留问题和埋点修复处理
 12.友盟的一些bug处理
 13.剧圈空串处理
 14.马甲包更新方案，马甲包跳转方案
 15.添加广告idfa
 14.clientType 改成 I
 */


// 服务器测试
//#define JNWAPI [AppDelegate appDelegate].jnwApi

/**
 *      JAVA测试
 */
#define                   JNWAPI @"http://192.168.1.110:9080/jnwtv-client"
/** 剧能玩阿里外网服务器 */
//#define                     JNWAPI @"http://139.196.207.238:9080/jnwtv-client"
/**
 *      景坤的服务器
 */
//#define                   JNWAPI @"http://192.168.1.9:9080/jnwtv-client"
//#define                   JNWAPI @"http://192.168.1.114:9080/jnwtv-client"
/** 希杰测试服务器 */
//#define                   JNWAPI @"http://192.168.1.13:8080/jnwtv-client"

/**
 *    JAVA正式服务器
 */
//#define                   JNWAPI @"http://appserver.jnwtv.com:8080/jnwtv-client"

/* 震哥的服务器 **/
//#define                   JNWAPI @"http://192.168.1.167:18080/jnwtv-client"
//#define                   JNWAPI @"http://123.59.84.138:18080/jnwtv-client"
//#define                   JNWAPI @"http://120.132.61.55:18080/jnwtv-client"
//#define                   JNWAPI @"http://123.59.61.167:18080/jnwtv-client"

// 外网测试服务器
//#define                   JNWAPI @"http://106.75.10.4:9080/jnwtv-client"
//#define                   JNWAPI @"https://tlsappserver.jnwtv.com/jnwtv-client"
//#define                   JNWAPI @"http://192.168.1.166:18080/jnwtv-client"

// 接口路径全拼
#define    PATH(_path)  [NSString stringWithFormat:_path, JNWAPI]
/**
 *      用户登录
 */
#define DEF_USER_Login                              PATH(@"%@/UserLogin")
/**
 *      用户注册
 */
#define DEF_USER_REGIST                             PATH(@"%@/user/register")

/**
 *      更新用户资料
 */
#define DEF_USER_UPDATE                             PATH(@"%@/UpdateUserInfo")
/**
 *      播放影片
 */
#define DEF_UserStartPlay                           PATH(@"%@/UserStartPlay")
/**
 *      获取弹幕
 */
#define DEF_GetBulletScreen                         PATH(@"%@/GetBulletScreen")
/**
 *      发送弹幕
 */
#define DEF_SendBulletScreen                        PATH(@"%@/SendBulletScreen")
/**
 *      添加/删除收藏
 */
#define DEF_UserFavroite                            PATH(@"%@/UserFavroite")
/**
 *      点赞/取消赞
 */
#define DEF_UserLike                                PATH(@"%@/UserLike")
/**
 *      获取分享的链接
 */
#define DEF_GetShareUrl                             PATH(@"%@/GetShareUrl")

/**
 *      用户选择分支
 */
#define DEF_UserSelectNext                          PATH(@"%@/UserSelectNext")
/**
 *      上一段视频
 */
#define DEF_UserSelectBack                          PATH(@"%@/UserSelectBack")
/**
 *      关注列表
 */
#define DEF_GetAttentionList                        PATH(@"%@/GetAttentionList")
/**
 *      加关注
 */
#define DEF_AddUserAttention                        PATH(@"%@/AddUserAttention")
/*
 *      取消关注
 */
#define DEF_RemoveAttention                         PATH(@"%@/RemoveAttention")
/**
 *      剧点
 */
#define DEF_GetJpointLog                            PATH(@"%@/GetJpointLog")

/**
 *      赏金明细
 */
#define DEF_GetRewardList                           PATH(@"%@/GetRewardList")

/**
 *      影片排行
 */
#define DEF_GetMovie_Rank                            PATH(@"%@/movie/getmovierank")

/**
 *      剧星榜排行
 */
#define DEF_GetPersonRank                           PATH(@"%@/user/getpersonalrank")

/**
 *      票房排行 (old)
 */
#define DEF_GetMovieRank                            PATH(@"%@/GetMovieRank")
/**
 *      获取用户排行 (old)
 */
#define DEF_GetPersionRank                          PATH(@"%@/GetPersonalRank")

/**
 *      获取打赏列表
 */
#define DEF_GetRewardList                           PATH(@"%@/GetRewardList")
/**
 *      获取个人空间
 */
#define DEF_GetUserSpace                            PATH(@"%@/user/getuserinfodetail")
/**
 *      首页
 */
#define DEF_GetHomepage                             PATH(@"%@/GetHomepage")

/**
 *      用户分享
 */
#define DEF_UserShare                               PATH(@"%@/UserShare")

/**
 *      播放视频片段
 */
#define DEF_UserPlayPart                            PATH(@"%@/UserPlayPart")
/**
 *  找回密码
 */
#define DEF_ForgetPwd_Verify                        PATH(@"%@/user/resetpwd")
/**
 *  用户个人资料
 */
#define DEF_GetUserInfo                             PATH(@"%@/GetUserInfo")
/**
 *  用户个人资料-景坤
 */
#define DEF_GetUserInfo_jk                          PATH(@"%@/user/getuserinfo")

/**
 *  getVersion
 */
#define DEF_getVersion                              PATH(@"%@/getVersion")

/**  短信验证码 */
#define DEF_CreatemobileCode                        PATH(@"%@/common/createmobilecode")
/**
 *  重置密码
 */
#define ForgetPwd_Verify                            PATH(@"%@/user/resetpwd")
/**
 *   项目详情
 */
#define DEF_ProjectInfo                             PATH(@"%@/project/getprojectinfo")
/**
 *  更多爸爸
 */
#define DEF_Getmorepapalis                          PATH(@"%@/movie/getmorepapalist")
/**
 *  	首页
 */
#define DEF_Gethomepageinfo                         PATH(@"%@/project/gethomepageinfo")
/**
 *  评论列表
 */
#define DEF_ProjectCommentlist                      PATH(@"%@/project/getcommentlist")
/**
 *  4.2.	首页动态区域
 */
#define DEF_Getmoreproject                          PATH(@"%@/project/getmoreproject")
/**
 *   热门评论 */
#define DEF_GetHotCommentList                       PATH(@"%@/project/gethotcommentlist")
/**
 *  	查看日志列表
 */
#define DEF_Getprojectloglist                       PATH(@"%@/project/getprojectloglist")
/**
 *  更多回复列表
 */
#define DEF_GetMoreCommentList                     PATH(@"%@/project/querymorecommentreply")
/**
 *  回复评论
 */
#define DEF_ReplyComment                           PATH(@"%@/project/replycomment")
/**
 *  更多众筹
 */
#define DEF_Getgetmorecrowdfundingprojectlist      PATH(@"%@/project/getmorecrowdfundingprojectlist")
/**
 *  写评论
 */
#define DEF_WriteCommentAPI                        PATH(@"%@/project/postprojectcomment")
/**
 *  评论点赞
 */
#define DEF_CommentLike                            PATH(@"%@/project/addorcanclepraise")
/**
 *  日志点赞
 */
#define DEF_LogLike                                 PATH(@"%@/project/addorcanclepraiselog")
/**
 *  影片换集
 */
#define DEF_ChangeMovie                             PATH(@"%@/movie/getmoviedetail")
/**
 *  加血
 */
#define DEF_AddHeal                                 PATH(@"%@/movie/addheal")
/**
 
 *  加载更多的日志
 */
#define DEF_logMoreList                             PATH(@"%@/project/getlogreplylist")
/**
 *  项目点赞人的信息
 */
#define DEF_LogPraiseList                           PATH(@"%@/project/querylogpraiseuserlist")
/**
 *  发表日志评论
 */
#define DEF_PublishDayLog                           PATH(@"%@/project/postlogcomment")
/**
 *  回复日志的评论
 */
#define DEF_SendLogReply                            PATH(@"%@/project/sendlogreply")
/**
 *  加血详情
 */
#define DEF_AddHealDetal                            PATH(@"%@/movie/addhealdetail")
/**
 *  获取七牛上传图片的 token
 */
#define DEF_GetQNToken                              PATH(@"%@/common/getqiniutoken")
/**
 *  上传图片成功后将 key 传给服务端
 */
#define DEF_QNUploadUserImage                       PATH(@"%@/user/uploadheadimg")
/**
 *  真爱排行
 */
#define DEF_TureLoveRank                            PATH(@"%@/user/getreallovefollowers")
/**
 *  用户兑换剧点
 */
#define DEF_UserExchangejPoint                      PATH(@"%@user/userexchangejpoint")
/**
 *  Cdkey兑换接口
 */
#define DEF_Userexchangejpoint                      PATH(@"%@/user/userexchangejpoint")
/**
 *  查询单条日志前三的回复
 */
#define DEF_LogDetail                               PATH(@"%@/project/getlogreplylistprevious")
/**
 *  评论回复前三的接口
 */
#define DEF_CommentReplyList                          PATH(@"%@/project/getcommentlistprevious")
/**
 *  TOKEN登录的请求
 */
#define DEF_AutoLoginApi                            PATH(@"%@/user/loginbytoken")
/**
 *  用户作品列表
 */
#define DEF_UserProjectList                         PATH(@"%@/user/getuserprojectlist")
/**
 *  用户相册的列表
 */
#define DEF_UserPhotos                              PATH(@"%@/user/getuserphotolist")

/**
 *  用户个人消息的接口
 */
#define DEF_USERNOTICE                              PATH(@"%@/user/getnotificationlist")

/**
 *  未读消息数量的接口
 */
#define DEF_UnReadedNotice                          PATH(@"%@/user/getmsgscount")

/**
 *  查看评论消息
 */
#define DEF_USER_READComment                        PATH(@"%@/project/querycommentreplybypcid")
/**
 *  查看日志消息
 */
#define DEF_USER_READLog                            PATH(@"%@/project/getprojectloginfobypliid")

///**
// *  用户关注影片消息
// */
//#define DEF_USER_FollowMovieList                    PATH(@"%@/user/newgetattentionmsg")
#define DEF_USER_FollowMovieList                    PATH(@"%@/user/queryattentionlist")
/**
 *  第三方登陆
 */
#define DEF_USER_OtherLogin                         PATH(@"%@/user/loginbythirdpart")
/**
 *  游客登陆
 */
#define DEF_USER_TouristLogin                       PATH(@"%@/user/loginbytourist")

/**
 *  读取系统消息
 */
#define DEF_USER_READSYSMsg                         PATH(@"%@/user/readsysnotification")

/**
 *  追剧
 */
#define DEF_LIKEWATCH                               PATH(@"%@/project/chaseorcancelproject")
/**
 *  产品列表
 */
#define DEF_ProductList                             PATH(@"%@/user/getproductlist")
/**
 *  充值据点
 */
#define DEF_Rechargejpointforios                    PATH(@"%@/user/rechargejpointforios")

/**
 *  准备充值接口
 */
#define DEF_Prepareforrecharg                       PATH(@"%@/user/prepareforrecharge")
/**
 *  礼物列表查询
 */
#define DEF_GetgiftList                             PATH(@"%@/gift/getgiftlist")
/**
 *  影片打赏发礼物
 */
#define DEF_SENDGIFT_MOVIE                          PATH(@"%@/gift/giving2movie")
/**
 *  个人打赏发礼物
 */
#define DEF_SENDGIFT_PERSONAL                       PATH(@"%@/gift/giving2user")

/**
 *  获取消息中心礼物列表
 */
#define DEF_MsgCenter_GiftList                      PATH(@"%@/gift/getnotificationlist")
/**
 *  拆礼物
 */
#define DEF_Open_Gift                               PATH(@"%@/gift/opengift")
/**
 *  答谢
 */
#define DEF_Send_Thanks                             PATH(@"%@/gift/sendmsg4thanks")
/**
 *  举报
 */
#define DEF_Report                                  PATH(@"%@/user/feedback")

/**
 *  首页banner
 */
#define DEF_Home_Banner                             PATH(@"%@/common/listbanner")
/**
 *  发布剧圈
 */
#define DEF_Release_DayLog                          PATH(@"%@/project/staffaddprojectlog")
/**
 *  发布水区帖子
 */
#define DEF_Release_WaterDaylog                     PATH(@"%@/chat/publishchat")
/**
 *  演职人员上传照片
 */
#define DEF_UploadPhoto                             PATH(@"%@/user/staffuploadphoto")
/**
 *  演员删除照片
 */
#define DEF_DeletePhoto                             PATH(@"%@/user/staffdeletephoto")
/**
 *  启动图片
 */
#define DEF_LoadPushPhoto                           PATH(@"%@/common/startpage")
/**
 *  剧圈送礼
 */
#define DEF_PostGift                                PATH(@"%@/gift/postlogcomment")
/**
 * 回复日志评论
 */
#define DEF_PostLogreply                            PATH(@"%@/gift/postlogreply")

/**
 *  日志点赞列表
 */
#define DEF_DayLogZanList                           PATH(@"%@/project/querylogpraiseuserlist")
/**
 *  获取版本信息
 */
#define DEF_GetVersionService                       PATH(@"%@/common/getversioninfoservice")
/**
 *  收藏列表-jk
 */
#define DEF_GetUserCollection                       PATH(@"%@/user/getusercollection")
/**
 *  banner点击统计
 */
#define DEF_BannerClick                             PATH(@"%@/common/bannercount")
/**
 *  Cast
 */
#define DEF_CastList                                PATH(@"%@/project/querycast")
/**
 *  查询任务
 */
#define DEF_JpointTask                              PATH(@"%@/task/tasklist")
/**
 *  兑换奖励
 */
#define DEF_JpointExchange                          PATH(@"%@/task/exchangereward")
/**
 * 首页精品
 */
#define DEF_Home_Daylog                             PATH (@"%@/project/homepageprojectlog")
/**
 * 首页水区
 */
#define DEF_Home_DaylogWater                        PATH (@"%@/chat/querychatlist")
/**
 * 剧点任务兑换奖励
 */
#define DEF_JpointExchange                           PATH(@"%@/task/exchangereward")
/**
 *  活动列表查询
 */
#define DEF_JpointActiveList                         PATH(@"%@/common/queryactivelist")
/**
 * 活动详情信息查询
 */
#define DEF_JpointActiveInfo                         PATH(@"%@/common/queryactiveinfo")
/**
 *  看片支付
 */
#define DEF_Movie_Pay                                PATH(@"%@/user/paytowatch")
/**
 *  掌阅下载统计
 */
#define DEF_ZY_Download                              PATH(@"%@/common/downloadstatistics")
/**
 *  隐藏兑换剧点
 */
#define DEF_Hide_Jpoint                              PATH(@"%@/common/checkauditcycle")
/**
 *  漫画详情
 */
#define DEF_CartoonDetail                             PATH(@"%@/projectcartoon/getlivecartooninfo")
/*
 *  原著下载
 */
#define DEF_ZY_Download                               PATH(@"%@/common/downloadstatistics")
/**
 *  漫画详情
 */
#define DEF_Cartoon_project                           PATH(@"%@/projectcartoon/getprojectlivecartooninfo")
/**
 *  查看更多漫画列表
 */
#define DEF_Cartoon_projectMoreList                   PATH(@"%@/projectcartoon/getmorelivecartooninfo")
/*
 *  漫画解锁，支付
 */
#define DEF_Cartoon_Pay                               PATH(@"%@/projectcartoon/paytowatch")
/*
 *  漫画分享
 */
#define DEF_Cartoon_projectShare                      PATH(@"%@/projectcartoon/share")
/*
 *  追漫
 */
#define DEF_Cartoon_projectZhui                       PATH(@"%@/projectcartoon/chaseorcancel")

/**
 * 漫画送礼
 */
#define DEF_Cartoon_sendGift                          PATH(@"%@/gift/giving2cartoon")
/**
 * 举报某一帖子
 */
#define DEF_chat_report                               PATH(@"%@/chat/report")
/**
 * 举报某一帖子
 */
#define DEF_Home_MovieList                            PATH(@"%@/project/newhomepage")
#define DEF_chat_report                               PATH(@"%@/chat/report")
/**
 * 举报项目评论
 */
#define DEF_chat_ProjectComment                       PATH(@"%@/project/reportcomment")

/**
 * 订单申诉 order/appeal
 */
#define DEF_Order_Appeal                              PATH(@"%@/order/appeal")
/**
 * 订单列表
 */
#define DEF_Order_Querylist                           PATH(@"%@/order/querylist")
/**
 * 申请补单
 */
#define DEF_Order_Supplement                          PATH(@"%@/order/supplement")
/**
 * 壁纸列表
 */
#define DEF_WallPaperList                             PATH(@"%@/project/wallpaperlist")
/**
 *  壁纸解锁
 */
#define DEF_WallLock                                  PATH(@"%@/project/unlockwallpaper")
/**
 *  壁纸下载统计
 */
#define DEF_WallDownLoadCount                         PATH(@"%@/project/wallpaperdownloadcount")
/**
 *  用户进入问卷
 */
#define DEF_User_QuestionInfo                         PATH(@"%@/question/queryquestioninfo")
/**
 *  用户提交问卷答案
 */
#define DEF_User_Answer                                PATH(@"%@/question/postanswer")
/**
 *  用户修改问卷答案
 */
#define DEF_User_Change                                PATH(@"%@/question/changeanswer")

#define DEF_Daylogdetail_question                      PATH(@"%@/question/queryquestionresult")
/**
 *  漫画详情发送弹幕
 */
#define DEF_CartoonDetail_sendbarrage                  PATH(@"%@/projectcartoon/sendbarrage")
/**
 *  漫画详情查询弹幕
 */
#define DEF_CartoonDetail_Querrybarrage                PATH(@"%@/projectcartoon/querybarrage")
/** 自动播放音频 */
#define DEF_CartoonDetail_Audio                        PATH(@"%@/projectcartoon/querydubbinglist")

/** 删除音频 */
#define DEF_CartoonDetail_delect                        PATH(@"%@/projectcartoon/deletedubbing")

/** 修改音频 */
#define DEF_CartoonDetail_Update                        PATH(@"%@/projectcartoon/updatedubbing")
/** 获取演员列表 */
#define DEF_CartoonDetail_Audio_actors                   PATH(@"%@/projectcartoon/querydubbingactor")

/** 上传音频 */
#define DEF_CartoonDetail_UpLoad                        PATH(@"%@/projectcartoon/uploaddubbing")
/** vip特权描述 */
#define DEF_User_QuerryVip                              PATH(@"%@/user/queryvipprivilege")
/** VIP产品信息列表 */
#define DEF_User_VipProductList                         PATH(@"%@/user/getvipproductlist")
/** 搜索界面获取推荐列表 */
#define DEF_Home_SearchRecommend                        PATH(@"%@/common/searchrecommend")
/** 搜索结果 */
#define DEF_Home_SearchResult                           PATH(@"%@/common/searchresult")



// ========== 发现页接口-begin ==========
// 热门推荐
#define DEF_Home_find_hot_rec                         PATH(@"%@/project/queryboutiquelist")
// 热门产房
#define DEF_Home_find_hot_wait                        PATH(@"%@/project/querycrowdfundinglist")
// 漫画
#define DEF_Home_find_hot_cartoon                     PATH(@"%@/project/queryhotlivecartoonlist")
// 七日榜
#define DEF_Home_find_seven_rank                      PATH(@"%@/project/movieranklist")
// 热门推荐
#define DEF_Home_find_new_update                      PATH(@"%@/project/querydynamiclist")
// 热门推荐
#define DEF_Home_find_person_rank                     PATH(@"%@/project/getpersonalrank")
// ========== 发现页接口-end   ==========

// 影片情节解锁
#define DEF_Movie_unlocknode                          PATH(@"%@/movie/unlocknode")

// 我的发帖纪录
#define DEF_User_PostTopic                            PATH(@"%@/user/chatlist")
// 我的追剧
#define DEF_User_Movie_list                           PATH(@"%@/user/chaseprojectlist")
// 我的追漫
#define DEF_User_Cartoon_List                         PATH(@"%@/user/chasecartoonlist")

// 获取邀请码
#define DEF_User_invitecode                           PATH(@"%@/user/queryinvitecode")

// 输入邀请码获取剧点
#define DEF_User_invite_accep                         PATH(@"%@/user/acceptinvitation")

// 是否有评分权限
#define DEF_User_CommonStatus                         PATH(@"%@/common/checkhavegrade")

// 去评分
#define DEF_User_goRecord                             PATH(@"%@/common/grade")

// 获得剧点和代金券
#define DEF_User_pointAndCoupon                       PATH(@"%@/user/getuserjpoint")

// 获取活动列表
#define DEF_Actor_List                                PATH(@"%@/oscar/queryactivelist")
// 获取演员列表
#define DEF_Vote_Actor_List                           PATH(@"%@/oscar/queryactorlist")
// 活动信息详情
#define DEF_Actor_Detail                              PATH(@"%@/oscar/queryoscaractiveinfo")
/** 选票信息列表 */
#define DEF_VoteInfo_list                             PATH(@"%@/oscar/queryvotelist")
/** 用户投票 */
#define DEF_VoteInfo_vote                             PATH(@"%@/oscar/initiatevote")
// 用户宝箱
#define DEF_User_box                                  PATH(@"%@/user/querychest")
// 选票回复
#define DEF_Choose_Reply                              PATH(@"%@/oscar/postlogcomment")
// 选票回复楼层
#define DEF_Choose_Reply_floor                        PATH(@"%@/oscar/postlogreply")


#pragma mark - =================    可能废弃接口  =================
/************************************  废弃接口  ***********************************************/

#pragma mark - 榜单还在
//#define DEF_GetPersonalRank                         PATH(@"%@/GetPersonalRank")
#pragma mark - 用户资料还在
//#define DEF_USER_INFO                               PATH(@"%@/GetUserInfo")
#pragma mark - 赠送礼物给个人
//#define DEF_PostGiftGiveUser                        PATH(@"%@/gift/giving2user")
/************************************  完全废弃接口  ***********************************************/
/**
 *      进行打赏
 */
//#define DEF_SendReward                              PATH(@"%@/SendReward")
/**
 *      影片详情
 */
//#define DEF_MOVIEDETAIL                             PATH(@"%@/GetMovieDetail")
/**
 *      解锁的片段
 */
//#define DEF_GetUserUnlock                           PATH(@"%@/GetUserUnlock")

/**
 *      收藏列表
 */
//#define DEF_GetFavroiteList                         PATH(@"%@/GetFavroiteList")
/**
 *      获取关注消息列表
 */
//#define DEF_GetAttentionMsg                         PATH(@"%@/GetAttentionMsg")
/**
 *      上传头像
 */
//#define DEF_UploadHeadImg                           PATH(@"%@/UploadHeadImg")
/**
 *      用户分享完毕刷新数据
 */
//#define DEF_UserShareReuqest                        PATH(@"%@/userShareReuqest")
/**
 *  GetPrivateMsg
 */
//#define DEF_GetPrivateMsg                           PATH(@"%@/GetPrivateMsg")
/**
 *  GetFanlist
 */
//#define DEF_GetFanlist                              PATH(@"%@/GetFanlist")
/**
 *  GetPrivateMsg_UserList
 */
//#define DEF_GetPrivateMsg_UserList                  PATH(@"%@/GetPrivateMsg_UserList")
/**
 *  GetPrivateMsg_Latest
 */
//#define DEF_GetPrivateMsg_Latest                    PATH(@"%@/GetPrivateMsg_Latest")
/**
 *  SendtPrivateMsg
 */
//#define DEF_SendtPrivateMsg                         PATH(@"%@/SendtPrivateMsg")
/**
 *  GetStartupConfig
 */
//#define DEF_GetStartupConfig                        PATH(@"%@/GetStartupConfig")
/**
 *  用户被打赏消息的明细
 */
//#define DEF_USER_RewardList                         PATH(@"%@/user/newgetrewardlist")
/**
 *  评论详情页面
 */
//#define DEF_CommentDetailApi                        PATH(@"%@/project/getreplylist")



#endif
/* CYNetworkUrls_h */
