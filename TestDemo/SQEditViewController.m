//
//  SQEditViewController.m
//  TestDemo
//
//  Created by 小菜 on 17/2/27.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "SQEditViewController.h"
#import "DTTextView.h"
@interface SQEditViewController ()<UITextViewDelegate>

@property (nonatomic, strong) DTTextView *textView;
@end

@implementation SQEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(editDone)];
    
    self.view.backgroundColor = BackGroundColor;
    
    _textView = [[DTTextView alloc] initWithFrame:CGRectMake(0, 20, CDRViewWidth, 100) andFontSize:16];
    _textView.layer.borderColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
    _textView.layer.borderWidth = 1.0;
    _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _textView.placeholder = _placeholder;
    _textView.scrollEnabled = NO;
    _textView.delegate = self;
    _textView.noScroll = YES;
    
    CGFloat cleanButtonWidth = 40;
    UIButton *cleanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cleanButton setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [cleanButton setImage:[UIImage imageNamed:@"cross-down"] forState:UIControlStateHighlighted];
    cleanButton.backgroundColor = [UIColor clearColor];
    cleanButton.frame = CGRectMake(_textView.frame.size.width - cleanButtonWidth - 20, (_textView.frame.size.height - cleanButtonWidth) / 2, cleanButtonWidth, cleanButtonWidth);
    [cleanButton addTarget:self action:@selector(cleanText) forControlEvents:UIControlEventTouchUpInside];
    [_textView addSubview:cleanButton];
    
    [self.view addSubview:_textView];
}

- (void)editDone {
    if (self.callBlock) {
        self.callBlock(self.textView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (comcatstr.length > self.limit)
    {
        NSString *str = [NSString stringWithFormat:@"你输入字符超过限定输入字符%ld个字符",self.limit];
        SHOW_ALERT(str);
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > _limit)
    {
        NSString *s = [nsTextContent substringToIndex:_limit];
        
        [textView setText:s];
    }
    _textView.counterLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)existTextNum, (long)_limit];
}
-(void)cleanText{
    
    _textView.text = @"";
    _textView.counterLabel.text = [NSString stringWithFormat:@"%ld/%ld", _textView.text.length, (long)self.limit];
}
@end
