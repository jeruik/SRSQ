//
//  TextPart.m
//  小菜微博
//
//  Created by 蔡凌云 on 15-7-5.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import "TextPart.h"

@implementation TextPart

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@", self.text, NSStringFromRange(self.range)];
}

@end
