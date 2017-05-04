//
//  MJPhotoBrowser.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <UIKit/UIKit.h>
#import "MJPhoto.h"
#import "MJPhotoToolbar.h"
//#import "HtmlMedia.h"
//#import "BaseViewController.h"

@protocol MJPhotoBrowserDelegate;
@interface MJPhotoBrowser : NSObject <UIScrollViewDelegate>
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;
// 保存按钮
@property (nonatomic, assign) NSUInteger showSaveBtn;

@property (strong, nonatomic) MJPhotoToolbar *toolbar;
@property (strong, nonatomic) UIView *view;
- (void)updateTollbarState;

// 显示
- (void)show;
//+ (void)showHtmlMediaItems:(NSArray *)items originalItem:(HtmlMediaItem *)curItem;
@end
