//
//  CYUserAlbumView.m
//  Junengwan
//
//  Created by dzb on 16/7/18.
//  Copyright © 2016年 上海触影文化传播有限公司. All rights reserved.
//

#import "CYUserAlbumView.h"
#import "CYAlbumContentView.h"
#import "Masonry.h"

@implementation CYUserAlbumView

- (instancetype)initWithFrame:(CGRect)frame withButtonCount:(NSInteger)count {

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        WEAKSELF
        self.contentView = [UIView new];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 8;
        self.contentView.clipsToBounds = YES;
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(309*CDRWidthScale);
            make.height.mas_equalTo(210*CDRHeightScale);
            make.center.mas_equalTo(weakSelf);
        }];
        
        CYAlbumContentView *view = [[CYAlbumContentView alloc] init];
        
        view.imgClickBlock = ^(NSInteger index,UIImageView *img){
            if (weakSelf.btnClickBlock) {
                weakSelf.btnClickBlock(index,img);
                if (index != 2) {
                    [weakSelf closeView];
                }
            }
        };
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(weakSelf.contentView);
        }];
        [self.contentView layoutIfNeeded];
        view.count = count;
        [self showAnimation];
    }
    return self;
}


#pragma mark - showAnimation
- (void)showAnimation {
    WEAKSELF
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"giftView_close"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(35);
        make.top.left.mas_equalTo(weakSelf.contentView);
    }];
    self.contentView.transform = CGAffineTransformMakeScale(0.0, 0.0);
}

#pragma mark - Actions
- (void)closeView {
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.userInteractionEnabled = NO;
        self.contentView.transform = CGAffineTransformMakeScale(0.000001, 0.000001);
    } completion:^(BOOL finished) {

        [self removeFromSuperview];
    }];
}

@end
