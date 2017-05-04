//
//  UIStoryboard+StoryBoardHelper.h
//  自定义tabBar
//
//  Created by nimingM on 16/5/22.
//  Copyright © 2016年 蔡凌云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (StoryBoardHelper)
+ (UIViewController *)instantiateInitialViewControllerWithName:(NSString *)storyBoardName;

@end
