//
//  CYAllUserController.m
//  TestDemo
//
//  Created by 小菜 on 17/2/3.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "CYAllUserController.h"
#import "CYDataCache.h"
#import <RongIMKit/RongIMKit.h>
#import "CYConnecViewController.h"
#import "CYAllUserTableViewCell.h"
#import "CYUserViewController.h"
#import "MJRefresh.h"
#define GroupKey @"haveCreatGroup"

@interface CYAllUserController ()

@property (nonatomic, strong) NSArray<CYUserModel *> *allUser;
@property (nonatomic, strong) NSMutableArray *selectorPatnArray;
@end

@implementation CYAllUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"广场";
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CYAllUserTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"CYAllUserTableViewCellID"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);

    if ([SQUser sharedUser].ID == 1) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(addGroup:)];
    }
    BOOL haveAlert = [[NSUserDefaults standardUserDefaults] boolForKey:@"haveAlert"];
    if (!haveAlert) {
        SHOW_ALERT(@"请文明聊天、交友，如果您在使用过程中恶意骚扰或被骚扰，请前往社区首页联系客服，客服核实后将按照私人社区用户协议对违规用户进行相应处理。");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"haveAlert"];
    }
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.tableView.editing = NO;
    [self.selectorPatnArray removeAllObjects];
}
- (void)loadData {
    WEAKSELF
    [[CYNetworkManager manager].httpSessionManager GET:DEF_AllFriends parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.allUser = [CYUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        NSArray *arr = [weakSelf.allUser sortedArrayUsingComparator:^NSComparisonResult(CYUserModel  *_Nonnull obj1, CYUserModel  *_Nonnull obj2) {
            if (obj1.zannum > obj2.zannum) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            if (obj1.zannum < obj2.zannum) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        weakSelf.allUser = arr;
        
        // 黑名单处理
        NSMutableArray *tempArr = [NSMutableArray array];
        NSMutableArray *blackArr = [CYDataCache cy_ObjectForKey:SRSQBlcakUser];
        if (blackArr) {
            for (NSString *account in blackArr) {
                for (CYUserModel *m in weakSelf.allUser) {
                    if ([account isEqualToString:m.account]) {
                        [tempArr addObject:m];
                    }
                }
            }
            NSMutableArray *all = [NSMutableArray arrayWithArray:weakSelf.allUser];
            [all removeObjectsInArray:tempArr];
            weakSelf.allUser = [NSArray arrayWithArray:all];
        }
        [weakSelf.tableView reloadData];
        [SQUser sharedUser].rcChatDatesource = [NSMutableArray arrayWithArray:weakSelf.allUser];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [LCProgressHUD showFailure:@"加载失败"];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allUser.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CYAllUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYAllUserTableViewCellID"];
    CYUserModel *model = self.allUser[indexPath.row];
    model.index = indexPath.row;
    cell.model = model;
    WEAKSELF
    cell.headerViewBlock = ^(CYUserModel *m){
        CYUserViewController *vc = [[CYUserViewController alloc] init];
        vc.account = m.account;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.tableView.isEditing) {
        [self.selectorPatnArray addObject:self.allUser[indexPath.row]];
    } else {
        // 跳转到与该用户聊天界面
        CYUserModel *model = self.allUser[indexPath.row];
        __block BOOL haveExists = NO;
        [[SQUser sharedUser].rcChatDatesource enumerateObjectsUsingBlock:^(CYUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.rcuserid isEqualToString:model.rcuserid]) {
                haveExists = YES;
                *stop = YES;
            }
        }];
        if (!haveExists) {
            [[SQUser sharedUser].rcChatDatesource addObject:model];
        }
        CYConnecViewController *vc = [[CYConnecViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:model.rcuserid];
        vc.title = model.username;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CYUserModel *model = self.allUser[indexPath.row];
    return model.cellH;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectorPatnArray.count > 0) {
        [self.selectorPatnArray removeObject:self.allUser[indexPath.row]];
    }
}
#pragma mark - 创建谈论组

- (void)addGroup:(UIBarButtonItem *)item{
    WEAKSELF
    if ([item.title isEqualToString:@"选择"]) {
        //移除之前选中的内容
        if (self.selectorPatnArray.count > 0) {
            [self.selectorPatnArray removeAllObjects];
        }
        item.title = @"确认";
        //进入编辑状态
        [self.tableView setEditing:YES animated:YES];
    }else{
        
        NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:GroupKey];
        if (index || index <1) {
            index ++;
            [[NSUserDefaults standardUserDefaults] setInteger:index forKey:GroupKey];
        } else {
            SHOW_ALERT(@"讨论组数量上限");
            return;
        }
        if (self.selectorPatnArray.count >= 10) {
            SHOW_ALERT(@"最多选择10位用户");
            return;
        }
        item.title = @"选择";
        [self.tableView setEditing:NO animated:YES];
        if (self.selectorPatnArray.count > 0) {
            NSMutableArray *arr = [NSMutableArray array];
            for (CYUserModel *model in self.selectorPatnArray) {
                [arr addObject:model.rcuserid];
            }
            
            [[RCIMClient alloc] createDiscussion:[NSString stringWithFormat:@"%@的讨论组",[SQUser sharedUser].username] userIdList:arr success:^(RCDiscussion *discussion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [LCProgressHUD showSuccess:@"创建成功"];
                    LxDBAnyVar(discussion.discussionId);
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
                [[RCIMClient alloc] setDiscussionName:discussion.discussionId name:[NSString stringWithFormat:@"%@的讨论组",[SQUser sharedUser].username] success:^{
                    LxDBAnyVar(discussion.discussionId);
                } error:^(RCErrorCode status) {
                }];
            } error:^(RCErrorCode status) {
                
            }];
        }
    }
}

- (NSMutableArray *)selectorPatnArray{
    if (!_selectorPatnArray) {
        _selectorPatnArray = [NSMutableArray array];
    }
    return _selectorPatnArray;
}

@end
