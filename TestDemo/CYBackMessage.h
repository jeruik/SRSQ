//
//  CYBackMessage.h
//  TestDemo
//
//  Created by 小菜 on 17/1/26.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface CYBackMessage : RCMessageContent

@property (nonatomic, strong) NSString *backMessageUID;

- (instancetype)initWithBackUID:(NSString *)uid;

@end
