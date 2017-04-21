//
//  UIImage+ImageCut.h
//  Junengwan
//
//  Created by dabing on 15/12/5.
//  Copyright © 2015年 大兵布莱恩特. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIImage (ImageCut)

NS_ASSUME_NONNULL_BEGIN

/**
 *  给图片进行等比例缩放 知道宽度 去计算等比例后的高度
 */
+ (CGSize)getScaleImageFromSize:(CGSize)fromSize width:(CGFloat)fromW;

/**
 *  图片等比例缩放
 */
-(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

/**
 *  将图片裁剪成圆形图片
 *
 */
- (UIImage*)cirleImage;


NS_ASSUME_NONNULL_END

@end

