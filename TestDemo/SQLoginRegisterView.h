//
//  SQLoginRegisterView.h
//  TestDemo
//
//  Created by 小菜 on 17/2/7.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQLoginRegisterView : UIView
@property (nonatomic,strong)  UIButton *checkBtn;
@property (nonatomic, copy) void(^loginBlock)(NSString *phone,NSString *pwd);
@property (nonatomic, copy) void(^goAgreeeHtml)();
@end
