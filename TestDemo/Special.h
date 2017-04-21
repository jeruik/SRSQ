//
//  Special.h
//  小菜微博
//
//  Created by 蔡凌云 on 15-7-5.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Special : NSObject
/** 这段特殊文字的内容 */
@property (nonatomic, copy) NSString *text;
/** 这段特殊文字的内容 */
@property (nonatomic, assign) NSRange range;

/** 这段特殊文字的矩形框(要求数组里面存放CGRect) */
@property (nonatomic, strong) NSArray *rects;

@end
