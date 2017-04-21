//
//  CYUserAlbumView.h
//  Junengwan
//
//  Created by dzb on 16/7/18.
//  Copyright © 2016年 上海触影文化传播有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYUserAlbumView : UIView

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy) void (^btnClickBlock)(NSInteger index,UIImageView *img);
@property (nonatomic, copy) void (^closeBlock)();
- (instancetype)initWithFrame:(CGRect)frame withButtonCount:(NSInteger)count;
@end
