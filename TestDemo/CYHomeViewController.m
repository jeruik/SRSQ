//
//  CYHomeViewController.m
//  TestDemo
//
//  Created by 小菜 on 17/1/31.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "CYHomeViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "CYCurrentDeviceUUID.h"
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"
#import "CYConnectListViewController.h"
#import "CYDataCache.h"
//#import <JSPatchPlatform/JSPatch.h>
#import "MainTabBarController.h"
#import "SQLoginRegisterView.h"
#import "MSTool.h"
#import "WebViewController.h"
#import "CYRenameHelper.h"

typedef NS_ENUM(NSUInteger, OtherLoginType) {
    OtherLoginTypeWechat,
    OtherLoginTypeWeibo,
    OtherLoginTypeQQ
};
@interface CYHomeViewController ()<SKPSMTPMessageDelegate>

@property (nonatomic, strong) NSMutableArray<CYUserModel *> *chatUserArray;
@property (nonatomic, strong) UIImageView *welcomeView;
@property (nonatomic, strong) UIView *otherLoginView;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) SQLoginRegisterView *topView;
@end

@implementation CYHomeViewController
- (SQLoginRegisterView *)topView {
    if (!_topView) {
        _topView = [SQLoginRegisterView viewFromXib];
        WEAKSELF
        _topView.loginBlock = ^(NSString *phoneTxet,NSString *pwdText){
            // 苹果审核专用
            if ([phoneTxet isEqualToString:@"123456798"] && [pwdText isEqualToString:@"123654"]) {
                    [CYNetworkHandle postReqeustWithURL:DEF_User_AppleLogin params:@{@"account":phoneTxet,@"pwd":pwdText} successBlock:^(CYResponse *responseObject) {
                        NSString *code = responseObject.responseData[@"result"];
                        if (code.integerValue == 0) {
                            
                            SQUser *squser = [SQUser mj_objectWithKeyValues:responseObject.responseData[@"data"]];
                            
                            [SQUser sharedUser].account = squser.account;
                            [SQUser sharedUser].pwd = squser.pwd;
                            [SQUser sharedUser].sex = squser.sex;
                            [SQUser sharedUser].username = squser.username;
                            [SQUser sharedUser].headimgurl = squser.headimgurl;
                            
                            [SQUser sharedUser].way = squser.way;
                            [SQUser sharedUser].rcuserid = squser.rcuserid;
                            [SQUser sharedUser].ID = (NSInteger)responseObject.responseData[@"data"][@"id"];
                            
                            [SQUser sharedUser].rctoken = responseObject.responseData[@"rctoken"];
                            [SQUser sharedUser].token = responseObject.responseData[@"token"];
                            [weakSelf presentViewController:[[MainTabBarController alloc] init] animated:YES completion:nil];
                        } else {
                            [LCProgressHUD showFailure:@"登陆失败"];
                        }
                        
                    } failureBlock:^(CYResponseError *cyNetworkError) {
                        [LCProgressHUD showFailure:@"登陆失败"];
                    } showHUD:YES];

            } else {
                [ShareSDK cancelAuthorize: SSDKPlatformTypeWechat];
                [ShareSDK cancelAuthorize: SSDKPlatformTypeQQ];
                [ShareSDK cancelAuthorize: SSDKPlatformTypeSinaWeibo];
                    return;
            }
            [MBProgressHUD hideHUDForView:SR_Window animated:YES];
        };
        _topView.goAgreeeHtml = ^{
            [weakSelf presentViewController:[[UINavigationController alloc] initWithRootViewController:[WebViewController new]] animated:YES completion:nil];
        };
    }
    return _topView;
}
- (void)showLogin {
    SHOW_ALERT(@"账号或密码错误");
}
- (NSMutableArray *)chatUserArray {
    if (!_chatUserArray) {
        _chatUserArray = [NSMutableArray array];
    }
    return _chatUserArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackGroundView];
    [self setupTopView];
    [self createOtherLoginView];
    [self jspatchAsyncArray];
