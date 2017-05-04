//
//  CatZanButton.m
//  Cinderella
//
//  Created by nimingM on 16/1/31.
//  Copyright © 2016年 Dantou. All rights reserved.
//

#import "CatZanButton.h"

#define screen [UIScreen mainScreen].bounds

@interface CatZanButton (){
    UIImageView *_zanImageView;
    CAEmitterLayer *_effectLayer;
    CAEmitterCell *_effectCell;
}
@property (nonatomic, strong) UIImage *zanImage;
@property (nonatomic, strong) UIImage *unZanImage;
@end

@implementation CatZanButton

-(instancetype)init{
    self=[super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, 30, 30)];
        _zanImage=[[UIImage imageNamed:@"post-like-button-new-high"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _unZanImage=[[UIImage imageNamed:@"post-unlike-button-new-high"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _type=CatZanButtonTypeFirework;
        [self initBaseLayout];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _zanImage=[[UIImage imageNamed:@"post-like-button-new-high"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _unZanImage=[[UIImage imageNamed:@"post-unlike-button-new-high"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _type=CatZanButtonTypeFirework;
        [self initBaseLayout];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame zanImage:(UIImage *)zanImage unZanImage:(UIImage *)unZanIamge{
    self=[super initWithFrame:frame];
    if (self) {
        _zanImage=zanImage;
        _unZanImage=unZanIamge;
        _type=CatZanButtonTypeFirework;
        [self initBaseLayout];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    _zanImage=[[UIImage imageNamed:@"post-like-button-new"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _unZanImage=[[UIImage imageNamed:@"post-unlike-button-new"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _type=CatZanButtonTypeFirework;
    [self initBaseLayout];
}

-(void)initBaseLayout{
    _isZan=NO;
    
    switch (_type) {
        case CatZanButtonTypeFirework:{
            _effectLayer=[CAEmitterLayer layer];
            [_effectLayer setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
            [self.layer addSublayer:_effectLayer];
            [_effectLayer setEmitterShape:kCAEmitterLayerCircle];
            [_effectLayer setEmitterMode:kCAEmitterLayerOutline];
            [_effectLayer setEmitterPosition:CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2)];
            [_effectLayer setEmitterSize:CGSizeMake((self.width)*2, (self.width)*2)];
            
            _effectCell=[CAEmitterCell emitterCell];
            [_effectCell setName:@"zanShape"];
            [_effectCell setContents:(__bridge id)[UIImage imageNamed:@"like_user_header"].CGImage];
            [_effectCell setAlphaSpeed:-1.0f];
            [_effectCell setLifetime:1.0f];
            [_effectCell setBirthRate:0];
            [_effectCell setVelocity:50];
            [_effectCell setVelocityRange:200];
            
            [_effectLayer setEmitterCells:@[_effectCell]];
            
            _zanImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
            [_zanImageView setImage:_unZanImage];  
            [_zanImageView setUserInteractionEnabled:YES];
            [self addSubview:_zanImageView];
            
            UITapGestureRecognizer *tapImageViewGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zanAnimationPlay)];
            [_zanImageView addGestureRecognizer:tapImageViewGesture];
        }
            break;
        case CatZanButtonTypeFocus:{
            
        }
            break;
        default:
            break;
    }
}

-(void)zanAnimationPlay{
    [self setIsZan:!self.isZan];

    CGRect frame = [self convertRect:self.frame toView:[AppDelegate appDelegate].window];
    
    switch (_type) {
        case CatZanButtonTypeFirework:{
            [_zanImageView setBounds:CGRectMake(frame.origin.x, frame.origin.y, 0, 0)];
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [_zanImageView setBounds:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
                if (self.isZan) {
                    CABasicAnimation *effectLayerAnimation=[CABasicAnimation animationWithKeyPath:@"emitterCells.zanShape.birthRate"];
                    [effectLayerAnimation setFromValue:[NSNumber numberWithFloat:100]];
                    [effectLayerAnimation setToValue:[NSNumber numberWithFloat:0]];
                    [effectLayerAnimation setDuration:0.0f];
                    [effectLayerAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
                    [_effectLayer addAnimation:effectLayerAnimation forKey:@"ZanCount"];
                }
            } completion:^(BOOL finished) {
                if (self.clickHandler!=nil) {
                    self.clickHandler(self);
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Property method
-(void)setIsZan:(BOOL)isZan{
    _isZan=isZan;
    if (isZan) {
        [_zanImageView setImage:_zanImage];
    }else{
        [_zanImageView setImage:_unZanImage];
    }
}

@end
