//
//  CYMessageCell.h
//  TestDemo
//
//  Created by 小菜 on 17/1/26.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
@class CYConnecViewController;
@interface CYMessageCell : RCMessageCell

@property (nonatomic, weak) CYConnecViewController *conViewController;

+ (NSString *)identifier;

@end
