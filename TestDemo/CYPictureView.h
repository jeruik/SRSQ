//
//  CYPictureView.h
//  Junengwan
//
//  Created by 小菜 on 16/9/19.
//  Copyright © 2016年 ‰∏äÊµ∑Ëß¶ÂΩ±ÊñáÂåñ‰º†Êí≠ÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYPictureView : UICollectionView

@property (nonatomic, strong) NSArray *picModel;
@property (nonatomic, strong) NSArray *bigImageArray;
- (void)setupPhotoViewLayout:(CGSize)layoutSize;
@end

@interface CYPictureViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageV;
@end
