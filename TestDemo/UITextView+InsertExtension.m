//
//  UITextView+InsertExtension.m
//  小菜微博
//
//  Created by 蔡凌云 on 15-6-30.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import "UITextView+InsertExtension.h"

@implementation UITextView (InsertExtension)

- (void)insertAttributeText:(NSAttributedString *)text
{
    [self insertAttributeText:text settingBlock:nil];
}

- (void)insertAttributeText:(NSAttributedString *)text settingBlock:(void(^)(NSMutableAttributedString *attributedText))settingBlock
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    
    //拼接之前的文字 （图片和普通文字）
    [attributedText appendAttributedString:self.attributedText];
    
    //拼接图片
    NSUInteger loc = self.selectedRange.location;
//    [attributedText insertAttributedString:text atIndex:loc];
    [attributedText replaceCharactersInRange:self.selectedRange withAttributedString:text];
    
    
    //调用block
    if (settingBlock) {
        settingBlock(attributedText);
    }
    
    self.attributedText = attributedText;
    
    // 移动光标到表情后面
    self.selectedRange = NSMakeRange(loc + 1, 0);
}


@end
