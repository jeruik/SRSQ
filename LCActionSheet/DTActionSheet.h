//
//  DTActionSheet.h
//  Cinderella
//
//  Created by mac on 15/7/14.
//  Copyright (c) 2015年 Dantou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DTActionSheetBlock)(NSUInteger clickedIndex);

@interface DTActionSheet : UIView

/**
 *  返回一个 ActionSheet 对象, 类方法
 *
 *  @param title 提示标题
 *
 *  @param titles 所有按钮的标题
 *
 *  @param redButtonIndex 红色按钮的index
 *
 *  @param delegate 代理
 *
 *  Tip: 如果没有红色按钮, redButtonIndex 给 `-1` 即可
 */
+ (instancetype)sheetWithTitle:(NSString *)title
                  buttonTitles:(NSArray *)titles
                redButtonIndex:(NSInteger)buttonIndex
                      callback:(DTActionSheetBlock)callback;

/**
 *  返回一个 ActionSheet 对象, 实例方法
 *
 *  @param title 提示标题
 *
 *  @param titles 所有按钮的标题
 *
 *  @param redButtonIndex 红色按钮的index
 *
 *  @param delegate 代理
 *
 *  Tip: 如果没有红色按钮, redButtonIndex 给 `-1` 即可
 */
- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)titles
               redButtonIndex:(NSInteger)buttonIndex
                     callback:(DTActionSheetBlock)callback;

- (void)showInWindow;
/**
 *  显示 ActionSheet
 */
- (void)showInSuperView:(UIView*)view;

@end
