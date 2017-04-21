//
//  SQLoginRegisterView.m
//  TestDemo
//
//  Created by 小菜 on 17/2/7.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "SQLoginRegisterView.h"
#import "XMGTextField.h"
@interface SQLoginRegisterView ()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

/** 登录框距离控制器view左边的间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;
@property (weak, nonatomic) IBOutlet XMGTextField *phoneText;
@property (weak, nonatomic) IBOutlet XMGTextField *pwdText;
@property (nonatomic,strong)  UILabel *label1;
@property (nonatomic,strong)  UIButton *btn2;
@end

@implementation SQLoginRegisterView
- (IBAction)loginBtnClick:(id)sender {
    if (!self.checkBtn.selected) {
        SHOW_ALERT(@"请阅读并同意私人社区用户协议");
    } else {
        if (self.loginBlock) {
            self.loginBlock(_phoneText.text,_pwdText.text);
        }
    }
}
- (IBAction)registBtn:(id)sender {
    SHOW_ALERT(@"社长推荐第三方登陆注册😄")
}

- (void)awakeFromNib {
    [super awakeFromNib];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backEndEditing)];
    [self addGestureRecognizer:tap];
    WEAKSELF
    self.checkBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"gift_btn_checkbox_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gift_btn_checkbox_high"] forState:UIControlStateSelected];
        [self addSubview:btn];
        btn;
    });
    
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.loginBtn.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.loginBtn.mas_left).offset(10);
        make.width.height.mas_equalTo(20);
    }];
    
    self.label1 = ({
        UILabel *lab = [[UILabel alloc] init];
        [self addSubview:lab];
        lab.text = @"我已阅读并同意";
        lab.adjustsFontSizeToFitWidth = YES;
        lab.textColor = [UIColor whiteColor];
        lab.font = FONT_SIZE(13);
        lab;
    });
    
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.checkBtn.mas_right).offset(5);
        make.top.height.equalTo(weakSelf.checkBtn);
        make.width.equalTo(@92);
    }];
    self.btn2 = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"《私人社区用户协议》" forState:UIControlStateNormal];
        [btn setTitleColor:RGBCOLOR(27, 168, 234) forState:UIControlStateNormal];
        btn.titleLabel.font = FONT_SIZE(13);
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:btn];
        btn;
    });
    [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.label1.mas_right);
        make.top.height.equalTo(weakSelf.label1);
        make.width.equalTo(@135);
    }];
    
    self.checkBtn.selected  = YES;
    [[self.checkBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        weakSelf.checkBtn.selected = !weakSelf.checkBtn.selected;
    }];
    [[self.btn2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (weakSelf.goAgreeeHtml) {
            weakSelf.goAgreeeHtml();
        }
    }];
}
- (void)backEndEditing {
    [self endEditing:YES];
}
- (IBAction)showLoginOrRegister:(UIButton *)button {
    // 退出键盘
    [self endEditing:YES];
    
    if (self.loginViewLeftMargin.constant == 0) { // 显示注册界面
        self.loginViewLeftMargin.constant = - self.width;
        button.selected = YES;
    } else { // 显示登录界面
        self.loginViewLeftMargin.constant = 0;
        button.selected = NO;
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
}


@end
