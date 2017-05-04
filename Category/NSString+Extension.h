//
//  NSString+MHCommon.h
//  PerfectProject
//
//  Created by Meng huan on 14/11/19.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  NSString 通用Category
 */
@interface NSString (Extension)
- (NSString*) sha1;
#pragma mark - MD5加密
/**
 *  MD5加密
 *
 *  @return MD5加密后的新字段
 */
- (NSString *)md5;
- (NSString *)md5Cdkey;
#pragma mark - URL编码
/**
 *  URL编码，http请求遇到汉字的时候，需要转化成UTF-8
 *
 *  @return 编码的字符串
 */
- (NSString *)urlCodingToUTF8;
#pragma mark - URL解码
/**
 *  URL解码，URL格式是 %3A%2F%2F 这样的，则需要进行UTF-8解码
 *
 *  @return 解码的字符串
 */
- (NSString *)urlDecodingToUrlString;
/**
 *  unicode转 utf8
 *
 *  @param unicodeStr 一个 unicode 的文字
 *
 *  @return 转出 utf8编码格式
 */
+ (NSString *)unicodeToUtf8:(NSString *)unicodeStr;
/**
 *  utf8转 unicode
 *
 *  @param string 普通 utf8编码的字符串
 *
 *  @return 返回一个 unicode编码的字符串
 */
+ (NSString *) utf8ToUnicode:(NSString *)string;
/**
 *  计算字符串尺寸
 *
 *  @param font   字体大小
 *  @param string 文字内容
 *  @param width   限定文字的宽度
 *  @return 返回一个 CGSize类型结构体
 */
-(CGSize)getTextSizeWithFont:(CGFloat)fontSize restrictWidth:(float)width;
/**
 *  计算富文本的尺寸
 *
 *  @param width  限制宽度
 *  @param string 高度
 *
 *  @return 返回CGSize
 */
-(CGSize)getAttributedTextSizeWithRestrictWidth:(float)width  withString:(NSAttributedString*)string;
/**
 *  拼接sign 字符串
 *
 *  @param array 参数的数组
 *
 *  @return 返回一个拼接好并加密的字符串
 */
+ (NSString*)signStringByArray:(NSArray*)array;
/**
 *  将后台返回的时间格式化
 *
 *  @param date 时间
 *
 *  @return 返回一个格式化的时间
 */
+ (NSString*)appendForrmatDate:(NSString*)date;
/**
 *  数字转成字符串
 */
- (NSString *)dataNumPlanning;

/**
 *  判断字符串包含另一个字符串
 */

- (BOOL)containOfString:(NSString *)string;

/**
 *  字符串中是否包含中文
 */
-(BOOL)IsChinese:(NSString *)str;

/**
 *  验证手机号码是否为有效的手机号码
 */
-(BOOL)checkPhoneNumInput;
/**
 *  把 app 版本号转成一个数字
 */
- (NSInteger)appVersionToInteger;

/**
 *  字符串如果是 N OR Y 的返回一个结果 BOOL 类型的返回值
 */
- (BOOL)stringIsBoolValue;
/**
 *  日期格式化
 */
- (NSString *)formattingWriteDate;
/**
 *  转成日志需要的时间 
 */
- (NSString *)formmatingLogDate;

/**
 *  包含中文
 */
- (BOOL)containOfChineseString;
/**
 *  对影片封面进行处理多包含中文信息进行过滤
 */
- (NSString *)formmatingCoverImageUrl;
/**
 *  用户昵称为空
 */
- (BOOL)userNameNULL;

@end
