//
//  SQBlackViewController.m
//  TestDemo
//
//  Created by 小菜 on 17/3/4.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "SQBlackViewController.h"
#import "MJRefresh.h"
#import "CYAllUserTableViewCell.h"
#import "CYDataCache.h"
#import "DTActionSheet.h"

@interface SQBlackViewController ()
@property (nonatomic, strong) NSArray *allUser;
@end

@implementation SQBlackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"黑名单";
    [self.tableView registerNib:[UINib nibWithNibName:@"CYAllUserTableViewCell" bundle:nil] forCellReuseIdentifier:@"BlackTableViewCellID"];
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.tableFooterView = [UIView new];
}
- (void)loadData {
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSArray *arr =[SQUser sharedUser].rcChatDatesource;
        if (arr.count == 0) {
            [[CYNetworkManager manager].httpSessionManager GET:DEF_AllFriends parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [SQUser sharedUser].rcChatDatesource = [CYUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                NSMutableArray *tempArr = [NSMutableArray array];
                NSMutableArray *blackArr = [CYDataCache cy_ObjectForKey:SRSQBlcakUser];
                if (blackArr) {
                    for (NSString *account in blackArr) {
                        for (CYUserModel *m in arr) {
                            if ([account isEqualToString:m.account]) {
                                [tempArr addObject:m];
                            }
                        }
                    }
                    weakSelf.allUser = [NSArray arrayWithArray:tempArr];
                    [weakSelf.tableView.mj_header endRefreshing];
                    if (weakSelf.allUser.count == 0) {
                        SHOW_ALERT(@"暂未拉黑任何用户");
                    }
                    [weakSelf.tableView reloadData];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [LCProgressHUD hide];
            }];
        } else {
            NSMutableArray *tempArr = [NSMutableArray array];
            NSMutableArray *blackArr = [CYDataCache cy_ObjectForKey:SRSQBlcakUser];
            if (blackArr) {
                for (NSString *account in blackArr) {
                    for (CYUserModel *m in arr) {
                        if ([account isEqualToString:m.account]) {
                            [tempArr addObject:m];
                        }
                    }
                }
                self.allUser = [NSArray arrayWithArray:tempArr];
                [self.tableView.mj_header endRefreshing];
                [LCProgressHUD hide];
                if (self.allUser.count == 0) {
                    SHOW_ALERT(@"暂未拉黑任何用户");
                }
                [self.tableView reloadData];
            }
        }
    });
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allUser.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CYAllUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BlackTableViewCellID"];
    CYUserModel *model = self.allUser[indexPath.row];
    cell.model = model;
    cell.contentView.userInteractionEnabled = NO;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CYUserModel *model = self.allUser[indexPath.row];
    return model.cellH;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CYUserModel *model = self.allUser[indexPath.row];
    WEAKSELF
    DTActionSheet *sheet = [DTActionSheet sheetWithTitle:nil buttonTitles:@[@"从黑名单中移除",] redButtonIndex:-1 callback:^(NSUInteger clickedIndex) {
        if (clickedIndex == 0) {
            NSMutableArray *blackArr = [CYDataCache cy_ObjectForKey:SRSQBlcakUser];
            for (NSString *account in blackArr) {
                if ([account isEqualToString:model.account]) {
                    [blackArr removeObject:account];
                }
            }
            [CYDataCache cy_setObject:blackArr forKey:SRSQBlcakUser];
            [weakSelf loadData];
        }
    }];
    [sheet showInWindow];
    
}
@end
