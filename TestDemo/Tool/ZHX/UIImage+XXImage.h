//
//  UIImage+XXImage.h
//  自定义tabBar
//
//  Created by nimingM on 16/5/21.
//  Copyright © 2016年 蔡凌云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XXImage)
+ (instancetype)imageWithOriRenderImage:(NSString *)imageName;
+ (instancetype)imageWithStretchableImageName:(NSString *)imageName;
@end
