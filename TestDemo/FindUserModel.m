
//
//  FindUserModel.m
//  TestDemo
//
//  Created by dzb on 17/2/5.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "FindUserModel.h"
#import "JSONKit.h"
#import "TimeTool.h"
#import "TextPart.h"
#import "RegexKitLite.h"
#import "EmotionTool.h"
#import "Special.h"
#import "EmotionModel.h"
@implementation FindUserModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

- (void)setActcontent:(NSString *)actcontent {
    _actcontent = actcontent;
    self.attActcontent = [self attributedTextWithText:actcontent];
    
    self.contentLabH = [self.attActcontent boundingRectWithSize:CGSizeMake(CDRViewWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
}

- (void)setPhotostr:(NSString *)photostr {
    _photostr = photostr;
}
- (void)setActtime:(NSString *)acttime {
    _acttime = acttime;
    _acttime = [TimeTool changeDataFromTimeInteralStr:_acttime];
    _acttime = [_acttime formattingWriteDate];
}
- (void)setHeight:(CGFloat)height {
    _height = height;
    [self calculate];
}
- (void)calculate {
    if (self.photostr.length > 1) {
        self.photos = [self.photostr mj_JSONObject];
        
        NSMutableArray *bigImgArr = [NSMutableArray array];
        NSMutableArray *thimbArr = [NSMutableArray array];
        for (NSString *str in self.photos) {
            NSString *imgurl = [NSString stringWithFormat:@"%@%@",QiniuHeader,str];
            NSString *thimg = [NSString stringWithFormat:@"%@%@",imgurl,QiniuSub];
            [bigImgArr addObject:imgurl];
            [thimbArr addObject:thimg];
        }
        self.photos = [NSArray arrayWithArray:bigImgArr]; // 大图
        self.thimbimgPhotos = [NSArray arrayWithArray:thimbArr];
        if (self.photos.count == 1) {
            self.thimbimgPhotos = [NSArray arrayWithArray:bigImgArr];
        } else {
            
        }
    }
    [self calculateImageSize:self.thimbimgPhotos];
}
/**
 *  计算配图尺寸，顺便计算 layoutItem 的尺寸
 *
 *  @return 返回配图尺寸
 */
- (void)calculateImageSize:(NSArray *)picModel {
    NSInteger count = picModel.count;
    CGFloat margin = 5;
    if (count == 0) {
        self.photoViewSize = self.photoViewLayotSize = CGSizeZero;
    } else if (count == 1) {
        
        CGFloat width = self.width;
        CGFloat height = self.height;
        
        CGFloat scale = width / height;
        CGFloat MaxWidth = CDRViewWidth-20;
        CGFloat MaxHeight = CDRViewHeight/2;
        /*
         
         maxW   width
         ---- = -----
         maxH   height
         */
        if (width > height) {  // 宽图
            if (width  > MaxWidth) { // 如果宽度大于最大宽度
                width = MaxWidth;
                height = width / scale;
            }
        } else { // 长图
            if (height > MaxHeight) { // 长图
                height = MaxHeight;
                width = height * scale;
            }
        }
        self.photoViewLayotSize = CGSizeMake(width-1, height-1);
        self.photoViewSize = CGSizeMake(width, height);
    } else if (count == 2) {
        CGFloat cellWidth = (CDRViewWidth - 20 - margin) / 2;
        CGFloat viewWidth = cellWidth * 2 + margin;
        self.photoViewLayotSize = CGSizeMake(cellWidth, cellWidth);
        self.photoViewSize = CGSizeMake(viewWidth, cellWidth);

    } else if (count == 4) {
        CGFloat cellWidth = (CDRViewWidth - 20 - margin) / 2;
        CGFloat viewWidth = cellWidth * 2 + margin;
        self.photoViewLayotSize = CGSizeMake(cellWidth, cellWidth);
        self.photoViewSize = CGSizeMake(viewWidth, viewWidth);
    } else {
        CGFloat cellWidth = (CDRViewWidth - 20 - 2 * margin) / 3;;
        NSInteger colNumber = 3;
        NSInteger rowNumber = (count - 1) / 3 + 1;
        CGFloat viewWidth = colNumber * cellWidth + (colNumber - 1) * margin;
        CGFloat viewHeight = rowNumber * cellWidth + (rowNumber - 1) * margin;
        self.photoViewLayotSize = CGSizeMake(cellWidth, cellWidth);
        self.photoViewSize = CGSizeMake(viewWidth, viewHeight);
    }
}
- (NSAttributedString *)attributedTextWithText:(NSString *)text
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    
    // 表情的规则
    NSString *emotionPattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    // @的规则
    NSString *atPattern = @"@[0-9a-zA-Z\\u4e00-\\u9fa5-_]+";
    // #话题#的规则
    NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    // url链接的规则
    NSString *urlPattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@", emotionPattern, atPattern, topicPattern, urlPattern];
    
    // 遍历所有的特殊字符串
    NSMutableArray *parts = [NSMutableArray array];
    [text enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        
        TextPart *part = [[TextPart alloc] init];
        part.special = YES;
        part.text = *capturedStrings;
        part.emotion = [part.text hasPrefix:@"["] && [part.text hasSuffix:@"]"];
        part.range = *capturedRanges;
        [parts addObject:part];
    }];
    // 遍历所有的非特殊字符
    [text enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        
        TextPart *part = [[TextPart alloc] init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        [parts addObject:part];
    }];
    
    // 排序
    // 系统是按照从小 -> 大的顺序排列对象
    [parts sortUsingComparator:^NSComparisonResult(TextPart *part1, TextPart *part2) {
        // NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending
        // 返回NSOrderedSame:两个一样大
        // NSOrderedAscending(升序):part2>part1
        // NSOrderedDescending(降序):part1>part2
        if (part1.range.location > part2.range.location) {
            // part1>part2
            // part1放后面, part2放前面
            return NSOrderedDescending;
        }
        // part1<part2
        // part1放前面, part2放后面
        return NSOrderedAscending;
    }];
    
    UIFont *font = [UIFont systemFontOfSize:15];
    NSMutableArray *Specials = [NSMutableArray array];
    
    // 按顺序拼接每一段文字
    for (TextPart *part in parts) {
        // 等会需要拼接的子串
        NSAttributedString *substr = nil;
        if (part.isEmotion) { // 表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            NSString *name = [EmotionTool emotionWithChs:part.text].png;
            if (name) { // 能找到对应的图片
                attch.image = [UIImage imageNamed:name];
                attch.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight);
                substr = [NSAttributedString attributedStringWithAttachment:attch];
            } else { // 表情图片不存在
                substr = [[NSAttributedString alloc] initWithString:part.text];
            }
        } else if (part.special) { // 非表情的特殊文字
            substr = [[NSAttributedString alloc] initWithString:part.text attributes:@{
                                                                                       NSForegroundColorAttributeName : THEME_COLOR
                                                                                       }];
            //创建特殊对象
            Special *s = [[Special alloc] init];
            s.text = part.text;
            
            NSUInteger loc = attributedText.length;
            NSUInteger len = part.text.length;
            s.range = NSMakeRange(loc, len);
            [Specials addObject:s];
            
        } else { // 非特殊文字
            substr = [[NSAttributedString alloc] initWithString:part.text];
        }
        
        [attributedText appendAttributedString:substr];
    }
    
    // 一定要设置字体,保证计算出来的尺寸是正确的
    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedText.length)];
    [attributedText addAttribute:@"specials" value:Specials range:NSMakeRange(0, 1)]; //在数组中得位置。就是
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedText.length)];
    
    // 调整字间距
    long number = 0.8;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedText addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0, attributedText.length)];

    
    return attributedText;
}
@end
