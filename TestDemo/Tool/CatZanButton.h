//
//  CatZanButton.h
//  Cinderella
//
//  Created by nimingM on 16/1/31.
//  Copyright © 2016年 Dantou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CatZanButtonType) {
    CatZanButtonTypeFirework,
    CatZanButtonTypeFocus
};

@interface CatZanButton : UIButton

@property (nonatomic) BOOL isZan;
@property (nonatomic) CatZanButtonType type;
@property (nonatomic, copy) void (^clickHandler)(CatZanButton *zanButton);

-(instancetype)initWithFrame:(CGRect)frame zanImage:(UIImage *)zanImage unZanImage:(UIImage *)unZanIamge;

@end
