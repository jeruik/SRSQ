//
//  DTCheckBox.m
//  Cinderella
//
//  Created by mac on 15/6/4.
//  Copyright (c) 2015年 cloudstruct. All rights reserved.
//

#import "DTCheckBox.h"
#import "UIColor+Hex.h"
#define COLOR_APP_THEME_RED                 @"ff524e"
#define COLOR_CHECK_BOX_HIGHLIGHT_TEXT      @"ffffff"
#define COLOR_CHECK_BOX_TITLE               @"#6B696B"
static const CGFloat kCheckImagePadding = 2;

@interface DTCheckBox () {
    BOOL _selected;
}
@property(nonatomic, strong) UIImageView *checkImageView;
@end

@implementation DTCheckBox

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel.text = title;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 1;
        [self addSubview:self.titleLabel];

        UIImage *image = [UIImage imageNamed:@"cell-selected"];
        self.checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - image.size.width - kCheckImagePadding, kCheckImagePadding, image.size.width, image.size.height)];
        [self.checkImageView setImage:image];
        [self insertSubview:self.checkImageView aboveSubview:self.titleLabel];
        [self setSelected:NO];

        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInBox)];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (selected) {
        self.backgroundColor = [UIColor colorWithHexString:COLOR_APP_THEME_RED];
        self.titleLabel.textColor = [UIColor colorWithHexString:COLOR_CHECK_BOX_HIGHLIGHT_TEXT];
        [self.checkImageView setHidden:NO];
    } else {
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor colorWithHexString:COLOR_CHECK_BOX_TITLE];
        [self.checkImageView setHidden:YES];
    }
}

- (BOOL)isSelected {
    return _selected;
}

- (void)toggleBox {
    [self setSelected:!_selected];
}

- (void)tapInBox {
    if ([self.delegate respondsToSelector:@selector(tapedBox:)]) {
        [self.delegate tapedBox:self];
    }
}

@end
