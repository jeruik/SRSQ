//
//  SendStatusToolbar.h
//  0001-微博-框架搭建
//
//  Created by 蔡凌云 on 15-6-27.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SendStatusToolbarButtonTypeCamera, // 拍照
    SendStatusToolbarButtonTypePicture, // 相册
    SendStatusToolbarButtonTypeMention, // @
    SendStatusToolbarButtonTypeTrend, // #
    SendStatusoolbarButtonTypeEmotion // 表情
}SendStatusToolbarButtonType;

@class SendStatusToolbar;

@protocol  SendStatusToolbarDelegate <NSObject>

@optional

- (void)sendStatusToolbar:(SendStatusToolbar *)toolbar didclickButton:(SendStatusToolbarButtonType)buttonType;

@end

@interface SendStatusToolbar : UIView

@property (nonatomic, weak) id <SendStatusToolbarDelegate> delegate;

@property (nonatomic, assign) BOOL showKeyboardButton;

@end
