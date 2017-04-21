//
//  DTCheckBox.h
//  Cinderella
//
//  Created by mac on 15/6/4.
//  Copyright (c) 2015年 cloudstruct. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTcheckBoxDelegate;

@interface DTCheckBox : UIView
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, weak) id <DTcheckBoxDelegate> delegate;
@property(nonatomic, assign) NSInteger row;
@property(nonatomic, assign) NSInteger column;

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title;

- (BOOL)isSelected;

- (void)setSelected:(BOOL)selected;
@end

@protocol DTcheckBoxDelegate <NSObject>

@optional
- (void)tapedBox:(DTCheckBox *)checkBox;

@end
