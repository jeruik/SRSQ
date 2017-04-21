//
//  CertifyCollectionViewCell.h
//  Cinderella
//
//  Created by mac on 15/7/21.
//  Copyright (c) 2015年 Dantou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CertifyCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) void(^delectBlock)(NSInteger index);

@property(nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIButton *delectBtn;

@property (nonatomic, assign) NSInteger index;

@end
