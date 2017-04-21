//
//  SQTipViewController.m
//  TestDemo
//
//  Created by 小菜 on 17/2/27.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "SQTipViewController.h"
#import "UIColor+Hex.h"
#import "DTCheckBoxView.h"
#import "UIView+ViewFrameGeometry.h"

#import "SVProgressHUD.h"
@interface SQTipViewController () <DTCheckBoxViewDataSource, DTCheckBoxViewDelegate,UITextViewDelegate>

@property(nonatomic, strong) NSArray *hobbys;
@property(nonatomic, strong) NSMutableArray *selectedHobbys;
@property(nonatomic, strong) DTCheckBoxView *checkBoxView;
@end

@implementation SQTipViewController

- (NSString *)title {
    return @"兴趣";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackGroundColor;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    
    self.hobbys = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"options_hobby" ofType:@"plist"]];
    
    _textView = [[DTTextView alloc] initWithFrame:CGRectMake(0, 20, CDRViewWidth, 70) andFontSize:16];
    _textView.layer.borderColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
    _textView.layer.borderWidth = 1.0;
    _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _textView.scrollEnabled = NO;
    _textView.delegate = self;
    _textView.noScroll = YES;
    _textView.editable = NO;
    _textView.counterLabel.text = @"0/4";
    
    CGFloat cleanButtonWidth = 40;
    UIButton *cleanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cleanButton setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [cleanButton setImage:[UIImage imageNamed:@"cross-down"] forState:UIControlStateHighlighted];
    cleanButton.backgroundColor = [UIColor clearColor];
    
    cleanButton.frame = CGRectMake(_textView.frame.size.width - cleanButtonWidth - 20, (_textView.frame.size.height - cleanButtonWidth) / 2, cleanButtonWidth, cleanButtonWidth);
    [cleanButton addTarget:self action:@selector(cleanText) forControlEvents:UIControlEventTouchUpInside];
    [_textView addSubview:cleanButton];
    
    [self.view addSubview:_textView];
    
    CGFloat y = _textView.bottom + 30;
    self.checkBoxView = [[DTCheckBoxView alloc] initWithFrame:CGRectMake(0, y, CDRViewWidth, CDRViewHeight - NAV_BAR_HEIGHT - y) dataSource:self];
    [self.view addSubview:_checkBoxView];
    _checkBoxView.delegate = self;
    self.selectedHobbys = [[NSMutableArray alloc] init];
}
- (void)done {
    [self cancel];
}
- (void)cleanText {
    for (int i = 0; i < [_selectedHobbys count]; i++) {
        NSInteger row = [_selectedHobbys[i] integerValue] / 3;
        NSInteger column = [_selectedHobbys[i] integerValue] % 3;
        [_checkBoxView unSelectBoxAtRow:row column:column];
    }
    [_selectedHobbys removeAllObjects];
    [self updateTextView];
}

- (NSString *)rightBarButtonTitle {
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self convertUserHobby];
    [self updateTextView];
    for (int i = 0; i < [_selectedHobbys count]; i++) {
        NSInteger row = [_selectedHobbys[i] integerValue] / 3;
        NSInteger column = [_selectedHobbys[i] integerValue] % 3;
        [_checkBoxView selectBoxAtRow:row column:column];
    }
}

- (void)convertUserHobby {
    NSString *hobbyString = self.tags;
    NSArray *hobbyArray = [hobbyString componentsSeparatedByString:@","];
    for (NSString *hobby in hobbyArray) {
        if ([_hobbys containsObject:hobby]) {
            [_selectedHobbys addObject:@([_hobbys indexOfObject:hobby])];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)cancel{
    if ([_selectedHobbys count] == 0) {
        [SVProgressHUD showInfoWithStatus:@"请至少选择一个兴趣爱好"];
        return;
    }
    if ([_textView.text isEqualToString:self.tags]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        self.tags = _textView.text;
        if (self.tagsBlock) {
            self.tagsBlock(self.tags);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - DTCheckBox Data Source

- (CGFloat)heightOfRowInCheckBox:(DTCheckBoxView *)checkBox {
    return 65;
}

- (NSInteger)numberOfRowsInCheckBox:(DTCheckBoxView *)checkBox {
    return ceil([_hobbys count] / 3.0);
}

- (NSInteger)numberOfColumnsInCheckBox:(DTCheckBoxView *)checkBox {
    return 3;
}

- (NSInteger)maxCheckableInCheckBox:(DTCheckBoxView *)checkBox {
    return 4;
}

- (NSString *)checkBox:(DTCheckBoxView *)checkBox titleAtRow:(NSInteger)row column:(NSInteger)column {
    NSInteger index = row * 3 + column;
    if (index >= [_hobbys count]) {
        return nil;
    } else {
        return [_hobbys objectAtIndex:index];
    }
}

#pragma mark - DTCheckBox Delegate

- (void)checkBox:(DTCheckBoxView *)checkBox didSelectedAtRow:(NSInteger)row andColumn:(NSInteger)column {
    [_selectedHobbys addObject:@(row * 3 + column)];
    [self updateTextView];
}

- (void)checkBox:(DTCheckBoxView *)checkBox didUnSelectedAtRow:(NSInteger)row andColumn:(NSInteger)column {
    [_selectedHobbys removeObject:@(row * 3 + column)];
    [self updateTextView];
}

- (void)updateTextView {
    _textView.counterLabel.text = [NSString stringWithFormat:@"%lu/4",(unsigned long)[_selectedHobbys count]];
    if ([_selectedHobbys count] > 0) {
        NSString *text = [_hobbys objectAtIndex:[_selectedHobbys[0] integerValue]];
        for (int i = 1; i < [_selectedHobbys count]; i++) {
            text = [text stringByAppendingFormat:@",%@", [_hobbys objectAtIndex:[_selectedHobbys[i] integerValue]]];
        }
        _textView.text = text;
        
    } else {
        _textView.text = @"";
    }
}
@end
