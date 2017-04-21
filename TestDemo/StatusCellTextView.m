//
//  StatusCellTextView.m
//  小菜微博
//
//  Created by 蔡凌云 on 15-7-5.
//  Copyright (c) 2015年 com.mading.cn. All rights reserved.
//

#import "StatusCellTextView.h"
#import "Special.h"

#define StatusTextViewCoverTag 999

@interface StatusCellTextView ()
@property (nonatomic, assign) NSInteger index;
@end

@implementation StatusCellTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.editable = NO;  //不能编辑
        self.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
        self.scrollEnabled = NO;  //禁止滚动
    }
    return self;
}
//添加特殊文字所在矩形框  //初始化矩形框
- (void)setupSpecialRects
{
    //通过@"specials" 这个key 取出特殊文字集合
    NSArray *specials = [self.attributedText attribute:@"specials" atIndex:0 effectiveRange:NULL];
    
    for (Special *speica in specials) {
        // self.selectedRange --影响--> self.selectedTextRange
        self.selectedRange = speica.range;  //选中特殊文字的位置
        
        //获得选中的矩形框
        NSArray *selectRects = [self selectionRectsForRange:self.selectedTextRange];
        
        //清空选中范围
        self.selectedRange = NSMakeRange(0, 0);
        
        NSMutableArray *rects = [NSMutableArray array];
        for (UITextSelectionRect *selectionRext in selectRects) {
            CGRect rect = selectionRext.rect;
            
            if (rect.size.width == 0 || rect.size.height == 0) continue;  //遇到空格直接跳过
            
            //添加到rect
            [rects addObject:[NSValue valueWithCGRect:rect]];
        }
        speica.rects = rects;
    }
}
// 找出被触摸的特殊字符串
- (Special *)touchingSpecialWithPoint:(CGPoint)point
{
    //通过@"specials" 这个key 取出特殊文字集合
    NSArray *specials = [self.attributedText attribute:@"specials" atIndex:0 effectiveRange:NULL];
    for (Special *special in specials) {
        for (NSValue *rectValue in special.rects) {
            if (CGRectContainsPoint(rectValue.CGRectValue, point)) { // 点中了某个特殊字符串
                return special;
            }
        }
    }
    return nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //获得触摸对象
    UITouch *touch = [touches anyObject];
    
    //触摸点
    CGPoint point = [touch locationInView:self];  //触摸点在StatusCellTextView的位置
    
    //初始化矩形框
    [self setupSpecialRects];
    
    //根据触摸点获得被触摸的字符串
    Special *sp = [self touchingSpecialWithPoint:point];
    
    for (NSValue *rectValue in sp.rects) {  //遍历数组矩形框
        
        //加背景
        UIView *cover = [[UIView alloc] init];
        cover.backgroundColor = [UIColor lightTextColor];
        cover.frame = rectValue.CGRectValue;
        cover.tag = StatusTextViewCoverTag;
        cover.layer.cornerRadius = 3;
        [self insertSubview:cover atIndex:0];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self touchesCancelled:touches withEvent:event];
    });
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView *child in self.subviews) {
        if (child.tag == StatusTextViewCoverTag) {
            [child removeFromSuperview];
        }
    }
}

// 告诉系统:触摸点point是否在这个UI控件身上
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    //初始化矩形框
    [self setupSpecialRects];
    // 根据触摸点获得被触摸的特殊字符串
    Special *sp = [self touchingSpecialWithPoint:point];
    if (sp) {
        NSLog(@"%@",sp.text);
        self.index ++;
        if (self.index == 2) {
            if ([sp.text containsString:@"http://"] || [sp.text containsString:@"https://"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:SQUrlClick object:sp.text];
                self.index = 0;
            }
        }
        return YES;
    } else {
        return NO;
    }
}

@end
