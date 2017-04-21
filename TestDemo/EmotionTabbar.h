//
//  EmotionTabbar.h
//  0001-微博-框架搭建
//
//  Created by 蔡凌云 on 15-6-28.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    EmotionTabBarButtonTypeRecent, // 最近
    EmotionTabBarButtonTypeDefault, // 默认
    EmotionTabBarButtonTypeEmoji, // emoji
    EmotionTabBarButtonTypeLxh, // 浪小花
}EmotionTabBarButtonType;

@class EmotionTabbar;

@protocol EmotionTabbarDelegate <NSObject>

@optional

- (void)emotionTabbar:(EmotionTabbar *)tabbar didSelectButton:(EmotionTabBarButtonType)buttonType;

@end

@interface EmotionTabbar : UIView

@property (nonatomic, weak) id<EmotionTabbarDelegate> delegate;

@end
