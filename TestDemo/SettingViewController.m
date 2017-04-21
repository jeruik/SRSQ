//
//  SettingViewController.m
//  Cinderella
//
//  Created by mac on 15/5/26.
//  Copyright (c) 2015年 cloudstruct. All rights reserved.
//

#import "SettingViewController.h"
#import "DTSandbox.h"
#import "UIColor+Hex.h"
#import "DTFramework.h"
#import <RongIMKit/RongIMKit.h>
#import "CYDataCache.h"
#import "CoreNewFeatureVC.h"
#import <ShareSDK/ShareSDK.h>
#import "SQBlackViewController.h"
#import "CYHomeViewController.h"
typedef NS_ENUM(NSUInteger, SettingCellFunc) {
    SettingCellFuncAccount,
    SettingCellFuncRating,
    SettingCellFuncCleanCache,
    SettingCellFuncVerDesc,
    SettingCellFuncAboutUs,
    SettingCellFuncFeedback,
    SettingCellFuncFeedUserback,  // 黑名单
    SettingCellFuncLogout
};

@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property(nonatomic, strong) NSMutableArray *tableCells;
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableCells addObjectsFromArray:@[
                                           @{@"title":@"清除缓存", @"func":@(SettingCellFuncCleanCache)},
                                           @{@"title":@"客服中心", @"func":@(SettingCellFuncFeedback)},
                                           @{@"title":@"黑名单", @"func":@(SettingCellFuncFeedUserback)},
                                           @{@"title":@"版本介绍", @"func":@(SettingCellFuncVerDesc)},
                                           @{@"title":@"关于我们", @"func":@(SettingCellFuncAboutUs)},
                                           @{@"title":@"给私人社区打分", @"func":@(SettingCellFuncRating)},
                                           @{@"title":@"退出当前账号", @"func":@(SettingCellFuncLogout)}]];
    UITableView *table = [[UITableView alloc] initWithFrame:FRAME(0, 0, self.view.width, self.view.height-NAV_BAR_HEIGHT) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    self.tableView = table;
    [self.view addSubview:table];
}

- (NSMutableArray *)tableCells{
    if (_tableCells == nil) {
        _tableCells = [NSMutableArray arrayWithCapacity:11];
    }
    return _tableCells;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tableCells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *cell_info = [self.tableCells objectAtIndex:indexPath.row];
    NSString *title = cell_info[@"title"];
    SettingCellFunc func = [cell_info[@"func"] integerValue];
    static NSString *tableCellIdentifier = @"SeetingsTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:tableCellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"585858"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (func == SettingCellFuncCleanCache) {
        float size = [DTSandbox cacheSize];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"(%.2fM)", size];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    } else {
        cell.detailTextLabel.text = @"";
    }
    cell.textLabel.text = title;
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:12];
    label.text = [NSString stringWithFormat:@"当前版本: %@ (%@)", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    return label;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![SVProgressHUD isVisible]) {
        NSDictionary *cell_info = [self.tableCells objectAtIndex:indexPath.row];
        SettingCellFunc func = [cell_info[@"func"] integerValue];
        
        switch (func) {
            case SettingCellFuncAccount:
                
                break;
            case SettingCellFuncCleanCache:{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"缓存大小为%.2fM，确定要清理缓存吗？", [DTSandbox cacheSize]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清除", nil];
                [alert attachUserInfo:@{@"alert_type":@"clean_cache"}];
                [alert show];
            }
                break;
            case SettingCellFuncLogout:{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
                [alert attachUserInfo:@{@"alert_type":@"logout"}];
                [alert show];
            }
                break;
            case SettingCellFuncFeedback:
            {
                SHOW_ALERT(@"如有任何问题请联系作者qq：491235759");
            }
                break;
            case SettingCellFuncAboutUs:{
                SHOW_ALERT(@"打造顶级免费私人社区聊天平台，感谢你的支持！");
            }
                break;
            case SettingCellFuncVerDesc:{
                NewFeatureModel *m1 = [NewFeatureModel model:[UIImage imageNamed:@"f1"]];
                NewFeatureModel *m2 = [NewFeatureModel model:[UIImage imageNamed:@"f2"]];
                NewFeatureModel *m3 = [NewFeatureModel model:[UIImage imageNamed:@"f3"]];
                NewFeatureModel *m4 = [NewFeatureModel model:[UIImage imageNamed:@"f4"]];
                __block CoreNewFeatureVC *vc = [CoreNewFeatureVC newFeatureVCWithModels:@[m1,m2,m3,m4] enterBlock:^{
                    [vc dismissViewControllerAnimated:YES completion:nil];
                }];
                [self presentViewController:vc animated:YES completion:nil];
//                NSString *text = [NSString stringWithFormat:@"当前版本: %@ (%@)", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
//                SHOW_ALERT(text);
            }
                break;
            case SettingCellFuncRating:
            {
                NSString *shareUrl = @"https://itunes.apple.com/cn/app/id1127768538";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:shareUrl]];
            }
                break;
            case SettingCellFuncFeedUserback:
            {
                [self.navigationController pushViewController:[SQBlackViewController new] animated:YES];
                break;
            }
        }
    }
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSDictionary *userInfo = [alertView userInfo];
    NSString* type = [userInfo objectForKey:@"alert_type"];
    if ([type isEqualToString:@"logout"]) {
        if (buttonIndex == 1) {
            [self logout];
        }
    }else if ([type isEqualToString:@"clean_cache"]){
        if (buttonIndex == 1) {
            DTLog(@"%@", [DTSandbox docPath]);
            [SVProgressHUD show];
            CGFloat cacheSize = [DTSandbox cacheSize];
            float durition = cacheSize *0.4;
            [DTSandbox clearCache];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(durition * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(durition+0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            });
            
        }
    }
}
- (void)logout{
    [[RCIM sharedRCIM] logout];
    [ShareSDK cancelAuthorize: SSDKPlatformTypeQQ];
    [ShareSDK cancelAuthorize: SSDKPlatformTypeSinaWeibo];
    [CYDataCache removeObjectForKey:@"srsq"];
    
    [SQUser sharedUser].token = nil;
    [SQUser sharedUser].pwd = nil;
    [SQUser sharedUser].sex = nil;
    [SQUser sharedUser].username = nil;
    [SQUser sharedUser].headimgurl = nil;
    [SQUser sharedUser].openid = nil;
    [SQUser sharedUser].way = nil;
    [SQUser sharedUser].rcuserid = nil;
    [SQUser sharedUser].rctoken = nil;
    [SQUser sharedUser].GM = nil;
    [SQUser sharedUser].tags = nil;
    [SQUser sharedUser].photos = nil;
    [SQUser sharedUser].activity = nil;
    
    // 保留数据源
    
    [AppDelegate appDelegate].window.rootViewController = [[CYHomeViewController alloc] init];
}
- (NSString *)rightBarButtonTitle{
    return nil;
}
- (NSString *)title{
    return @"设置";
}

@end
