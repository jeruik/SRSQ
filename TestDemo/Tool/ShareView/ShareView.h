//
//  ShareView.h
//  Cinderella
//
//  Created by ng on 15/9/7.
//  Copyright (c) 2015年 Dantou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShareView;

@protocol ShareViewDelegate <NSObject>

@optional

- (void)shareViewDidRemoveFromSuperView;


@end

@interface ShareView : UIView<UIAlertViewDelegate>

/**
 *  cancelBtn
 */
@property (strong, nonatomic) UIButton *cancel;
/**
 *  lineView
 */
@property (strong, nonatomic) UIView *lineView;

/**
 *  sinaBtn
 */
@property (strong, nonatomic) UIButton *sinaBtn;

/**
 *  wechaFriendBtn
 */
@property (strong, nonatomic) UIButton *weChatFriendBtn;

/**
 *  timeLine
 */
@property (strong, nonatomic) UIButton *timeLine;

/**
 *  bgView
 */
@property (strong, nonatomic) UIView *bgView;


/**
 *  coverView
 */
@property (strong, nonatomic) UIView *coverView;

/**
 *  titleLabel
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  显示
 */
- (void)showShareView:(id)params successBlock:(void(^)())success;

- (void)showShareInavitationView:(id)params successBlock:(void(^)())success;
/**
 *  隐藏
 */
- (void)hiddenShareView;
/**
 *  delegate
 */
@property(nonatomic,weak)id<ShareViewDelegate>delegate;

/**
 *  shareContents
 */
@property (strong, nonatomic) NSDictionary *shareContents;

/**
 *  success
 */
@property(nonatomic,copy) void(^success)();

@end
