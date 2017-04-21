//
//  CYBackMessageCell.m
//  TestDemo
//
//  Created by 小菜 on 17/1/26.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "CYBackMessageCell.h"

@interface CYBackMessageCell ()

@property (nonatomic, strong) RCTipLabel *lab;

@end

@implementation CYBackMessageCell

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight {
    
    return CGSizeMake(collectionViewWidth, 40 + (model.isDisplayMessageTime ? 20 : 0));
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    RCTipLabel *lab = [RCTipLabel greyTipLabel];
    [self.baseContentView addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.equalTo(self.baseContentView.mas_centerX);
        
    }];
    _lab = lab;
}
- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    self.lab.text = model.messageDirection == MessageDirection_SEND ? @"你撤回了一条消息" : @"他撤回了一条消息";
    
}
@end

