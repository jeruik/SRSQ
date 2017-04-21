
//
//  FindHeaderView.m
//  TestDemo
//
//  Created by dzb on 17/2/4.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "FindHeaderView.h"
#import "SDCycleScrollView.h"

@interface FindHeaderView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *pageView;

@end

@implementation FindHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:nil];
        cycleScrollView.currentPageDotColor = [UIColor grayColor];
        cycleScrollView.pageDotColor = [UIColor whiteColor];
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        cycleScrollView.autoScrollTimeInterval = 4;
        cycleScrollView.onlyDisplayText = NO;
        cycleScrollView.titleLabelTextColor = [UIColor whiteColor];
        cycleScrollView.titleLabelTextFont = FONT_SIZE(13);
        cycleScrollView.titleLabelHeight = 30;
        cycleScrollView.titleLabelBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self addSubview:cycleScrollView];
        _pageView = cycleScrollView;
        
    }
    return self;
}
- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    _pageView.imageURLStringsGroup = imageArray;
}
- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    _pageView.titlesGroup = titleArray;
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    !_pageViewClick?:_pageViewClick(index);
    
}


@end
