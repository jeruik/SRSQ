//
//  CYMessageCell.m
//  TestDemo
//
//  Created by 小菜 on 17/1/26.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "CYMessageCell.h"
#import "CYMoneyMessage.h"

#import "CYConnecViewController.h"

@interface CYMessageCell ()

@property (nonatomic, assign) CGSize defaultSize;
@property (nonatomic, weak) UILabel *descLabel;
@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UILabel *amountLabel;

@property (nonatomic, assign) CGSize moneySize;

@end

@implementation CYMessageCell

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _defaultSize = CGSizeMake(200, 90);
        [self setup];
    }
    return self;
}
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight {
    CGFloat h = 130 + (model.isDisplayNickname ? 20 : 0);
    return CGSizeMake(collectionViewWidth, h);
}
- (void)setup {
    
    WEAKSELF
    [self.messageContentView setEventBlock:^(CGRect rect) {
        CGSize s = rect.size;
        if (!(s.width == weakSelf.defaultSize.width && s.height == weakSelf.defaultSize.height)) {
            return ;
        }
        if (!weakSelf.model) {
            return;
        }
        
        BOOL isoutgoing = weakSelf.model.messageDirection == MessageDirection_SEND;
        CGRect newRect = CGRectMake(isoutgoing ? 0 : 5, 0, rect.size.width-5, rect.size.height);
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:4];
        [path moveToPoint:CGPointMake(isoutgoing ? rect.size.width - 5 : 5, 10)];
        [path addLineToPoint:CGPointMake(isoutgoing ? rect.size.width : 0, 14)];
        [path addLineToPoint:CGPointMake(isoutgoing ? rect.size.width - 5 : 5, 18)];
        
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.path = path.CGPath;
        weakSelf.messageContentView.layer.mask = layer;
    }];
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView = bottomView;
    
    UILabel *desLab = [UILabel new];
    desLab.font = [UIFont systemFontOfSize:12];
    desLab.textColor = [UIColor darkGrayColor];
    desLab.textAlignment = NSTextAlignmentLeft;
    self.descLabel = desLab;
    [bottomView addSubview:desLab];
    
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(10);
    }];
    
    [self.messageContentView addSubview:self.bottomView];
    
    UILabel *amountLabel = [UILabel new];
    amountLabel.font = [UIFont systemFontOfSize:12];
    amountLabel.textColor = [UIColor darkGrayColor];
    amountLabel.textAlignment = NSTextAlignmentLeft;
    self.amountLabel = amountLabel;
    
    [self.messageContentView addSubview:amountLabel];
    self.messageContentView.backgroundColor = [UIColor orangeColor];
    [self.messageContentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMessageContentView:)]];
}
- (void)onTapMessageContentView:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        [_conViewController didTapMessageCell:self.model];
    }
}
- (void)updateConstraints {
    BOOL isOutgoing = self.model.messageDirection == MessageDirection_SEND;
    CGSize dsize = CGSizeMake(self.defaultSize.width - 5, 34);
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(dsize);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(isOutgoing ? 0 : 5);
    }];
    
    [self.amountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(isOutgoing ? 10 : 15);
    }];
    
    [super updateConstraints];
      CGSizeMake(self.messageContentView.width, self.messageContentView.bottom);
}
- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    CGRect frame = self.messageContentView.frame;
    frame.size = self.defaultSize;
    self.messageContentView.frame = frame;
    
    CYMoneyMessage *m = (CYMoneyMessage *)model.content;
    self.descLabel.text = m.desc;
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    
    [nf setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
    nf.numberStyle = NSNumberFormatterCurrencyStyle;
    nf.minimumFractionDigits = 2;
    
    self.amountLabel.text = [nf stringFromNumber:@(m.amount)];
    
}







































@end
