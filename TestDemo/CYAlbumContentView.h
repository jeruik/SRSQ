//
//  CYAlbumContentView.h
//  Junengwan
//
//  Created by 小菜 on 16/7/18.
//  Copyright © 2016年 上海触影文化传播有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYAlbumContentView : UIView

typedef NS_ENUM(NSUInteger,CYAlbumContentViewType) {
    CYAlbumContentViewTypeAlbum = 0,
    CYAlbumContentViewTypePhoto,
    CYAlbumContentViewTypeMeituAlbum
};

@property (nonatomic, copy) void (^imgClickBlock)(NSInteger index,UIImageView *img);

@property (nonatomic, assign) NSInteger count;

@end