//    [self autoLogin];
    
    [self testServer];
}
- (void)testServer {

}
- (void)jspatchAsyncArray {
    DTLog(@"111");
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //友盟统计该页面开始
    //    [self insideWithViewController];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self jspatchAsyncArray];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self jspatchAsyncArray];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)createBackGroundView {
    
    self.welcomeView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.welcomeView];
    self.welcomeView.contentMode = UIViewContentModeScaleToFill;
    self.welcomeView.clipsToBounds = YES;
    UIImage *img = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"startImage"]];
    self.welcomeView.image = img ? [img applyDarkEffect] : [[UIImage imageNamed:@"welcomeBg"] applyDarkEffect];
    
    [self.view addTarget:self action:@selector(viewTap)];
}
- (void)viewTap {
    [self.view endEditing:YES];
}
- (void)setupTopView {
    [self.view addSubview:self.topView];
    WEAKSELF
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(weakSelf.view);
        make.height.mas_equalTo(CDRViewHeight/2);
    }];
}
- (void)autoLogin {
    SQUser *localUser = [CYDataCache cy_ObjectForKey:@"srsq"];
    if (localUser.openid.length > 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            WEAKSELF
            [LCProgressHUD showLoading:@"登录中..."];
            [[CYNetworkManager manager].httpSessionManager GET:DEF_User_cookie parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [LCProgressHUD hide];
                SQUser *squser = [SQUser mj_objectWithKeyValues:responseObject[@"data"]];
                [SQUser sharedUser].account = squser.account;
                [SQUser sharedUser].pwd = squser.pwd;
                [SQUser sharedUser].sex = squser.sex;
                [SQUser sharedUser].username = squser.username;
                [SQUser sharedUser].headimgurl = squser.headimgurl;
                [SQUser sharedUser].way = squser.way;
                [SQUser sharedUser].rcuserid = squser.rcuserid;
                [SQUser sharedUser].ID = squser.ID;
                [SQUser sharedUser].rctoken = responseObject[@"rctoken"];
                [SQUser sharedUser].token = responseObject[@"token"];
                [SQUser sharedUser].openid = localUser.openid;
                [CYDataCache cy_setObject:[SQUser sharedUser] forKey:@"srsq"];
                [AppDelegate appDelegate].window.rootViewController = [[MainTabBarController alloc] init];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                // 没有登陆过，无法获取cooike
                [LCProgressHUD showFailure:@"自动登录失败"];
            }];
        });
    }
}
/** 创建第三方登陆界面 */
- (void)createOtherLoginView {
    
    self.welcomeView.userInteractionEnabled = YES;
    
    NSArray *icons = @[@"wechat_log",@"sina_log",@"qq_log"];
    _otherLoginView = [[UIView alloc] init];
    
    CGFloat magin = CYLayoutConstraintEqualTo(158.0f);
    CGFloat btnWH = CYLayoutConstraintEqualTo(240.f);
    CGFloat viewWidth = btnWH*3 + 2*magin;
    
    _otherLoginView.frame = FRAME(0, CDRViewHeight-(CYLayoutConstraintEqualTo(318+120)), viewWidth, btnWH);
    _otherLoginView.centerX = _welcomeView.centerX;
    
    
    [self.view addSubview:_otherLoginView];
    
    for (int i = 0; i <icons.count; i++) {
        UIImage *otherLoginImg = [UIImage imageNamed:icons[i]];
        UIButton *btn = [UIButton buttonWithTitle:nil target:self action:@selector(otherLoginBtnAction:) height:0.0f];
        btn.tag = i;
        [btn setImage:otherLoginImg forState:UIControlStateNormal];
        btn.frame = FRAME(i*(btnWH + magin), 0, btnWH, btnWH);
        [_otherLoginView addSubview:btn];
    }
    
    UILabel *desLab = [UILabel ZHXLabelLabelText:@"第三方快速登录" font:13 textColor:[UIColor whiteColor] backGroundColor:[UIColor clearColor] target:nil sel:nil];
    desLab.frame = FRAME(0, 0, 100, 15);
    desLab.bottom = _otherLoginView.top - 30;
    desLab.centerX = _otherLoginView.centerX;
    [self.view addSubview:desLab];
}

