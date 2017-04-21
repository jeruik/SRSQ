//
//  EmotionKeyboard.m
//  0001-微博-框架搭建
//
//  Created by 蔡凌云 on 15-6-28.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import "EmotionKeyboard.h"
#import "EmotionList.h"
#import "EmotionTabbar.h"
#import "EmotionModel.h"
#import "EmotionTool.h"
#import "Const.h"

@interface EmotionKeyboard () <EmotionTabbarDelegate>

//@property (nonatomic, weak) EmotionList *listView;
@property (nonatomic, weak) EmotionTabbar *tabbar;

/** 保存正在显示listView */
@property (nonatomic, weak) EmotionList *showingListView;

/** 四个表情控件，涌来存放表情 */
@property (nonatomic, strong) EmotionList *recentListView;
@property (nonatomic, strong) EmotionList *defaultListView;
@property (nonatomic, strong) EmotionList *emojiListView;
@property (nonatomic, strong) EmotionList *lxhListView;

@end

@implementation EmotionKeyboard

#pragma mark - 懒加载
- (EmotionList *)recentListView
{
    if (!_recentListView) {
        self.recentListView = [[EmotionList alloc] init];
        //加载沙盒数据
        self.recentListView.emotions = [EmotionTool recentEmotions];
    }
    return _recentListView;
}

- (EmotionList *)defaultListView
{
    if (!_defaultListView) {
        self.defaultListView = [[EmotionList alloc] init];
        self.defaultListView.emotions = [EmotionTool defaultEmotions];
    }
    return _defaultListView;
}
- (EmotionList *)emojiListView
{
    if (!_emojiListView) {
        self.emojiListView = [[EmotionList alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        self.emojiListView.emotions = [EmotionTool emojiEmotions];
    }
    return _emojiListView;
}
- (EmotionList *)lxhListView
{
    if (!_lxhListView) {
        self.lxhListView = [[EmotionList alloc] init];
        self.lxhListView.emotions = [EmotionTool lxhEmotions];
    }
    return _lxhListView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

//        self.recentListView.backgroundColor = [UIColor yellowColor];
        EmotionTabbar *tabbar = [[EmotionTabbar alloc] init];
//        tabbar.backgroundColor = CLYRandomColor;
        tabbar.delegate = self;
        [self addSubview:tabbar];
        self.tabbar = tabbar;
        
//        CLYLog(@"%@",self.recentListView.subviews);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelect) name:EmotionDidSelectNotification object:nil];
    }
    return self;
}

- (void)emotionDidSelect
{
    self.recentListView.emotions = [EmotionTool recentEmotions];
   
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //tabbar
    self.tabbar.width = self.width;
    self.tabbar.height = 37;
    self.tabbar.x = 0;
    self.tabbar.y = self.height - self.tabbar.height;
    
    //表情栏
    self.showingListView.x = self.showingListView.y = 0;
    self.showingListView.width = self.width;
    self.showingListView.height = self.tabbar.y;
    

}
#pragma mark - HWEmotionTabBarDelegate

- (void)emotionTabbar:(EmotionTabbar *)tabbar didSelectButton:(EmotionTabBarButtonType)buttonType
{
    // 移除showingListView之前显示的控件
    [self.showingListView removeFromSuperview];
    
     // 根据按钮类型，切换contentView上面的listview
    switch (buttonType) {
        case EmotionTabBarButtonTypeRecent:
            [self addSubview:self.recentListView];
            break;
            
        case EmotionTabBarButtonTypeDefault:
            [self addSubview:self.defaultListView];
            break;
            
        case EmotionTabBarButtonTypeEmoji:
            [self addSubview:self.emojiListView];
            break;
            
        case EmotionTabBarButtonTypeLxh:
            [self addSubview:self.lxhListView];
            break;
    }
#warning   重新计算子控件的frame(setNeedsLayout内部会在恰当的时刻，重新调用layoutSubviews，重新布局子控件)
    
    //设置正在显示的listView
    self.showingListView = [self.subviews lastObject];
    
    [self setNeedsLayout];
}
@end
