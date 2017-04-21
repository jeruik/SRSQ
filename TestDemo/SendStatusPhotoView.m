//
//  SendStatusPhotoView.m
//  0001-微博-框架搭建
//
//  Created by 蔡凌云 on 15-6-27.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import "SendStatusPhotoView.h"

@interface SendStatusPhotoView ()

@property (nonatomic, assign) NSInteger row;

@end

@implementation SendStatusPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _photos = [NSMutableArray array];
        
        int maxCol = 4;
        CGFloat imageMargin = 10;
        CGFloat imageWH = (self.width - (maxCol+1) * imageMargin)/maxCol;
        _addBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addPhotoBtn"]];
        _addBtn.userInteractionEnabled = YES;
        [_addBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImageViewClick:)]];
        _addBtn.frame = FRAME(10, 10, imageWH, imageWH);
        [self addSubview:self.addBtn];
    }
    return self;
}
- (void)addPhoto:(UIImage *)photo tag:(NSInteger)tag
{
    [self.addBtn removeFromSuperview];
    UIImageView *photoView = [[UIImageView alloc] init];
    photoView.contentMode = UIViewContentModeScaleAspectFill;
    photoView.clipsToBounds = YES;
    photoView.tag = tag;
    photoView.image = photo;
    photoView.userInteractionEnabled = YES;
    [photoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]];
    [self addSubview:photoView];
    [self addSubview:self.addBtn];
    
    //存储照片
    [self.photos addObject:photo];
    if (self.subviews.count > 0 && self.subviews.count <= 4) {
        !_subViewChangeBlock ? : _subViewChangeBlock(1);
    } else if (self.subviews.count > 4 && self.subviews.count < 9) {
        !_subViewChangeBlock ? : _subViewChangeBlock(2);
    } else {
        !_subViewChangeBlock ? : _subViewChangeBlock(3);
    }
}
- (void)imageClick:(UITapGestureRecognizer *)tap {
    
    UIImageView *imageView = (UIImageView *)tap.view;
    !_imageViewClickBlock ? : _imageViewClickBlock(imageView);
}
- (void)addImageViewClick:(UITapGestureRecognizer *)tap {
    !_addBtnClickBlock ? : _addBtnClickBlock();
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    
    int maxCol = 4;
    CGFloat imageMargin = 10;
    CGFloat imageWH = (self.width - (maxCol+1) * imageMargin)/maxCol;
    
    for (int i = 0 ; i < count; i ++) {
        UIImageView *photoView = self.subviews[i];
        
        int col = i % maxCol;
        int row = i / maxCol;
        
        _row = row;
        
        photoView.x = col * (imageWH + imageMargin) + imageMargin;
        photoView.y = row * (imageWH + imageMargin) + imageMargin;
        
        photoView.width = imageWH;
        photoView.height = imageWH;
    }
}

- (void)drawRect:(CGRect)rect {
    
}

@end
