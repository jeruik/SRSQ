//
//  DTTextView.h
//  Cinderella
//
//  Created by mac on 15/5/30.
//  Copyright (c) 2015年 cloudstruct. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTTextView : UITextView
@property(nonatomic, assign) BOOL noScroll;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderTextColor;
@property (nonatomic, strong) UILabel *counterLabel;

- (id)initWithFrame:(CGRect)frame andFontSize:(CGFloat)fontSize;
@end