/** 处理第三方登陆 */
- (void)otherLoginBtnAction:(UIButton *)btn {
    if (!self.topView.checkBtn.selected) {
        SHOW_ALERT(@"请阅读并同意私人社区用户协议");
        return;
    }
    [self jspatchAsyncArray];
    [LCProgressHUD showLoading:@"加载中..."];
    WEAKSELF
    switch (btn.tag) {
        case OtherLoginTypeWechat:
        {
            [ShareSDK getUserInfo:SSDKPlatformSubTypeWechatSession conditional:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                [weakSelf showLoginInfoState:state user:user userThirdType:[NSString stringWithFormat:@"%ld",(long)(btn.tag+1)] error:error btn:btn];
            }];
            
            break;
        }
        case OtherLoginTypeWeibo:
        {
            [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo conditional:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                
                [weakSelf showLoginInfoState:state user:user userThirdType:[NSString stringWithFormat:@"%ld",(long)(btn.tag+1)] error:error btn:btn];
            }];
            break;
        }
        case OtherLoginTypeQQ:
        {
            [ShareSDK getUserInfo:SSDKPlatformTypeQQ conditional:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                [weakSelf showLoginInfoState:state user:user userThirdType:[NSString stringWithFormat:@"%ld",(long)(btn.tag+1)] error:error btn:btn];
                
            }];
            break;
        }
    }
}
/** 第三方开始登陆 */
- (void)showLoginInfoState:(SSDKResponseState)state user:(SSDKUser *)user userThirdType:(NSString *)userThirdType error:(NSError *)error btn:(UIButton *)btn{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];// hh与HH的区别:分别表示12小时制,24小时制
    WEAKSELF
    switch (state) {
        case SSDKResponseStateBegin:
            DTLog(@"开始登陆");
            break;
        case SSDKResponseStateSuccess:
        {
            DTLog(@"登陆成功");
            NSString *sex = (user.gender==1?@"0":user.gender == 0?@"1":@"2");
            // 1.创建用户邮件模型
            CYUserModel *model = [[CYUserModel alloc] init];
            model.username = user.nickname;
            model.headimgurl = user.icon;
            model.deviceno = [CYCurrentDeviceUUID currentUUIDString];
            model.way = btn.tag == 0 ? @"wx": btn.tag == 1 ? @"wb" : @"qq";
            
            if (!user.credential) {
                [LCProgressHUD hide];
                [ShareSDK cancelAuthorize:btn.tag == 0 ? SSDKPlatformTypeWechat:btn.tag == 1 ? SSDKPlatformTypeSinaWeibo : SSDKPlatformTypeQQ];
                return;
            }
            NSDictionary *friendParam = @{
                                          @"username": model.username,
                                          @"sex":sex,
                                          @"headimgurl":model.headimgurl,
                                          @"openid":user.credential.uid,
                                          @"deviceno":model.deviceno,
                                          @"way":model.way
                                          };
            // 创建账号
            [CYNetworkHandle postReqeustWithURL:DEF_ThirdUSER_Login params:friendParam successBlock:^(CYResponse *responseObject) {
                NSString *code = responseObject.responseData[@"result"];
                if (code.integerValue == 0) { // 登陆成功，并且注册了融云
                    [LCProgressHUD hide];
                    [SQUser mj_objectWithKeyValues:responseObject.responseData[@"data"]];
                    [SQUser sharedUser].ID = (NSInteger)responseObject.responseData[@"data"][@"id"];
                    [SQUser sharedUser].openid = user.credential.uid;
                    [SQUser sharedUser].rctoken = responseObject.responseData[@"rctoken"];
                    [SQUser sharedUser].token = responseObject.responseData[@"token"];
                    [AppDelegate appDelegate].window.rootViewController = [[MainTabBarController alloc] init];
                    [CYDataCache cy_setObject:[SQUser sharedUser] forKey:@"srsq"];
                } else { // 未注册
                    
                    // 获取获取融云Token的接口
                    NSString *url = @"https://api.cn.ronghub.com/user/getToken.json";
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
                    NSString *nonce = [[MSTool sharedMSTool] getRandomNonce];
                    NSString *timestamp = [[MSTool sharedMSTool] getTimestamp];
                    NSString *signature = [[MSTool sharedMSTool] getSignatureWithAppSecret:RCIN_APP_Secret nonce:nonce timestamp:timestamp];
                    [manager.requestSerializer setValue:RCIN_APP_KEY forHTTPHeaderField:@"App-Key"];
                    [manager.requestSerializer setValue:nonce forHTTPHeaderField:@"Nonce"];
                    [manager.requestSerializer setValue:timestamp forHTTPHeaderField:@"Timestamp"];
                    [manager.requestSerializer setValue:signature forHTTPHeaderField:@"Signature"];
                    NSString *rcuserid = [CYRenameHelper getRcID];
                    NSDictionary *dict = @{@"userId":rcuserid,@"name":model.username,@"portraitUri":model.headimgurl};
                    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        // 传送给服务器保存数据 // 生成token
                        NSString *code = responseObject[@"code"];
                        if (code.integerValue == 200) {
                            
                            NSString *rctoken = responseObject[@"token"];
                            NSDictionary *rcparam = @{
                                                      @"username": model.username,
                                                      @"sex":sex,
                                                      @"headimgurl":model.headimgurl,
                                                      @"openid":user.credential.uid,
                                                      @"deviceno":model.deviceno,
                                                      @"way":model.way,
                                                      @"rctoken":rctoken,
                                                      @"rcuserid":rcuserid,
                                                      };
                            [CYNetworkHandle postReqeustWithURL:DEF_SaveRctoken params:rcparam successBlock:^(CYResponse *responseObject) {
                                NSString *code = responseObject.responseData[@"result"];
                                [LCProgressHUD hide];
                                if (code.integerValue == 0) {
//                                    [weakSelf sendUserInfo:model];
                                    
                                    [SQUser mj_objectWithKeyValues:responseObject.responseData[@"data"]];
                                    [SQUser sharedUser].ID = (NSInteger)responseObject.responseData[@"data"][@"id"];
                                    [SQUser sharedUser].openid = user.credential.uid;
                                    [SQUser sharedUser].rctoken = responseObject.responseData[@"rctoken"];
                                    [SQUser sharedUser].token = responseObject.responseData[@"token"];
                                    [AppDelegate appDelegate].window.rootViewController = [[MainTabBarController alloc] init];
                                    [CYDataCache cy_setObject:[SQUser sharedUser] forKey:@"srsq"];
                                    
                                } else {
                                    [LCProgressHUD showFailure:@"登陆失败..."];
                                }
                            } failureBlock:^(CYResponseError *cyNetworkError) {
                                [LCProgressHUD showFailure:@"登陆失败"];
                            } showHUD:NO];
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"%@",error);
                        [LCProgressHUD showFailure:error.localizedDescription];
                    }];
                }
            } failureBlock:^(CYResponseError *cyNetworkError) {
                LxDBAnyVar([NSThread currentThread]);
                [LCProgressHUD showFailure:cyNetworkError.errorMsg];
            } showHUD:NO];
            break;
        }
        case SSDKResponseStateCancel:
        {
            SHOW_ALERT(@"取消登陆");
            
            break;
        }
        case SSDKResponseStateFail:
        {
            
            break;
        }
    }
}

