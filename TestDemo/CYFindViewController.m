
//
//  CYFindViewController.m
//  TestDemo
//
//  Created by 小菜 on 17/2/4.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "CYFindViewController.h"
#import "FindHeaderView.h"
#import "FindBannerModel.h"
#import "SVWebViewController.h"
#import "FindUserModel.h"
#import "FindViewCell.h"
#import "CYDataCache.h"
#import "CYUserViewController.h"
#import "MJRefresh.h"
#import "SQReleaseActController.h"
#import "CYNetworkManager.h"
#import "UploadImageTool.h"
#import "JSONKit.h"
#import "CYFindDetailViewController.h"
#import "CYConnecViewController.h"
#import "DTActionSheet.h"
#import "DTShowHudView.h"
#import "RCDCustomerServiceViewController.h"

//select * from sqbanners;
//update sqbanners set bannertext = '客服在线';
//alter table sqbanners add bannertext character varying(255)
//delete from sqbanners where btype = '3';

@interface CYFindViewController ()

@property (nonatomic, strong) NSMutableArray *bannerArray;
@property (nonatomic, strong) NSMutableArray<FindUserModel *> *dataArray;
@property (nonatomic, strong) FindHeaderView *headerView;
@property (nonatomic, assign) CGPoint contentOffset;
@end
static NSString * const findViewCellID = @"findViewCell";
@implementation CYFindViewController

