//
//  EmotionPageView.h
//  0001-微博-框架搭建
//
//  Created by 蔡凌云 on 15-6-28.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//  用来表示一页的表情（里面显示1~20个表情）

#import <UIKit/UIKit.h>

@interface EmotionPageView : UIView

/** 代表这一页显示的表情（里面装着都是emotionModel模型）*/
@property (nonatomic, strong) NSArray *emotions;
//@property (nonatomic, copy) void(^pwd)();
@end