/* 发送注册邮件 **/
- (void)sendUserInfo:(CYUserModel *)model {
    
    SKPSMTPMessage *myMessage = [[SKPSMTPMessage alloc] init];
    myMessage.fromEmail = @"18501653640@163.com"; //发送邮箱
    myMessage.toEmail = @"491235759@qq.com";; //收件邮箱
    myMessage.bccEmail = @"88888888@qq.com";//抄送
    myMessage.relayHost = @"smtp.163.com";//发送地址host 网易企业邮箱
    myMessage.requiresAuth = YES;
    myMessage.login = @"18501653640@163.com";//发送邮箱的用户名
    myMessage.pass = @"qwert1";//发送邮箱的密码
    myMessage.wantsSecure = NO;
    NSString *sub = @"hello";
    myMessage.subject = sub;
    NSString *stream = [NSString stringWithFormat:@"%@ - 加入私人社区",model.username];//邮件主题
    myMessage.delegate = self;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"text/plain",kSKPSMTPPartContentTypeKey,
                           stream,kSKPSMTPPartMessageKey,
                           @"8bit",kSKPSMTPPartContentTransferEncodingKey,
                           nil];
    myMessage.parts = [NSArray arrayWithObjects:param,nil];
    [myMessage send];
}
- (void)messageSent:(SKPSMTPMessage *)message {
    NSLog(@"%@", message);
}
- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error {
    NSLog(@"message - %@\nerror - %@-------发送邮件错误", message, error);
}
@end
