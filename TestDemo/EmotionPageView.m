//
//  EmotionPageView.m
//  0001-微博-框架搭建
//
//  Created by 蔡凌云 on 15-6-28.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import "EmotionPageView.h"
#import "EmotionModel.h"
#import "NSString+Emoji.h"
#import "EmotionPopView.h"
#import "EmotionButton.h"
#import "EmotionTool.h"
#import "Const.h"

@interface EmotionPageView ()

/** 点击表情后弹出的放大镜 */
@property (nonatomic, strong) EmotionPopView *popView;
/** 删除按钮 */
@property (nonatomic, weak) UIButton *deleteButton;
@end

@implementation EmotionPageView

/** 懒加载，保证之创建一次 */
- (EmotionPopView *)popView
{
    if (!_popView) {
        _popView = [EmotionPopView popView];
    }
    return _popView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加删除按钮
        UIButton *deleteButton  =[[UIButton alloc] init];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        self.deleteButton = deleteButton;
        
//        self.popView.backgroundColor = [UIColor redColor];
        
        //添加长按手势
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPageView:)]];
    }
    return self;
}

- (EmotionButton *)emotionButtonWithLocation:(CGPoint)location
{
    NSUInteger count = self.emotions.count;
    
    for (int i = 0; i < count; i ++) {
        EmotionButton *btn = self.subviews[i + 1];
        
        if (CGRectContainsPoint(btn.frame, location)) {
            //如果这个点的位置在按钮范围内， 那就没必要遍历了
            return btn;
        }
    }
    return nil;
}

/**
 *  在这个方法中处理长按手势
 */
- (void)longPressPageView:(UILongPressGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:recognizer.view];
    
    //获得手指所在的表情位置
    EmotionButton *btn = [self emotionButtonWithLocation:location];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: // 手指已经不再触摸pageView (结束触摸)
            //移除popview
            [self.popView removeFromSuperview];
            
            //如果手指还在表情按钮上
            if (btn) {
                //发通知
                [self selectEmotion:btn.emotion];
            }
            
            break;
            
        case UIGestureRecognizerStateBegan: // 手势开始（刚检测到长按）
        case UIGestureRecognizerStateChanged: { // 手势改变（手指的位置改变）
            [self.popView showFrom:btn];
            break;
        }
            
        default:
            break;
    }
}
/**
 *  选中某个表情，发出通知
 *
 *  @param emotion 被选中的表情
 */
- (void)selectEmotion:(EmotionModel *)emotion
{
    //将表情存进沙盒
    [EmotionTool addRecentEmotion:emotion];
    
    //发出通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[SelectEmotionKey] = emotion;
    [[NSNotificationCenter defaultCenter] postNotificationName:EmotionDidSelectNotification object:nil userInfo:userInfo];
//    
//    if (self.pwd) {
//        self.pwd();
//        CLYLog(@"paaa");
//        
//    }
}


/** 每一页的表情数组 */
- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    NSUInteger count = emotions.count;  //数组长度
    
    //遍历数组模型，取出对应的模型
    for (int i = 0 ; i < count ; i ++) {
        EmotionButton *btn = [[EmotionButton alloc] init];
        [self addSubview:btn];
        //设置表情数据
        btn.emotion = emotions[i];
        
        //监听按钮点击
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

// CUICatalog: Invalid asset name supplied: (null), or invalid scale factor: 2.000000
// 警告原因：尝试去加载的图片不存在

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //内边距
    CGFloat inset = 10;
    
    NSUInteger count = self.emotions.count;
    CGFloat btnW = (self.width - 2 * inset) / 7;  //7列
    CGFloat btnH = (self.height - inset) / 3;   //3行 最大行
    for (int i = 0; i<count; i++) {
        UIButton *btn = self.subviews[i + 1];
        btn.width = btnW;
        btn.height = btnH;
        
        btn.x = inset + (i%7)*btnW;
        btn.y = inset + (i/7)*btnH;
        
    }
    
    //删除按钮
    self.deleteButton.width = btnW;
    self.deleteButton.height = btnH;
    self.deleteButton.x = self.width - btnW - inset;
    self.deleteButton.y = self.height  - btnH;
}
/**
 *  监听表情按钮点击
 *
 *  @param btn 被点击的表情按钮
 */
- (void)btnClick:(EmotionButton *)btn
{
    //给popView传递数据
    //popView 拿到的模型就是点击按钮的那个模型
    
    self.popView.emotion = btn.emotion;
    
    //获得最上面的window
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self.popView];
    
    //计算出被点击按钮在window中得frame
    
    CGRect btnFrame = [btn convertRect:btn.bounds toView:window];
    self.popView.y = CGRectGetMidY(btnFrame) - self.popView.height;
    self.popView.centerX = CGRectGetMidX(btnFrame);
    
    //让popView过0.25秒自动消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
    
    //发出通知
    [self selectEmotion:btn.emotion];
}
/**
 *  监听删除按钮点击
 */

- (void)deleteButtonClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:EmotionDidDeleteNotification object:nil];
}

@end
