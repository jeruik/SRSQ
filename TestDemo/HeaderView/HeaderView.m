//
//  HeaderView.m
//  JSMineHomePage
//
//  Created by normal on 2016/12/5.
//  Copyright © 2016年 WZB. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *sourceLab;


@end

@implementation HeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.userName addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userNameEdit)]];
    [self.descLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(desEdit)]];
}
- (void)desEdit {
    if (self.desLabBlock) {
        self.desLabBlock();
    }
}
- (void)userNameEdit {
    if (self.userNameBlock) {
        self.userNameBlock();
    }
}
+ (instancetype)headerView:(CGRect)frame userModel:(CYUserModel *)model {
    
    // 初始化headerView
    HeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil].firstObject;
    headerView.backgroundColor = [UIColor clearColor];
    headerView.frame = frame;
    return headerView;
}

- (void)setModel:(CYUserModel *)model {
    _model = model;
    
    self.userName.text = model.username;
    self.sourceLab.text = [NSString stringWithFormat:@"来自 %@ 用户",model.way];
    self.descLab.text = model.aboutme.length > 1 ? model.aboutme : @"宝宝还未填写";
}

@end
