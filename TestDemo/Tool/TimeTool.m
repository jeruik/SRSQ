//
//  TimeTool.m
//  Junengwan
//
//  Created by 小菜 on 16/11/23.
//  Copyright © 2016年 ‰∏äÊµ∑Ëß¶ÂΩ±ÊñáÂåñ‰º†Êí≠ÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TimeTool.h"

@implementation TimeTool

+ (NSString *)timeWithCurrentTime:(NSString *)currTime endTime:(NSString *)endTime {
    return [self dateTimeDifferenceWithStartTime:[self getCurrentDate] endTime:[self getDateString:endTime]];
}

+ (NSString *)timeWith:(NSString *)timer {
    return [self dateTimeDifferenceWithStartTime:[self getCurrentDate] endTime:[self getDateString:timer]];
}

+ (NSString *)getDateString:(NSString *)spString
{
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[spString intValue]];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];// hh与HH的区别:分别表示12小时制,24小时制
    NSString* string=[dateFormat stringFromDate:confromTimesp];
    LxDBAnyVar(string);
    return string;
}

/**
 * 开始到结束的时间差
 */
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int second = (int)value %60;//秒
    int minute = (int)value /60%60;
    int house = (int)value / (24 * 3600)%3600;
    int day = (int)value / (24 * 3600);
    NSString *str;
    if (day != 0) {
        str = [NSString stringWithFormat:@"%d天%d小时%d分%d秒",day,house,minute,second];
    }else if (day==0 && house != 0) {
        str = [NSString stringWithFormat:@"%d小时%d分%d秒",house,minute,second];
    }else if (day== 0 && house== 0 && minute!=0) {
        str = [NSString stringWithFormat:@"%d分%d秒",minute,second];
    }else{
        str = [NSString stringWithFormat:@"%d秒",second];
    }
    return str;
}
+ (NSString *)getCurrentDate {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}
+ (NSString *)getDate {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}
+ (NSString *)getCurrentDateNumber {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSTimeInterval start = [currentDate timeIntervalSince1970]*1000;
    NSString *num = [NSString stringWithFormat:@"%.f",start];
    return num;
}
+ (NSString *)changeDataFromTimeInteralStr:(NSString *)str {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[str doubleValue]/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

@end
