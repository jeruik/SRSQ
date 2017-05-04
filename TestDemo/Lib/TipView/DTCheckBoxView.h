//
//  DTCheckBoxView.h
//  Cinderella
//
//  Created by mac on 15/6/4.
//  Copyright (c) 2015年 cloudstruct. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTCheckBoxViewDataSource;
@protocol DTCheckBoxViewDelegate;

@interface DTCheckBoxView : UIView

@property(nonatomic, weak) id <DTCheckBoxViewDataSource> dataSource;
@property(nonatomic, weak) id <DTCheckBoxViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame dataSource:(id <DTCheckBoxViewDataSource>)dataSource;

- (void)selectBoxAtRow:(NSInteger)row column:(NSInteger)column;

- (void)unSelectBoxAtRow:(NSInteger)row column:(NSInteger)column;
@end


@protocol DTCheckBoxViewDataSource <NSObject>

@required
- (CGFloat)heightOfRowInCheckBox:(DTCheckBoxView *)checkBox;

- (NSInteger)numberOfRowsInCheckBox:(DTCheckBoxView *)checkBox;

- (NSInteger)numberOfColumnsInCheckBox:(DTCheckBoxView *)checkBox;

- (NSInteger)maxCheckableInCheckBox:(DTCheckBoxView *)checkBox;

- (NSString *)checkBox:(DTCheckBoxView *)checkBox titleAtRow:(NSInteger)row column:(NSInteger)column;
@end

@protocol DTCheckBoxViewDelegate <NSObject>

@optional
- (void)checkBox:(DTCheckBoxView *)checkBox didSelectedAtRow:(NSInteger)row andColumn:(NSInteger)column;

- (void)checkBox:(DTCheckBoxView *)checkBox didUnSelectedAtRow:(NSInteger)row andColumn:(NSInteger)column;
@end
