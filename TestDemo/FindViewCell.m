
//  FindViewCell.m
//  TestDemo
//
//  Created by dzb on 17/2/5.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "FindViewCell.h"
#import "CYPictureView.h"
#import "FindToolBar.h"
#import "TimeTool.h"
#import "StatusCellTextView.h"
#import "DTShowHudView.h"
@interface FindViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (nonatomic, strong)  StatusCellTextView *contentLabel;
@property (nonatomic, strong) FindToolBar *toolBar;
@property (nonatomic, strong) CYPictureView *pictureView;
@property (nonatomic, assign) CGSize photoSize;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIButton *arrowLab;
@property (weak, nonatomic) IBOutlet UIView *shareView;

@end

@implementation FindViewCell
- (FindToolBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[FindToolBar alloc] initWithFrame:FRAME(0, 0, CDRViewWidth, 50)];
        [self.contentView addSubview:_toolBar];
    }
    return _toolBar;
}
- (CYPictureView *)pictureView {
    if (!_pictureView) {
        _pictureView = [[CYPictureView alloc] init];
        [self.contentView addSubview:_pictureView];
    }
    return _pictureView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerImage.layer.cornerRadius = 4;
    self.headerImage.clipsToBounds = YES;
    self.headerImage.userInteractionEnabled = YES;
    [self.headerImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageClick)]];
    
    /** 正文 */
    StatusCellTextView *contentLabel = [[StatusCellTextView alloc] init];
    contentLabel.font = FONT_SIZE(15);
    contentLabel.textColor = NineColor;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    self.contentLabel.frame = FRAME(10, 70, CDRViewWidth-20, 15);
    
    
    self.arrowLab.transform = CGAffineTransformMakeRotation(AngleRadion(90));
    [self.shareView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareSQ)]];
}
- (void)headerImageClick {
    if (self.headerBlock) {
        self.headerBlock(self.userModel.account);
    }
}
- (void)shareSQ {
    if (self.shareBlock) {
        self.shareBlock(self.userModel);
    }
}
- (void)setUserModel:(FindUserModel *)userModel {
    _userModel = userModel;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:userModel.headimgurl] placeholderImage:[UIImage imageNamed:@"HomeAlertContentView_movie_text"]];
    self.userName.text = userModel.username;
    self.contentLabel.height = self.userModel.contentLabH;
    self.contentLabel.attributedText = userModel.attActcontent;
    self.timeLab.text = userModel.acttime;
    [self.sexImageView setImage:[UIImage imageNamed:userModel.sex.integerValue == 1 ? @"daylogWater_boy" : @"daylogWater_girl"]];
    self.toolBar.userModel = userModel;
    if (self.userModel.thimbimgPhotos.count > 0) {
        self.pictureView.hidden = NO;
        [self.pictureView setupPhotoViewLayout:self.userModel.photoViewLayotSize];
        self.pictureView.frame = FRAME(10, self.contentLabel.bottom + 10, self.userModel.photoViewSize.width,self.userModel.photoViewSize.height);
        self.pictureView.picModel = self.userModel.thimbimgPhotos;
        self.pictureView.bigImageArray = self.userModel.photos;
        self.toolBar.y = self.pictureView.bottom;
        userModel.cellH = self.toolBar.bottom;
    } else {
        self.pictureView.hidden = YES;
        self.toolBar.y = self.contentLabel.bottom;
        userModel.cellH = self.toolBar.bottom;
    }
}
- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 10;
    [super setFrame:frame];
}
@end
