//
//  CYConnecViewController.m
//  TestDemo
//
//  Created by 小菜 on 17/1/25.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "CYConnecViewController.h"
#import "CYMoneyMessage.h"
#import "CYMessageCell.h"
#import "CYBackMessage.h"
#import "CYBackMessageCell.h"

#import "CYDataCache.h"
#import "CYUserModel.h"
#import "CYUserViewController.h"

@interface CYConnecViewController (RCIMReceiveMessageDelegate)<RCIMReceiveMessageDelegate>

@end

@implementation CYConnecViewController (RCIMReceiveMessageDelegate)

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    if ([message.objectName isEqualToString:[CYBackMessage getObjectName]]) {
        CYBackMessage *rm = (CYBackMessage *)message.content;
        RCMessage *rcmessage = [[RCIMClient sharedRCIMClient] getMessageByUId:rm.backMessageUID];
        [self.conversationDataRepository enumerateObjectsUsingBlock:^(RCMessageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.messageId == rcmessage.messageId) {
                *stop = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self deleteMessage:obj];
                });
            }
        }];
    }
}

@end

@interface CYConnecViewController ()
{
    CGRect oldFrame;
    UIImageView *fullScreenIV;
}
@property (nonatomic, strong) RCMessageModel *longSelectModel;
@end

@implementation CYConnecViewController

// 继承于融云的聊天界面
- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加扩展板
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"charge_None"] title:@"红包" tag:2000];
    // 注册自定义消息 的cell
    [self registerClass:[CYMessageCell class] forMessageClass:[CYMoneyMessage class]];
    [self registerClass:[CYBackMessageCell class] forMessageClass:[CYBackMessage class]];

    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
    // 设置发送输入状态
    [[RCIM sharedRCIM] setEnableTypingStatus:YES];
    
    if (self.conversationType == ConversationType_DISCUSSION) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(quitDiscussion)];
    }
}
- (void)quitDiscussion {
    WEAKSELF
    [[RCIMClient alloc] quitDiscussion:self.targetId success:^(RCDiscussion *discussion) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SHOW_ALERT(@"已成功退出讨论组");
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } error:^(RCErrorCode status) {
        
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
// 自定义红包消息
- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag {
    if (tag == 2000) {
        
        [[RCIM sharedRCIM] sendMessage:self.conversationType targetId:self.targetId content:[[CYMoneyMessage alloc] initWith:1000 description:@"工作顺利"] pushContent:@"您有一条新的红包消息" pushData:@"{\"cid\":1234567}" success:^(long messageId) {
            
        } error:^(RCErrorCode nErrorCode, long messageId) {
            
        }];
        
    } else {
        [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    }
}
// 融云的消息cell，由于添加了红包和撤回功能，需要重写
- (RCMessageBaseCell *)rcConversationCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *m = self.conversationDataRepository[indexPath.item];
    if ([m.objectName isEqualToString:[CYMoneyMessage getObjectName]]) {
        CYMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CYMessageCell identifier] forIndexPath:indexPath];
        [cell setModel:m];
        cell.conViewController = self;
        return cell;
    } else if ([m.objectName isEqualToString:[CYBackMessage getObjectName]]) {
        CYBackMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CYBackMessageCell identifier] forIndexPath:indexPath];
        [cell setModel:m];
        return cell;
    }else {
        return [self rcUnkownConversationCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
}

// 消息的宽高，如果是自定义红包需要实现计算宽高
- (CGSize)rcConversationCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RCMessageModel *m = self.conversationDataRepository[indexPath.item];
    if ([m.objectName isEqualToString:[CYMoneyMessage getObjectName]]) {
        CGFloat h = 130 + (m.isDisplayNickname ? 20 : 0);
        return CGSizeMake(collectionView.frame.size.width, h);
    } else if ([m.objectName isEqualToString:[CYBackMessage getObjectName]]) {
        return CGSizeMake(collectionView.frame.size.width, 40 + (m.isDisplayMessageTime ? 20 : 0));
    } else {
        return [self rcUnkownConversationCollectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
}

// 长按消息代理方法
- (void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view {
    _longSelectModel = nil;
    
    [super didLongTouchMessageCell:model inView:view];
    
    UIMenuController *mvc = [UIMenuController sharedMenuController];
    UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(backMessage:)];
    
    if (mvc.menuVisible) {
        NSMutableArray *itmes = [NSMutableArray arrayWithArray:mvc.menuItems];
        [itmes addObject:item];
        [mvc setMenuItems:itmes];
    } else {
        [mvc setMenuItems:@[item]];
    }
    [mvc setMenuVisible:YES animated:YES];
    _longSelectModel = model;
}
// 自定义撤回消息功能
- (void)backMessage:(id)sender {
    if (self.longSelectModel) {
        RCMessage *m = [[RCIMClient sharedRCIMClient] getMessage:self.longSelectModel.messageId];
        [[RCIM sharedRCIM] sendMessage:self.conversationType targetId:self.targetId content:[[CYBackMessage alloc] initWithBackUID:m.messageUId] pushContent:@"撤回消息" pushData:@"{\"cid\":1234567}" success:^(long messageId) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self deleteMessage:self.longSelectModel];
            });
            
        } error:^(RCErrorCode nErrorCode, long messageId) {
            
        }];
    }
}
// 点击头像事件
- (void)didTapCellPortrait:(NSString *)userId {
    WEAKSELF
    [[SQUser sharedUser].rcChatDatesource enumerateObjectsUsingBlock:^(CYUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.rcuserid isEqualToString:userId]) { // 是同一个人
            *stop = YES;
            CYUserViewController *vc = [[CYUserViewController alloc] init];
            vc.account = obj.account;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];

}

// 点击头像看原图
-(void)tapForOriginal{
    [UIView animateWithDuration:0.3 animations:^{
        fullScreenIV.frame = oldFrame;
        fullScreenIV.alpha = 0.03;
    } completion:^(BOOL finished) {
        fullScreenIV.alpha = 1;
        [fullScreenIV removeFromSuperview];
        
    }];
}
-(void)tapForFullScreen:(NSString *)str {
    UIImageView *avatarIV;
    oldFrame = [avatarIV convertRect:avatarIV.bounds toView:[UIApplication sharedApplication].keyWindow];
    if (fullScreenIV==nil) {
        fullScreenIV= [[UIImageView alloc]initWithFrame:avatarIV.frame];
    }
    fullScreenIV.backgroundColor = [UIColor blackColor];
    fullScreenIV.userInteractionEnabled = YES;
    [fullScreenIV sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"HomeAlertContentView_movie_text"]];
    fullScreenIV.contentMode = UIViewContentModeScaleAspectFit;
    [[UIApplication sharedApplication].keyWindow addSubview:fullScreenIV];
    
    [UIView animateWithDuration:0.3 animations:^{
        fullScreenIV.frame = CGRectMake(0,0,kScreenWidth, kScreenHeight);
    }];
    UITapGestureRecognizer *originalTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapForOriginal)];
    [fullScreenIV addGestureRecognizer:originalTap];
    
}
@end
