//
//  CYAlbumContentView.m
//  Junengwan
//
//  Created by 小菜 on 16/7/18.
//  Copyright © 2016年 上海触影文化传播有限公司. All rights reserved.
//

#import "CYAlbumContentView.h"

@implementation CYAlbumContentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}
- (void)iconClick:(UITapGestureRecognizer *)gesture {
    NSInteger index =  gesture.view.tag-1000;
    UIImageView *img = (UIImageView *)gesture.view;
    if (self.imgClickBlock) {
        self.imgClickBlock(index,img);
    }
}
- (void)setCount:(NSInteger)count {
    
    NSArray * dataImage = @[@"personal_photo",@"personal_album",@"personal_mtphoto"];
    NSArray * dataStr = @[@"相机",@"图库",@"美人相机"];
    float X = 0;
    float W = 50;
    float imgH = 50;
    float labH = 20;
    float row3 = (309*CDRWidthScale - 150) / 4;
    float row2 = (309*CDRWidthScale - 100) / 3;
    for (int i =0; i< count; i++) {
        if (count == 2) {
            X = row2 + (50+row2)*i;
        }
        else if(count == 3){
            X = row3 + (50+row3)*i;
        }
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:FRAME(X, 100 , W, imgH)];
        img.centerY = self.centerY -15;
        img.tag = i + 1000;
        img.image =[UIImage imageNamed:dataImage[i]];
        img.userInteractionEnabled = YES;
        [img addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick:)]];
        [self addSubview:img];
        UILabel *labTitle = [[UILabel alloc]initWithFrame:FRAME(X, img.bottom +10, W, labH)];
        labTitle.text = dataStr[i];
        labTitle.font = [UIFont systemFontOfSize:12];
        labTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:labTitle];

    }

}

@end
