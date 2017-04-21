//
//  CYPictureView.m
//  Junengwan
//
//  Created by 小菜 on 16/9/19.
//  Copyright © 2016年 ‰∏äÊµ∑Ëß¶ÂΩ±ÊñáÂåñ‰º†Êí≠ÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "CYPictureView.h"
#import "FindUserPhotoModel.h"
#import "SDWebImageManager+MJ.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "YYPhotoGroupView.h"

@interface CYPictureView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *picLayout;

@end

@implementation CYPictureView

static NSString *picID = @"CYPictureViewCellID";

- (instancetype)init {
    if (self = [super initWithFrame:CGRectZero collectionViewLayout:self.picLayout]) {
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = UIColor.whiteColor;
        [self registerClass:[CYPictureViewCell class] forCellWithReuseIdentifier:picID];
    }
    return self;
}

- (void)setPicModel:(NSArray *)picModel {
    _picModel = picModel;
    
    [self reloadData];
}
- (void)setupPhotoViewLayout:(CGSize)layoutSize {
    self.picLayout.itemSize = layoutSize;
}
- (UICollectionViewFlowLayout *)picLayout {
    if (!_picLayout) {
        _picLayout = [[UICollectionViewFlowLayout alloc] init];
        _picLayout.minimumInteritemSpacing = 5;
        _picLayout.minimumLineSpacing = 5;
    }
    return _picLayout;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.picModel.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CYPictureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:picID forIndexPath:indexPath];
    NSString *str = self.picModel[indexPath.row];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"chat-women"]];

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = self.picModel.count;
    
    CYPictureViewCell *cell = (CYPictureViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    UIImageView *fromView = [[UIImageView alloc] init];
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        NSString *url = self.picModel[i];
        NSString *bigImageUrl = self.bigImageArray[i];
        YYPhotoGroupItem *item = [[YYPhotoGroupItem alloc] init];
        item.thumbView = [[UIImageView alloc] initWithImage:[[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:url]];
        item.largeImageURLStr = bigImageUrl;
        [items addObject:item];
        if (indexPath.item == i) {
            fromView = cell.imageV;
        }
    }
    YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    [photoView presentFromImageView:fromView toContainer:[AppDelegate appDelegate].window.rootViewController.view fromIndex:indexPath.row animated:YES completion:nil vc:[self findViewControler]];
}
@end

/**
 * 类扩展，迷你cell，需要在.h里面声明
 */

@interface CYPictureViewCell ()

@end

@implementation CYPictureViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageV = [[UIImageView alloc] init];
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imageV];
        self.contentView.clipsToBounds = YES;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageV.frame = self.contentView.bounds;
}

@end
