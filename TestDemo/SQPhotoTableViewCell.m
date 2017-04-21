//
//  SQPhotoTableViewCell.m
//  TestDemo
//
//  Created by 小菜 on 17/2/6.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "SQPhotoTableViewCell.h"
#import "CertifyCollectionViewCell.h"
#import "YYPhotoGroupView.h"

@interface SQPhotoTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_photoCollection;
}

@end

@implementation SQPhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _photoCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 0, CDRViewWidth-10, 3*VIEW_WIDTH + 2 *VIEW_MARGIN) collectionViewLayout:flowLayout];
    [_photoCollection registerClass:[CertifyCollectionViewCell class] forCellWithReuseIdentifier:@"CertifyCollectionViewCell"];
    _photoCollection.delegate = self;
    _photoCollection.dataSource = self;
    _photoCollection.backgroundColor = [UIColor whiteColor];
    _photoCollection.scrollEnabled = NO;
    _photoCollection.pagingEnabled = NO;
    _photoCollection.showsHorizontalScrollIndicator = NO;
    _photoCollection.showsVerticalScrollIndicator = NO;
    _photoCollection.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [self.contentView addSubview:_photoCollection];
}
- (void)setIsSelf:(BOOL)isSelf {
    _isSelf = isSelf;
}
- (void)setPhotosArray:(NSArray *)photosArray {
    _photosArray = photosArray;
    if (_isSelf) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:photosArray];
        [arr insertObject:@"" atIndex:0];
        _photosArray = [NSArray arrayWithArray:arr];
    }
    [_photoCollection reloadData];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  _photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"CertifyCollectionViewCell";
    CertifyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.index = indexPath.item;
    NSString *post = [_photosArray objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        cell.delectBtn.hidden = YES;
        if (_isSelf) {
            [cell.iconView setImage:[UIImage imageNamed:@"addPhotoBtn"]];
        } else {
            [cell.iconView sd_setImageWithURL:[NSURL URLWithString:post] placeholderImage:[UIImage imageNamed:@"chat-women"]];
        }
    } else {
        cell.delectBtn.hidden = _isSelf ? NO : YES;
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:post] placeholderImage:[UIImage imageNamed:@"chat-women"]];
    }
    WEAKSELF
    cell.delectBlock = ^(NSInteger index){
        if (weakSelf.delectPhotoBlock) {
            weakSelf.delectPhotoBlock(index);
        }
    };
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger count = self.photosArray.count;
    CertifyCollectionViewCell *cell = (CertifyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (_isSelf) {
        if (indexPath.item == 0) {
            if (self.addPhotoBlock) {
                self.addPhotoBlock();
            }
        } else {
            UIImageView *fromView = [[UIImageView alloc] init];
            NSMutableArray *tempPhotos = [NSMutableArray arrayWithArray:self.photosArray];
            [tempPhotos removeFirstObject];
            NSMutableArray *items = [NSMutableArray array];
            for (int i = 0; i < tempPhotos.count; i++) {
                NSString *url = tempPhotos[i];
                YYPhotoGroupItem *item = [[YYPhotoGroupItem alloc] init];
                item.largeImageURLStr = url;
                item.thumbView = [[UIImageView alloc] initWithImage:[[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:url]];
                [items addObject:item];
                if ((indexPath.item-1) == i) {
                    fromView = cell.iconView;
                }
            }
            YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:items];
            [photoView presentFromImageView:fromView toContainer:[AppDelegate appDelegate].window.rootViewController.view fromIndex:indexPath.row-1 animated:YES completion:nil vc:[self findViewControler]];
        }
    } else {

        UIImageView *fromView = [[UIImageView alloc] init];
        NSMutableArray *items = [NSMutableArray array];
        for (int i = 0; i < count; i++) {
            NSString *url = self.photosArray[i];
            YYPhotoGroupItem *item = [[YYPhotoGroupItem alloc] init];
            item.thumbView = [[UIImageView alloc] initWithImage:[[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:url]];
            item.largeImageURLStr = url;
            [items addObject:item];
            if ((indexPath.item) == i) {
                fromView = cell.iconView;
            }
        }
        YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:items];
        [photoView presentFromImageView:fromView toContainer:[AppDelegate appDelegate].window.rootViewController.view fromIndex:indexPath.row animated:YES completion:nil vc:[self findViewControler]];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    layout.minimumLineSpacing = VIEW_MARGIN;
    return CGSizeMake(VIEW_WIDTH, VIEW_WIDTH);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.000f;
}
@end
