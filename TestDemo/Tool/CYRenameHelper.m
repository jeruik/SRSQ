//
//  CYRenameHelper.m
//  Junengwan
//
//  Created by 小菜 on 16/7/15.
//  Copyright © 2016年 上海触影文化传播有限公司. All rights reserved.
//

#import "CYRenameHelper.h"

@implementation CYRenameHelper

/**
 * 返回时间戳
 */
+ (NSString *)getDateTimeString {
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    BOOL haveChinese = [dateString IsChinese:dateString];
    
    if (haveChinese) {
        dateString = [dateString substringToIndex:8];
    }
    
    return dateString;
}
/** < 获得当前时间 > */
+ (NSString *)getCurrentDate {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}
/**
 *  生成八位组合数字串
 */
+ (NSString *)randomStringWithLength:(int)len {
    
    NSString *letters = @"12345678";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i = 0; i<len; i++) {
        
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    return randomString;
}

+ (NSString *)getNamePrefix:(ProjextType)type {
    
    switch (type) {
        case projextTypeHeader:
            return @"H";
            break;
        case projextTypeGiftImg:
            return @"G";
            break;
        case projextTypeGiftAudio:
            return @"GA";
            break;
        case projextTypeDayLogImg:
            return @"PLI";
            break;
        case projextTypeDayLogVideo:
            return @"PLV";
            break;
        case projextTypeMovie:
            return @"M";
            break;
        case projextTypeMovieImg:
            return @"MC";
            break;
        case projextTypeImg:
            return @"PC";
            break;
        case projextTypeother:
            return @"PCC";
            break;
        case projextTypeAlbumPic:
            return @"P";
            break;
    }
}
/**
 * 头像路径名
 */
+ (NSString *)qnHeaderPath {
    NSString *pri = [CYRenameHelper getNamePrefix:projextTypeHeader];
    NSString *account = [SQUser sharedUser].account;
    NSString *time = [CYRenameHelper getDateTimeString];
    NSString *num = [CYRenameHelper randomStringWithLength:8];
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@",pri,account,time,num,@".jpg"];
    LxDBAnyVar(str);
    return str;
}
/**
 *  @param ggid 订单编号
 */
+ (NSString *)qnGiftAudioPath:(NSString *)ggid {
    
    NSString *pri = [CYRenameHelper getNamePrefix:projextTypeGiftAudio];
    NSString *tenGgid;
    NSString *temp = @"0000000000";
    if(ggid.length<10){
        NSString *zenoStr = [temp substringToIndex:(10-ggid.length)];
        tenGgid = [NSString stringWithFormat:@"%@%@",ggid,zenoStr];
    } else {
        tenGgid = ggid;
    }
    NSString *time = [CYRenameHelper getDateTimeString];
    NSString *num = [CYRenameHelper randomStringWithLength:8];
    return [NSString stringWithFormat:@"%@%@%@%@%@",pri,tenGgid,time,num,@".mp3"];
}
/**
 *  发布剧圈图片名
 *
 *  @return
 */
+ (NSString *)qnReleaseDayImage {
    NSString *time = [CYRenameHelper getDateTimeString];
    NSString *num = [CYRenameHelper randomStringWithLength:3];
    return [NSString stringWithFormat:@"%@%@%@",time,num,@".jpg"];
}

/**
 *  上传相册图片命名
 *
 *  @return
 */
+ (NSString *)qnUpLoadImage {
    NSString *pri = [CYRenameHelper getNamePrefix:projextTypeAlbumPic];
    NSString *account = [SQUser sharedUser].account;
    NSString *time = [CYRenameHelper getDateTimeString];
    NSString *num = [CYRenameHelper randomStringWithLength:8];
    return [NSString stringWithFormat:@"%@%@%@%@%@",pri,account,time,num,@".jpg"];
}
+ (NSString *)getRcID {
    NSString *time = [CYRenameHelper getDateTimeString];
    NSString *num = [CYRenameHelper randomStringWithLength:8];
    return [NSString stringWithFormat:@"%@%@",time,num];
}
@end
