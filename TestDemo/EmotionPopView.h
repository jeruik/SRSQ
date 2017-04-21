//
//  EmotionPopView.h
//  小菜微博
//
//  Created by 蔡凌云 on 15-6-30.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EmotionModel,EmotionButton;
@interface EmotionPopView : UIView

+ (instancetype)popView;
@property (nonatomic, strong) EmotionModel *emotion;

- (void)showFrom:(EmotionButton *)button;

@end