- (NSMutableArray *)bannerArray
{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (FindHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[FindHeaderView alloc] initWithFrame:CGRectMake(0, 0, CDRViewWidth, (CDRViewWidth*222)/750+30)];
        WEAKSELF
        NSMutableArray *tempArray = [NSMutableArray array];
        NSMutableArray *titleArr = [NSMutableArray array];
        for (int i = 0; i<self.bannerArray.count; i++) {
            FindBannerModel *m = self.bannerArray[i];
            [tempArray addObject:m.imgurl];
            [titleArr addObject:m.bannertext];
        }
        _headerView.imageArray = tempArray;
        _headerView.titleArray = titleArr;
        _headerView.pageViewClick = ^(NSInteger index){
            FindBannerModel *model = weakSelf.bannerArray[index];
            switch (model.bannerType) {
                    case BannerTypeWeb:
                {
                    if (model.imgurl.length >0 && model.imgurl) {
                        SVWebViewController *webVc = [[SVWebViewController alloc] initWithAddress:model.neturl];
                        [weakSelf.navigationController pushViewController:webVc animated:YES];
                    }
                    break;
                }
                    case BannerTypePeople:
                {
                    [[SQUser sharedUser].rcChatDatesource enumerateObjectsUsingBlock:^(CYUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.rcuserid isEqualToString:model.squserid]) {
                            CYConnecViewController *vc = [[CYConnecViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:obj.rcuserid];
                            vc.title = obj.username;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                            *stop = YES;
                        }
                    }];
                }
                    break;
                case BannerTypeOther:
                {
                }
                    break;
            }
        };
    }
    return _headerView;
}
- (void)releaseLog {
    SQReleaseActController *vc = [[SQReleaseActController alloc] init];
    WEAKSELF
    vc.releaseBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 200;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.953 alpha:1.000];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"releaseDayLog"] style:UIBarButtonItemStylePlain target:self action:@selector(releaseLog)];
    WEAKSELF
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadBannerArray];
        [weakSelf loadDataArray];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FindViewCell class]) bundle:nil] forCellReuseIdentifier:findViewCellID];
    [self.tableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goWeb:) name:SQUrlClick object:nil];
    
    [self test];
}
- (void)goWeb:(NSNotification *)noti {
    SVWebViewController *webVc = [[SVWebViewController alloc] initWithAddress:noti.object];
    [self.navigationController pushViewController:webVc animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.contentOffset = self.tableView.contentOffset;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)loadBannerArray {
    // 获取banner条数据
    __weak typeof(self) weakSelf = self;
    [[CYNetworkManager manager].httpSessionManager GET:DEF_SQBanner parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [LCProgressHUD hide];
        weakSelf.bannerArray = [FindBannerModel mj_objectArrayWithKeyValuesArray:responseObject];
        weakSelf.tableView.tableHeaderView = weakSelf.headerView;
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [LCProgressHUD hide];
    }];
}
- (void)loadDataArray {
    WEAKSELF

    [CYNetworkHandle postReqeustWithURL:DEF_ACT_List params:@{@"page":@(1)} successBlock:^(CYResponse *responseObject) {
        NSArray<FindUserModel *> *datas = [FindUserModel mj_objectArrayWithKeyValuesArray:responseObject.responseData[@"data"]];
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.dataArray addObjectsFromArray:[datas reverseObjectEnumerator].allObjects];
        
        [weakSelf refreshData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        
//        [weakSelf cacheStatusImages:[datas reverseObjectEnumerator].allObjects call:^(NSArray *array) {
//            weakSelf.dataArray = [NSMutableArray arrayWithArray:array];
//            [weakSelf.dataArray enumerateObjectsUsingBlock:^(FindUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                [obj calculate];
//            }];
//            [weakSelf.tableView.mj_header endRefreshing];
//            [weakSelf.tableView reloadData];
//        }];
    } failureBlock:^(CYResponseError *cyNetworkError) {
        [LCProgressHUD showFailure:cyNetworkError.errorMsg];
        [weakSelf.tableView.mj_header endRefreshing];
    } showHUD:NO];
}
/** 下载缓存单张图片 */
- (void)cacheStatusImages:(NSArray *)datas call:(void(^)(NSArray *array))downImageDoweCallBlock {
    if (datas.count == 0) {
        !downImageDoweCallBlock ? : downImageDoweCallBlock(datas);
    } else {
        dispatch_group_t group = dispatch_group_create();
        for (FindUserModel *model in datas) {
            // 将当前操作添加到组
            if (model.photostr.length > 1) {
                NSArray *urls = [model.photostr mj_JSONObject];
                if (urls.count == 1) {
                    NSString *qiuUrl = urls.firstObject;
                    qiuUrl = [NSString stringWithFormat:@"%@%@%@",QiniuHeader,qiuUrl,QiniuSub];
                    dispatch_group_enter(group);
                    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:qiuUrl] options:SDWebImageAvoidAutoSetImage progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        dispatch_group_leave(group);
                    }];
                }else {
                    continue;
                }
            } else {
                continue;
            }
        }
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            downImageDoweCallBlock(datas);
        });
    }
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FindViewCell *cell = [tableView dequeueReusableCellWithIdentifier:findViewCellID];
    FindUserModel *model = self.dataArray[indexPath.row];
    model.index = indexPath.row;
    cell.userModel = model;
    WEAKSELF
    cell.headerBlock = ^(NSString *account){
        CYUserViewController *vc = [[CYUserViewController alloc] init];
        vc.account = account;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    cell.shareBlock = ^(FindUserModel *m) {
        DTActionSheet *sheet = [DTActionSheet sheetWithTitle:nil buttonTitles:@[@"举报",@"拉黑",@"分享"] redButtonIndex:-1 callback:^(NSUInteger clickedIndex) {
            if (clickedIndex == 0) {
                if ([m.account isEqualToString:[SQUser sharedUser].account]) {
                    SHOW_ALERT(@"操作失败，不能举报自己动态");
                    return ;
                } else {
                    
                    DTActionSheet *reportSheet = [DTActionSheet sheetWithTitle:@"举报原因" buttonTitles:@[@"广告",@"色情低俗",@"欺诈或恶意营销",@"谩骂",@"其他"] redButtonIndex:-1 callback:^(NSUInteger clickedIndex) {
                        NSMutableArray *reportArr = [CYDataCache cy_ObjectForKey:SRSQRport];
                        if (reportArr) {
                            [reportArr addObject:@(m.ID)];
                        }else {
                            reportArr = [NSMutableArray array];
                        }
                        [CYDataCache cy_setObject:reportArr forKey:SRSQRport];
                        [LCProgressHUD showLoading:nil];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [LCProgressHUD hide];
                            [weakSelf.dataArray removeObjectAtIndex:m.index];
                            NSIndexPath *idx = [NSIndexPath indexPathForRow:m.index inSection:0];
                            [weakSelf.tableView deleteRowsAtIndexPaths:@[idx] withRowAnimation:0];
//                            [weakSelf.tableView reloadRowsAtIndexPaths:@[idx] withRowAnimation:0];
                            SHOW_ALERT(@"感谢您的反馈，我们暂时为您屏蔽该动态，社长会在24小时内进行核实，核实成功后，按照私人社区用户协议进行相应处罚");
                        });
                    }];
                    [reportSheet showInWindow];
                }
            } else if (clickedIndex == 1) {
                if ([m.account isEqualToString:[SQUser sharedUser].account]) {
                    SHOW_ALERT(@"操作失败，不能拉黑自己");
                    return ;
                } else {
                    NSMutableArray *blackArr = [CYDataCache cy_ObjectForKey:SRSQBlcakUser];
                    if (blackArr) {
                        [blackArr addObject:m.account];
                    }else {
                        blackArr = [NSMutableArray array];
                    }
                    [CYDataCache cy_setObject:blackArr forKey:SRSQBlcakUser];
                    [LCProgressHUD showLoading:nil];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [LCProgressHUD hide];
                        [weakSelf refreshData];
                        [weakSelf.tableView reloadData];
                        SHOW_ALERT(@"已成功加入黑名单，社区动态列表以及广场将会屏蔽该用户，您可在设置-黑名单，管理您的黑名单列表");
                    });
                }
            } else if (clickedIndex == 2){
                [weakSelf share:m];
            }
        }];
        [sheet showInWindow];
    };
    return cell;
}
- (void)refreshData {
    // 屏蔽举报
    NSMutableArray *tempReport = [NSMutableArray array];
    NSMutableArray *reportArr = [CYDataCache cy_ObjectForKey:SRSQRport];
    if (reportArr) {
        for (NSNumber *ID in reportArr) {
            for (FindUserModel *m in self.dataArray) {
                if (m.ID == ID.integerValue) {
                    [tempReport addObject:m];
                }
            }
        }
    }
    [self.dataArray removeObjectsInArray:tempReport];
    
    // 处理拉黑
    NSMutableArray *tempBlack = [NSMutableArray array];
    NSMutableArray *blackArr = [CYDataCache cy_ObjectForKey:SRSQBlcakUser];
    if (blackArr) {
        for (NSString *account in blackArr) {
            for (FindUserModel *m in self.dataArray) {
                if ([m.account isEqualToString:account]) {
                    [tempBlack addObject:m];
                }
            }
        }
    }
    [self.dataArray removeObjectsInArray:tempBlack];
}
- (void)share:(FindUserModel *)userModel {
    NSString *pre = SQAPI;
    NSString *shareUrl = [NSString stringWithFormat:@"%@/share?id=%ld",pre,userModel.ID];
    NSString *shareTitle = @"私人社区";
    NSString *shareText  = userModel.actcontent;
    NSString *coverUrl = userModel.thimbimgPhotos.firstObject;
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams setObject:safityObject(coverUrl) forKey:@"image"];
    [shareParams setObject:safityObject(shareTitle) forKey:@"title"];
    [shareParams setObject:safityObject(shareUrl) forKey:@"url"];
    [shareParams setObject:safityObject(shareText) forKey:@"shareText"];
    [shareParams setObject:@"1" forKey:@"share_type"];
    
    [DTShowHudView showShareViewWithContents:shareParams successBlock:^{
        
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FindUserModel *find = self.dataArray[indexPath.row];
    // 跳转到与该用户聊天界面
    CYUserModel *model = [[CYUserModel alloc] init];
    model.headimgurl = find.headimgurl;
    model.username = find.username;
    model.rcuserid = find.rcuserid;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FindUserModel *model = self.dataArray[indexPath.row];
    return model.cellH + 10;
}

- (void)test {
//        // 管理员权限 - 添加banner条
//        NSDictionary *dict = @{@"imgurl":@"https://a-ssl.duitang.com/uploads/item/201702/03/20170203155136_dLsPJ.jpeg",
//                               @"neturl":@"https://www.duitang.com/blog/?id=445874419",
//                               @"btype":@(3),
//                               @"squserid":@"KEFU148893944348130"
//                               };
//        [CYNetworkHandle postReqeustWithURL:DEF_SQAddBanner params:dict successBlock:^(CYResponse *responseObject) {
//            LxDBAnyVar(responseObject);
//        } failureBlock:^(CYResponseError *cyNetworkError) {
//            LxDBAnyVar(cyNetworkError.errorMsg);
//        } showHUD:NO];

}
- (void)test2 {
//    AFHTTPRequestOperationManager * privateManager ＝ [AFHTTPRequestOperationManager manager];
//    privateManager.requestSerializer＝ [AFJSONRequestSerializer serializer];
//    [self.manager POST:url
//            parameters:parameters
//               success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                   
//               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                   
//               }];
}
@end
