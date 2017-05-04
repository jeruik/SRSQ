//
//  DTCheckBoxView.m
//  Cinderella
//
//  Created by mac on 15/6/4.
//  Copyright (c) 2015年 cloudstruct. All rights reserved.
//

#import "DTCheckBoxView.h"
#import "UIColor+Hex.h"
#import "DTCheckBox.h"

static const CGFloat kBorderPadding = 10.0f;
static const CGFloat kBorderWidth = 0.5f;

@interface DTCheckBoxView () <DTcheckBoxDelegate> {
    CGFloat _rowHeight, _boxWidth;
    NSInteger _columns, _rows, _maxCheckable;
    NSMutableArray *_selected_tags;
}
@property(nonatomic, strong) UIScrollView *scroller;
//@property(nonatomic, strong)NSMutableArray *boxs;
@end

@implementation DTCheckBoxView

- (id)initWithFrame:(CGRect)frame dataSource:(id <DTCheckBoxViewDataSource>)dataSource {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat rowHeight = [dataSource heightOfRowInCheckBox:self];
        NSInteger rows = [dataSource numberOfRowsInCheckBox:self];
        CGFloat contentHeight = rowHeight * rows + kBorderWidth * (rows + 1);
        self.scroller = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scroller.contentSize = CGSizeMake(frame.size.width, contentHeight);
        [self addSubview:self.scroller];
        self.dataSource = dataSource;
        _rowHeight = rowHeight;
        _rows = rows;
        _columns = [dataSource numberOfColumnsInCheckBox:self];
        _boxWidth = (frame.size.width - kBorderWidth * (_columns - 1)) / _columns;
        _maxCheckable = [dataSource maxCheckableInCheckBox:self];
        _selected_tags = [[NSMutableArray alloc] initWithCapacity:_maxCheckable];

        CGFloat y = 0;
        [self drawRowBorderWithPadding:kBorderPadding positionY:y atView:self.scroller];
        y += kBorderWidth;
        for (int i = 0; i < _rows; i++) {
            if (i > 0) {
                [self drawRowBorderWithPadding:kBorderPadding positionY:y atView:self.scroller];
                y += kBorderWidth;
            }
            [self loadRow:i atPositionY:y];
            y += _rowHeight;
        }
        [self drawRowBorderWithPadding:kBorderPadding positionY:y atView:self.scroller];
    }
    return self;
}

- (void)loadRow:(NSInteger)row atPositionY:(CGFloat)y {
    CGFloat x = 0;
    for (int i = 0; i < _columns; i++) {
        if (i > 0) {
            [self drawColumnBorderWithPadding:kBorderPadding origin:CGPointMake(x, y)];
            x += kBorderWidth;
        }
        [self loadBoxAtRow:row column:i atOrigin:CGPointMake(x, y)];
        x += _boxWidth;
    }
}

- (void)loadBoxAtRow:(NSInteger)row column:(NSInteger)column atOrigin:(CGPoint)origin {
    NSString *title = [_dataSource checkBox:self titleAtRow:row column:column];
    DTCheckBox *box = [[DTCheckBox alloc] initWithFrame:CGRectMake(origin.x, origin.y, _boxWidth, _rowHeight) andTitle:title];
    box.row = row;
    box.column = column;
    box.delegate = self;
    box.tag = 100 + row * _columns + column;
    [self.scroller addSubview:box];
}

- (void)drawRowBorderWithPadding:(CGFloat)padding positionY:(CGFloat)y atView:(UIView *)view {
    CALayer *border = [CALayer layer];
    CGFloat width = CDRViewWidth - padding * 2;
    border.frame = CGRectMake(padding, y, width, kBorderWidth);
    border.backgroundColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
    [view.layer addSublayer:border];
}

- (void)drawColumnBorderWithPadding:(CGFloat)padding origin:(CGPoint)origin {
    CALayer *border = [CALayer layer];
    CGFloat height = _rowHeight - padding * 2;
    border.frame = CGRectMake(origin.x, origin.y + padding, kBorderWidth, height);
    border.backgroundColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
    [self.scroller.layer addSublayer:border];
}

- (BOOL)isFull {
    return [_selected_tags count] >= _maxCheckable;
}

- (void)selectBoxAtRow:(NSInteger)row column:(NSInteger)column {
    if (![self isFull]) {
        DTCheckBox *box = (DTCheckBox *) [self viewWithTag:(100 + row * _columns + column)];
        if (box != nil && box.titleLabel.text != nil && ![box isSelected]) {
            [box setSelected:YES];
            [_selected_tags addObject:@(box.tag)];
        }
    }
}

- (void)unSelectBoxAtRow:(NSInteger)row column:(NSInteger)column {
    DTCheckBox *box = (DTCheckBox *) [self viewWithTag:(100 + row * _columns + column)];
    if (box != nil && box.titleLabel.text != nil && [box isSelected]) {
        [box setSelected:NO];
        [_selected_tags removeObject:@(box.tag)];
    }
}

#pragma mark - DTCheckBox Delegate

- (void)tapedBox:(DTCheckBox *)checkBox {
    if (checkBox.titleLabel.text == nil) {
        return;
    }
    if ([checkBox isSelected]) {
        [_selected_tags removeObject:@(checkBox.tag)];
        [checkBox setSelected:NO];
        if ([_delegate respondsToSelector:@selector(checkBox:didUnSelectedAtRow:andColumn:)]) {
            [_delegate checkBox:self didUnSelectedAtRow:checkBox.row andColumn:checkBox.column];
        }
    } else {
        if (![self isFull]) {
            [_selected_tags addObject:@(checkBox.tag)];
            [checkBox setSelected:YES];
            if ([_delegate respondsToSelector:@selector(checkBox:didSelectedAtRow:andColumn:)]) {
                [_delegate checkBox:self didSelectedAtRow:checkBox.row andColumn:checkBox.column];
            }
        } else if (_maxCheckable == 1) {
            DTCheckBox *selectedBox = (DTCheckBox *) [self viewWithTag:[_selected_tags[0] integerValue]];
            [selectedBox setSelected:NO];
            [checkBox setSelected:YES];
            _selected_tags[0] = @(checkBox.tag);
            if ([_delegate respondsToSelector:@selector(checkBox:didSelectedAtRow:andColumn:)]) {
                [_delegate checkBox:self didSelectedAtRow:checkBox.row andColumn:checkBox.column];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"最多只可选择%ld个选项", (long)_maxCheckable] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alert show];
        }
    }
}

@end
