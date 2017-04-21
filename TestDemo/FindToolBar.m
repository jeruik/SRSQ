//
//  FindToolBar.m
//  TestDemo
//
//  Created by 小菜 on 17/2/23.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "FindToolBar.h"
#import "TimeTool.h"
#import "CatZanButton.h"

@interface FindToolBar ()

@property (nonatomic, strong) CatZanButton *zanBtn;
@property (nonatomic, strong) UILabel *zanLab;
@property (nonatomic, strong) UIImageView *locView;
//UIImageView locationicon
@end

@implementation FindToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.locView = [[UIImageView alloc] initWithFrame:FRAME(0, 15, 20, 20)];
        [self.locView setImage:[UIImage imageNamed:@"locationicon"]];
        [self addSubview:self.locView];
        
        self.timeLab = [[UILabel alloc] initWithFrame:FRAME(self.locView.right, 0, 100, 50)];
        self.timeLab.font = FONT_SIZE(10);
        self.timeLab.textColor = Six_Color;
        self.timeLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.timeLab];
        
        self.zanLab = [UILabel ZHXLabelLabelText:@"0" font:12 textColor:[UIColor redColor] backGroundColor:nil target:nil sel:nil];
        self.zanLab.frame = FRAME(CDRViewWidth-50, 15,40,20);
        self.zanLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.zanLab];
        
        self.zanBtn = [[CatZanButton alloc] initWithFrame:FRAME(self.zanLab.left - 20 -5, 15, 20, 20)];
        WEAKSELF
        [self.zanBtn setClickHandler:^(CatZanButton *zan) {
            weakSelf.userModel.zan = !weakSelf.userModel.zan;
            [weakSelf zan:weakSelf.userModel];
        }];
        [self addSubview:self.zanBtn];
        
        UIView *line = [[UIView alloc] initWithFrame:FRAME(0, 49, CDRViewWidth, 0.5)];
        line.backgroundColor = [NineColor colorWithAlphaComponent:0.5];
        [self addSubview:line];
    }
    return self;
}
- (void)zan:(FindUserModel *)userModel {

    if (userModel.zan) {
        userModel.zancount += 1;
        [[CYNetworkManager manager].httpSessionManager POST:DEF_ACT_Zan parameters:@{@"id":@(userModel.ID)} progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    } else {
        userModel.zancount -= 1;
    }
    self.userModel = userModel;
}
- (void)setUserModel:(FindUserModel *)userModel {
    _userModel = userModel;
    
    self.zanLab.text = [NSString stringWithFormat:@"热度:%ld",(long)userModel.zancount];
    self.timeLab.text = userModel.sqlocal;
}

@end
