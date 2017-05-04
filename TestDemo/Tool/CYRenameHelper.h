//
//  CYRenameHelper.h
//  Junengwan
//
//  Created by 小菜 on 16/7/15.
//  Copyright © 2016年 上海触影文化传播有限公司. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ProjextType) {
    projextTypeHeader = 0,          // 头像
    projextTypeGiftImg,         // 礼物图片
    projextTypeGiftAudio,       // 礼物录音
    projextTypeDayLogImg,       // 剧圈图片
    projextTypeDayLogVideo,     // 剧圈视频
    projextTypeMovie,           // 影片
    projextTypeMovieImg,        // 影片封面
    projextTypeImg,             // 项目封面
    projextTypeother,           // 项目众筹封面
    projextTypeAlbumPic         // 相册图片
};
@interface CYRenameHelper : NSObject
/** < 获得当前时间 > */
+ (NSString *)getCurrentDate;
/**
 *  获得头像命名
 *
 *  @return
 */
+ (NSString *)qnHeaderPath;
/**
 *  礼物录音命名
 *
 *  @return
 */
+ (NSString *)qnGiftAudioPath:(NSString *)ggid;
/**
 *  剧圈图片上传
 *
 *  @return
 */
+ (NSString *)qnReleaseDayImage;
/**
 *  相册上传图片
 */
+ (NSString *)qnUpLoadImage;

/** 生成八位组合数字串 */
+ (NSString *)randomStringWithLength:(int)len;

/** 返回时间戳 */
+ (NSString *)getDateTimeString;

/** 获取项目前缀 */
+ (NSString *)getNamePrefix:(ProjextType)type;

+ (NSString *)getRcID;

@end
