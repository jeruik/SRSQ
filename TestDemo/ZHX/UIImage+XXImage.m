//
//  UIImage+XXImage.m
//  自定义tabBar
//
//  Created by nimingM on 16/5/21.
//  Copyright © 2016年 蔡凌云. All rights reserved.
//

#import "UIImage+XXImage.h"

@implementation UIImage (XXImage)
+(instancetype)imageWithOriRenderImage:(NSString *)imageName{
    UIImage *img =[UIImage imageNamed:imageName];
    return [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
+ (instancetype)imageWithStretchableImageName:(NSString *)imageName {
    UIImage *image =[UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width *0.5 topCapHeight:image.size.height * 0.5];
}

@end
