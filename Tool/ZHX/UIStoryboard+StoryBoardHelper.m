
//
//  UIStoryboard+StoryBoardHelper.m
//  自定义tabBar
//
//  Created by nimingM on 16/5/22.
//  Copyright © 2016年 蔡凌云. All rights reserved.
//

#import "UIStoryboard+StoryBoardHelper.h"

@implementation UIStoryboard (StoryBoardHelper)
+ (UIViewController *)instantiateInitialViewControllerWithName:(NSString *)storyBoardName{
    UIStoryboard *story = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    return (UIViewController *)[story instantiateInitialViewController];
}
@end
