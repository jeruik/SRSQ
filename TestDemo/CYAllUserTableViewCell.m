//
//  CYAllUserTableViewCell.m
//  TestDemo
//
//  Created by 小菜 on 17/2/4.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "CYAllUserTableViewCell.h"
#import "TTTagView.h"
#import "TTGroupTagView.h"
#import "CatZanButton.h"
@interface CYAllUserTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *meiliLab;

@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet CatZanButton *likeButton;
@end

@implementation CYAllUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewClick)]];
    
    self.headerView.layer.cornerRadius = 25;
    self.headerView.layer.borderWidth = 1.5;
    self.headerView.clipsToBounds = YES;
    WEAKSELF
    [_likeButton setClickHandler:^(CatZanButton *zan) {
        weakSelf.model.zan = !weakSelf.model.zan;
        [weakSelf zan:weakSelf.model];
    }];
    self.selectedBackgroundView = [UIView new];
}
- (TTTagView *)getInputTagView {
    TTTagView *inputTagView = [[TTTagView alloc] initWithFrame:FRAME(0,0, CDRViewWidth*0.8, 19)];
    inputTagView.tag = 55;
    inputTagView.userInteractionEnabled = NO;
    inputTagView.backgroundColor = [UIColor clearColor];
    inputTagView.tagHeight = 19;
    inputTagView.fontTag = FONT_SIZE(11);
    inputTagView.tagPaddingSize = CGSizeMake(5, 0);
    inputTagView.textColor = NineColor;
    inputTagView.borderColor = [NineColor colorWithAlphaComponent:0.4];
    inputTagView.translatesAutoresizingMaskIntoConstraints=YES;
    [inputTagView layoutTagviews];
    return inputTagView;
}
- (void)headerViewClick {
    if (self.headerViewBlock) {
        self.headerViewBlock(self.model);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(CYUserModel *)model {
    _model = model;
    
    self.userLabel.textColor = model.index == 0 ? [UIColor redColor] : model.index == 1 ? [UIColor orangeColor] : [UIColor blackColor];
    self.meiliLab.text = [NSString stringWithFormat:@"魅力值:%ld",model.zannum];
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:model.headimgurl] placeholderImage:[UIImage imageNamed:@"HomeAlertContentView_movie_text"]];
    self.userLabel.text = model.username;
    self.sourceLab.text = [NSString stringWithFormat:@"来自 %@ 用户",model.way];
    self.descLab.text = [NSString stringWithFormat:@"💕个人签名： %@",model.aboutme.length > 1 ? model.aboutme : @"宝宝还未来得及填写"];
    self.headerView.layer.borderColor = model.sex.integerValue == 1 ? RGBACOLOR(107,177,93,1.0).CGColor : RGBACOLOR(224,101,168,1.0).CGColor;
    CGFloat descLabBottom = 70 +[self.descLab.text getTextSizeWithFont:14 restrictWidth:CDRViewWidth-20].height + 10;
    
    [[self.contentView viewWithTag:55] removeFromSuperview];
    TTTagView *inputTagView = [self getInputTagView];
    inputTagView.y = descLabBottom;
    [self.contentView addSubview:inputTagView];
    [inputTagView layoutTagviews];
    [inputTagView addTags:[model.tags isEqualToString:@""] ? @[@"暂未填写"] : [model.tags componentsSeparatedByString:@","]];
    
    _model.cellH = descLabBottom + 19 + 10;
}

- (void)zan:(CYUserModel *)model{
    if (model.zan == YES) {
        model.zannum += 1;
        [_likeButton setImage:[UIImage imageNamed:@"post-like-button-new"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"post-like-button-new-high"] forState:UIControlStateHighlighted];
        [[CYNetworkManager manager].httpSessionManager POST:DEF_All_ZAN parameters:@{@"rcuserid":model.rcuserid} progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    } else {
        [_likeButton setImage:[UIImage imageNamed:@"post-unlike-button-new"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"post-unlike-button-new-high"] forState:UIControlStateHighlighted];
    }
    self.meiliLab.text = [NSString stringWithFormat:@"魅力值:%ld",model.zannum];
}

@end
