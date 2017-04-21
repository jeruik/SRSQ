//
//  FindDetailViewCell.m
//  TestDemo
//
//  Created by dzb on 17/2/24.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "FindDetailViewCell.h"

@interface FindDetailViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nickLab;
@property (nonatomic, strong) UIButton *replyBtn;

@end

@implementation FindDetailViewCell

- (UIButton *)replyBtn
{
    if (!_replyBtn) {
        _replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _replyBtn.contentEdgeInsets = UIEdgeInsetsMake(7, 16, 7, 11);
        _replyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _replyBtn.titleLabel.numberOfLines = 0;
        _replyBtn.userInteractionEnabled = NO;
        [_replyBtn setTitleColor:[UIColor colorWithHexString:@"#2e76ac"] forState:UIControlStateNormal];
        [_replyBtn setBackgroundImage:[UIImage imageNamed:@"newDaylog_commom_bgv"] forState:UIControlStateNormal];
    }
    return _replyBtn;
}


- (void)awakeFromNib {
    [super awakeFromNib];

    [self addSubview:self.replyBtn];

}

- (void)setReplyModel:(FindDetailReplyModel *)replyModel {
    _replyModel = replyModel;

    
//    [self.replyBtn setAttributedTitle:replyModel. forState:UIControlStateNormal];
//    self.replyBtn.frame = FRAME(self.nickLab.left, self., <#w#>, <#h#>);
    
}


@end
