//
//  CYAdjustButton.h
//  Junengwan
//
//  Created by 董招兵 on 16/3/10.
//  Copyright © 2016年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYAdjustButton : UIButton

/** < button 的 title 文字对齐方式 > */
@property (nonatomic,assign) NSTextAlignment textAlignment;
/** < butt 的 title 字体大小 > */
@property (nonatomic,strong) UIFont *titleFont;
/** <button 内部的 titleLabel 的 frame > */
@property (nonatomic,assign) CGRect titleLabelFrame;
/** < button 内部的 imageView 的 frame > */
@property (nonatomic,assign) CGRect imageViewFrame;
/** <点击高亮效果> */
@property (nonatomic,assign,getter = highLightEnable) BOOL highLightEnable;

/** < 只设置图片,而且显示位置居中> */
- (void)setImageViewSizeEqualToCenter:(CGSize)size;


@end
