//
//  CertifyCollectionViewCell.m
//  Cinderella
//
//  Created by mac on 15/7/21.
//  Copyright (c) 2015年 Dantou. All rights reserved.
//

#import "CertifyCollectionViewCell.h"
#import "UIColor+Hex.h"

@implementation CertifyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.iconView = [[UIImageView alloc] initWithFrame:self.bounds];
    
        self.iconView.contentMode = 0;
        [self.contentView addSubview:self.iconView];
        self.backgroundColor = [UIColor clearColor];
        
        UIButton *btn = [UIButton buttonWithTitle:nil target:self action:@selector(delectIcon) height:0];
        [btn setImage:[UIImage imageNamed:@"del-photo"] forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        self.delectBtn = btn;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.delectBtn.frame = FRAME(self.contentView.bounds.size.width - 44, 0, 44, 44);
}
- (void)delectIcon {
    if (self.delectBlock) {
        self.delectBlock(self.index);
    }
}
@end
