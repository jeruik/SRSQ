//
//  NSString+MHCommon.m
//  PerfectProject
//
//  Created by Meng huan on 14/11/19.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import "NSString+Extension.h"
#import "NSDate+Extension.h"
// MD5加密
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (Extension)
- (NSString *)sha1 {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}
#pragma mark - MD5加密
- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[32];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    // 先转MD5，再转大写
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)md5Cdkey
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5(cStr, [num intValue], result);
    return [[NSString stringWithFormat:
             @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}
#pragma mark - URL编码
- (NSString *)urlCodingToUTF8
{
    NSString *escapedPath = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return escapedPath;
//   return [self stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}
#pragma mark - URL解码
- (NSString *)urlDecodingToUrlString
{
    return [self stringByRemovingPercentEncoding];
}
/**
 *  动态计算文字大小
 *
 *  @param font   字体
 *  @param width  限制宽度
 *  @param string 文字内容
 *
 *  @return 返回大小
 */
-(CGSize)getTextSizeWithFont:(CGFloat)fontSize restrictWidth:(float)width
{
    //动态计算文字大小
    NSDictionary *oldDict = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize oldPriceSize = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:oldDict context:nil].size;
    return oldPriceSize;
}
/**
 *  计算富文本的尺寸
 *
 *  @param width  限制宽度
 *  @param string 高度
 *
 *  @return 返回CGSize
 */
-(CGSize)getAttributedTextSizeWithRestrictWidth:(float)width  withString:(NSAttributedString*)string
{
    CGFloat titleHeight = 0.0f;
    CGFloat titleWidth  = 0.0f;
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                       options:options
                                       context:nil];
    titleHeight = ceilf(rect.size.height);
    titleWidth  = ceilf(rect.size.width);
    CGSize size = {titleWidth,titleHeight};
    return size;  // 加两个像素,防止emoji被切掉.
}
/**
 *  拼接sign 字符串
 *
 *  @param array 参数的数组
 *
 *  @return 返回一个拼接好并加密的字符串
 */
+ (NSString*)signStringByArray:(NSArray*)array
{
    NSMutableString *muString = [NSMutableString string];
    for (int i=0; i<array.count; i++) {
        NSString *string = array[i];
        [muString appendString:string];
    }
    return [muString md5];
}
/**
 *  unicode转 utf8
 *
 *  @param unicodeStr 一个 unicode 的文字
 *
 *  @return 转出 utf8编码格式
 */
+ (NSString *)unicodeToUtf8:(NSString *)unicodeStr {
    
    @try {
        
        NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
        NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
        NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
        NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
        NSString* returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
        return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
        
    }
    @catch (NSException *exception) {
        
        return @"";
        
    }
    
    @finally {
        
        
    }
    
//    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
//    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
//    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
//    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
//    NSString* returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
//    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    
}
/// 判断字符串包含另一个字符串
- (BOOL)containOfString:(NSString *)string
{
    return [self rangeOfString:string].location != NSNotFound;
}
/**
 *  utf8转 unicode
 *
 *  @param string 普通 utf8编码的字符串
 *
 *  @return 返回一个 unicode编码的字符串
 */
+ (NSString *) utf8ToUnicode:(NSString *)string
{
    NSUInteger length = [string length];
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++)
    {
        NSString *subStr = nil;
        NSString *str = @"\\";
        subStr = [NSString stringWithFormat:@"%@\\u%x",str,[string characterAtIndex:i]];
        [s appendString:subStr];
    }
    return s;
}
/**
 *  将后台返回的时间格式化
 *
 *  @param date 时间
 *
 *  @return 返回一个格式化的时间
 */
+ (NSString *)appendForrmatDate:(NSString *)date
{
    NSMutableString * str = [NSMutableString string];
    if ([date rangeOfString:@"T"].location!=NSNotFound) {
        str = [NSMutableString stringWithString:date];
        [str replaceCharactersInRange:[date rangeOfString:@"T"] withString:@" "];
        NSRange range2 = [str rangeOfString:@":"];
        if (range2.location!=NSNotFound) {
            NSUInteger length = range2.location+range2.length+2;
            str = (NSMutableString*)[str substringWithRange:NSMakeRange(0, length)];
        }
    }
    NSString *dateTime = str;
    if ([str containOfString:@" "]) {
        dateTime = [[str componentsSeparatedByString:@" "] firstObject];
        NSMutableString *stringM = [NSMutableString stringWithString:dateTime];
        while ([stringM rangeOfString:@"-"].location!=NSNotFound) {
            NSRange range = [stringM rangeOfString:@"-"];
            [stringM replaceCharactersInRange:range withString:@" "];
        }
        dateTime = stringM;
    }
    return  dateTime;
}

