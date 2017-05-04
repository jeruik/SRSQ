//
//  TimeTool.h
//  Junengwan
//
//  Created by 小菜 on 16/11/23.
//  Copyright © 2016年 ‰∏äÊµ∑Ëß¶ÂΩ±ÊñáÂåñ‰º†Êí≠ÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTool : NSObject

+ (NSString *)timeWithCurrentTime:(NSString *)currTime endTime:(NSString *)endTime;

+ (NSString *)timeWith:(NSString *)timer;
/* 获取时间  */
+ (NSString *)getCurrentDate;
/* 获取时间  (年 月 日) */
+ (NSString *)getDate;
/*  获取时间戳 */
+ (NSString *)getCurrentDateNumber;
/*  时间戳转时间 */
+ (NSString *)changeDataFromTimeInteralStr:(NSString *)str;

+ (NSString *)getDateString:(NSString *)spString;

@end
