//
//  ScreenLayoutAdapter.h
//  微信朋友圈
//
//  Created by 刘森 on 16/3/7.
//  Copyright © 2016年 刘森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ScreenLayoutAdapter : NSObject

+ (CGFloat)changeScreenLayoutRefer:(CGFloat)referFloat
                    referWithHeight:(CGFloat)referToHeight
                       ScreenHeight:(CGFloat)ScreenHeight;


@end