- (NSString *)dataNumPlanning
{
    
    NSString *result = self;
    CGFloat num = [result floatValue];
    if (num >= 10000 && num < 10000000) {
        num = num / 10000;
        result = [[NSString stringWithFormat:@"%.2f", num] stringByAppendingString:@"W"];
    } else if (num >= 10000000 && num < 100000000000) {
        num = num / 10000000;
        result = [[NSString stringWithFormat:@"%.2f", num] stringByAppendingString:@"KW"];
    }  else if ( num >= 100000000000) {
        num = num / 100000000000;
        result = [[NSString stringWithFormat:@"%.2f", num] stringByAppendingString:@"KE"];
    } else if (num < 0) {
        result = [NSString stringWithFormat:@"%d", 0];
    }
    return result;
}

-(BOOL)IsChinese:(NSString *)str
{
    for(int i=0; i< [str length];i++)
    {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}
- (BOOL)containOfChineseString {
    if ([self IsChinese:self]) {
        return YES;
    }
    return NO;
}
-(BOOL)checkPhoneNumInput {
    
    NSString *number  = @"^[0-9]*$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", number];
    BOOL res1 = [regextestmobile evaluateWithObject:self];
    return res1;
}
/**
 *  把 app 版本号转成一个数字
 */
- (NSInteger)appVersionToInteger
{
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:self];
    while ([mutableString containOfString:@"."]) {
        [mutableString deleteCharactersInRange:[mutableString rangeOfString:@"."]];
    }
    return mutableString.integerValue;
}
/**
 *  字符串如果是 N Y 的返回一个结果 BOOL 类型的返回值
 */
- (BOOL)stringIsBoolValue
{
    if ([self isEqualToString:@"Y"]) {
        return YES;
    }
    return NO;
}
/**
 *  日期格式化
 */
- (NSString *)formattingWriteDate {
    // 日期格式字符串
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 设置格式本地化,日期格式字符串需要知道是哪个国家的日期，才知道怎么转换
    fmt.locale = [NSLocale localeWithLocaleIdentifier:@"en_us"];
    NSDate *created_at = [fmt dateFromString:self];
    if ([created_at isThisYear]) { // 今年
        if ([created_at isToday]) { // 今天
            // 计算跟当前时间差距
            NSDateComponents *cmp = [created_at deltaWithNow];
            if (cmp.hour >= 1) {
                return [NSString stringWithFormat:@"%ld小时前",(long)cmp.hour];
            }else if (cmp.minute > 1){
                return [NSString stringWithFormat:@"%ld分钟前",(long)cmp.minute];
            }else{
                return @"刚刚";
            }
        }else if ([created_at isYesterday]){ // 昨天
            fmt.dateFormat = @"昨天 ";
            return  [fmt stringFromDate:created_at];
        }else{ // 前天
            fmt.dateFormat = @"MM-dd ";
            return  [fmt stringFromDate:created_at];
        }
    }else{ // 不是今年
        fmt.dateFormat = @"yyyy-MM-dd ";
        return [fmt stringFromDate:created_at];
    }
    return self;
}

/**
 *  转成日志需要的时间
 */
- (NSString *)formmatingLogDate
{
    NSDate *date = [self dateFromString];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:date];
    
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    [self monthToChineseString:month];
    
    NSString *dateString = [NSString stringWithFormat:@"%@ %@",@(day),[self monthToChineseString:month]];

    return dateString;
}
- (NSString *)monthToChineseString:(NSInteger)month {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CYDate.plist" ofType:nil]];
    return dict[[NSString stringWithFormat:@"%@",@(month)]];
}
- (NSDate*)dateFromString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:self];
    return date;
}
/**
 *  检查用户名是否为佚名
 *
 */

/**
 *  对影片封面进行处理多包含中文信息进行过滤
 */
- (NSString *)formmatingCoverImageUrl {
    NSString *string = self;
    if (string.containOfChineseString) {
        string = [string urlCodingToUTF8];
    }
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

/**
 *  用户昵称为空
 */
- (BOOL)userNameNULL {
    if (!self || [self isEqualToString:@""]) {
        return YES;
    }
    return NO;
}
@end
