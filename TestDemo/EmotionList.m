//
//  EmotionList.m
//  0001-微博-框架搭建
//
//  Created by 蔡凌云 on 15-6-28.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import "EmotionList.h"
#import "EmotionPageView.h"
@interface EmotionList ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;

@end

@implementation EmotionList

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        // 1.UIScollView
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        
//        scrollView.backgroundColor = [UIColor blueColor];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        // 2.pageControl
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.userInteractionEnabled = NO;
        
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKey:@"pageImage"];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"currentPageImage"];
        
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return self;
}

// 根据emotions，创建对应个数的表情
- (void)setEmotions:(NSArray *)emotions
{
    // 根据emotions，创建对应个数的表情
    _emotions = emotions;
    
    
    //删除之前的控件  从新从沙盒加载最近表情
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
#warning  这个公式，和计算百度页码一样的公式
    //每一页表情个数
    NSUInteger count = (emotions.count + 20 - 1) / 20;
    
    // 1.设置页数
    self.pageControl.numberOfPages = count;

    
    // 2.创建用来显示每一页表情的控件
    for (int i = 0; i<self.pageControl.numberOfPages; i++) {
        EmotionPageView *pageView = [[EmotionPageView alloc] init];
        //计算这一页的表情范围
        NSRange rang;
        rang.location = i * 20;
        
        // left：剩余的表情个数（可以截取的）
        NSUInteger left = emotions.count - rang.location;
        
        if (left >= 20) {  // 这一页足够20个
            rang.length = 20;
        } else {
            rang.length = left;
        }
        
        //设置这一页表情
        pageView.emotions = [emotions subarrayWithRange:rang];
        
//        pageView.backgroundColor = CLYRandomColor;
        [self.scrollView addSubview:pageView];
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.pageControl
    self.pageControl.width = self.width;
    self.pageControl.height = 25;
    self.pageControl.x = 0;
    self.pageControl.y = self.height - self.pageControl.height;
    
     // 2.scrollView
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y;
    self.scrollView.x = self.scrollView.y = 0;
    
    // 3.设置scrollview内每一页的尺寸
    NSUInteger count = self.scrollView.subviews.count;
    for (int i = 0 ; i < count; i++) {
        UIView *pageView = self.scrollView.subviews[i];
        pageView.height = self.scrollView.height;
        pageView.width = self.scrollView.width;
        pageView.x = pageView.width*i;
        pageView.y = 0;
    }
    
     // 4.设置scrollView的contentSize
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.width, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double pageNum = scrollView.contentOffset.x / scrollView.width;
    
    self.pageControl.currentPage = (int)(pageNum + 0.5);
}

@end
