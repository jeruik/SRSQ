//
//  RCConnectListViewController.m
//  TestDemo
//
//  Created by 小菜 on 17/1/25.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "CYConnectListViewController.h"
#import "CYConnecViewController.h"
#import "CYAllUserController.h"
#import "CYHomeViewController.h"
#import "CYDataCache.h"
#import "CYUserViewController.h"
#import "MSTool.h"
@interface CYConnectListViewController ()

@end

@implementation CYConnectListViewController
// 继承于融云的最近常聊界面
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.conversationListTableView.tableFooterView = [UIView new];
    self.isShowNetworkIndicatorView = YES;
    self.showConnectingStatusOnNavigatorBar = YES;
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"timg"] style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    self.navigationItem. rightBarButtonItem = item;
    [self getNewVersion];
    [self login];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getChatDateSource];
}
- (void)getChatDateSource {
    [[CYNetworkManager manager].httpSessionManager GET:DEF_AllFriends parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [LCProgressHUD hide];
        [SQUser sharedUser].rcChatDatesource = [CYUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [LCProgressHUD hide];
    }];
}
// 点击tableview cell代理方法，跳转到聊天界面
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    
    CYConnecViewController *conversationVC = [[CYConnecViewController alloc] init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
}
// 自己写的聊天广场，- 具体思路，从jspatch服务器获取所有用户后展示给用户
- (void)add {
    
    [self.navigationController pushViewController:[CYAllUserController new] animated:YES];
}

- (void)didTapCellPortrait:(RCConversationModel *)model {
    WEAKSELF
    [[SQUser sharedUser].rcChatDatesource enumerateObjectsUsingBlock:^(CYUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.rcuserid isEqualToString:model.targetId]) { // 是同一个人
            *stop = YES;
            CYUserViewController *vc = [[CYUserViewController alloc] init];
            vc.account = obj.account;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
}
- (void)login {
    
    WEAKSELF
    [[RCIM sharedRCIM] connectWithToken:[SQUser sharedUser].rctoken success:^(NSString *userId) {
        
    } error:^(RCConnectErrorCode status) {
        if (status == RC_CONNECTION_EXIST) {
            
        }
    } tokenIncorrect:^{
        [SVProgressHUD showWithStatus:@"正在连接社区服务器..."];
        // 重新注册rc_token
        // 获取获取融云Token的接口
        NSString *url = @"https://api.cn.ronghub.com/user/getToken.json";
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
        NSDictionary *dict = @{
                               @"userId":[SQUser sharedUser].rcuserid,
                               @"name":[SQUser sharedUser].username,
                               @"portraitUri":[SQUser sharedUser].headimgurl};
        NSString *nonce = [[MSTool sharedMSTool] getRandomNonce];
        NSString *timestamp = [[MSTool sharedMSTool] getTimestamp];
        NSString *signature = [[MSTool sharedMSTool] getSignatureWithAppSecret:RCIN_APP_Secret nonce:nonce timestamp:timestamp];
        [manager.requestSerializer setValue:RCIN_APP_KEY forHTTPHeaderField:@"App-Key"];
        [manager.requestSerializer setValue:nonce forHTTPHeaderField:@"Nonce"];
        [manager.requestSerializer setValue:timestamp forHTTPHeaderField:@"Timestamp"];
        [manager.requestSerializer setValue:signature forHTTPHeaderField:@"Signature"];
        
        [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 传送给服务器保存数据
            [SQUser sharedUser].rctoken = responseObject[@"token"];
            // 生成token
            [CYNetworkHandle postReqeustWithURL:DEF_SaveRctoken params:@{@"account":[SQUser sharedUser].account,@"rcuserid":[SQUser sharedUser].rcuserid,@"rctoken":[SQUser sharedUser].rctoken,@"openid":[SQUser sharedUser].openid} successBlock:^(CYResponse *responseObject) {
                NSString *code = responseObject.responseData[@"result"];
                [SVProgressHUD dismiss];
                if (code.integerValue == 0) {
                    [SQUser sharedUser].token = responseObject.responseData[@"token"];
                    [CYDataCache cy_setObject:[SQUser sharedUser] forKey:@"srsq"];
                } else {
                    [weakSelf showAlert];
                }
                
            } failureBlock:^(CYResponseError *cyNetworkError) {
                [SVProgressHUD dismiss];
                [weakSelf showAlert];
            } showHUD:NO];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [SVProgressHUD dismiss];
            [LCProgressHUD showFailure:error.localizedDescription];
        }];
    }];
}
- (void)showAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登陆聊天服务器失败，请更新最新版" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [[alert rac_buttonClickedSignal] subscribeNext:^(id x) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1127768538"]];
    }];
    [alert show];
}
-(void)getNewVersion {
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [CYNetworkHandle postReqeustWithURL:DEF_Get_Version params:@{@"version":version} successBlock:^(CYResponse *responseObject) {
        NSString *code = responseObject.responseData[@"result"];
        if (code.integerValue == 1) {
            NSString *msg = responseObject.responseData[@"msg"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"再看看" otherButtonTitles:@"更新", nil];
            [[alert rac_buttonClickedSignal] subscribeNext:^(id x) {
                NSNumber *num = x;
                if (num.integerValue == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1127768538"]];
                }
            }];
            [alert show];
        }
    } failureBlock:^(CYResponseError *cyNetworkError) {
        
    } showHUD:NO];
}
    
- (void)GgetChatDateSource {
    [[CYNetworkManager manager].httpSessionManager GET:DEF_AllFriends parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [LCProgressHUD hide];
        NSString *startUrl = responseObject[@"pic"];
        [[NSUserDefaults standardUserDefaults] setObject:safityObject(startUrl) forKey:@"startImage"];
        
        NSString *color = responseObject[@"color"];
        [[NSUserDefaults standardUserDefaults] setObject:safityObject(color) forKey:@"color"];
        
        [SQUser sharedUser].rcChatDatesource = [CYUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        if (startUrl) {
            if (startUrl.length > 0) {
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:startUrl] options:SDWebImageAvoidAutoSetImage progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                }];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [LCProgressHUD hide];
    }];
}
    
@end
