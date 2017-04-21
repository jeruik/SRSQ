//
//  EmotionButton.m
//  小菜微博
//
//  Created by 蔡凌云 on 15-6-30.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import "EmotionButton.h"
#import "EmotionModel.h"
#import "NSString+Emoji.h"
@implementation EmotionButton

/**
 * 当控件不是从xib storyboard中创建时，就会调用这个方法 （即通过代码创建）
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

/**
 *  当控件是从xib、storyboard中创建时，就会调用这个方法
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
         [self setup];
    }
    return self;
}

/**
 *  这个方法在initWithCoder:方法后调用
 */
- (void)awakeFromNib
{
    
}
/** 设置弹框按钮图片 */
- (void)setEmotion:(EmotionModel *)emotion
{
    _emotion  = emotion;
    
    if (emotion.png) {//有图片才需要设置
        [self setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
    } else if (emotion.code) {  //是emogi表情
        [self setTitle:[emotion.code emoji] forState:UIControlStateNormal];
    }
}

- (void)setup
{
    self.titleLabel.font = [UIFont systemFontOfSize:32];
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}

@end
