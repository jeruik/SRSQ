//
//  CYMoneyMessage.h
//  TestDemo
//
//  Created by 小菜 on 17/1/26.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface CYMoneyMessage : RCMessageContent

@property (nonatomic, assign) double amount;
@property (nonatomic, strong) NSString *desc;

- (instancetype)initWith:(double)amount description:(NSString *)desc;

@end
