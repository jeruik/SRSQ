//
//  CYUserViewController.m
//  TestDemo
//
//  Created by 小菜 on 17/2/4.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "CYUserViewController.h"
#import "HeaderView.h"
#import "WZBSegmentedControl.h"
#import "SettingViewController.h"
#import "SQPhotoTableViewCell.h"
#import "YYPhotoGroupView.h"
#import "SQEditViewController.h"
#import "SVWebViewController.h"
#import "CYAllUserTableViewCell.h"
#import "SQTipViewController.h"
#import "TimeTool.h"
#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoAssets.h"
#import "UploadImageTool.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+ImageCut.h"
#import "customActivity.h"
#import "DTShowHudView.h"
#import "DTActionSheet.h"
#import "CYDataCache.h"
// san最大的
#define MAXValue(a,b,c) (a>b?(a>c?a:c):(b>c?b:c))
// rgb
#define WZBColor(r, g, b) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:1.0]

#define HeaderH 150

@interface CYUserViewController ()<UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

// 左边的tableView
@property (nonatomic, strong) UITableView *leftTableView;

// 中间的tableView
@property (nonatomic, strong) UITableView *centerTableView;

// 右边的tableView
@property (nonatomic, strong) UITableView *rightTableView;

// 顶部的headeView
@property (nonatomic, strong) UIView *headerView;

// 可滑动的segmentedControl
@property (nonatomic, strong) WZBSegmentedControl *sectionView;

// 底部横向滑动的scrollView，上边放着三个tableView
@property (nonatomic, strong) UIScrollView *scrollView;

// 头部头像
@property (nonatomic, strong) UIImageView *avatar;

@property (nonatomic, strong) HeaderView *header;
@property (nonatomic, strong) CYUserModel *userModel;
@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, strong) NSArray *assets;
@property (nonatomic, strong) UIImageView *bg;

@property (nonatomic, assign) BOOL haveLoadDone;

@end

@implementation CYUserViewController

- (void)setHaveLoadDone:(BOOL)haveLoadDone {
    _haveLoadDone = haveLoadDone;
    
    if (self.navigationController.childViewControllers.count > 1) {
        if (haveLoadDone) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn-share-n"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
        } else {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(sendRequset)];
        }
    } else {
        if (haveLoadDone) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn-share-n"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
        } else {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(sendRequset)];
        }
    }
}

- (NSArray *)assets {
    if (!_assets) {
        _assets = [NSArray array];
    }
    return _assets;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.25 animations:^{
        self.avatar.alpha = 1.0;
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.isSelf = [self.account isEqualToString:[SQUser sharedUser].account];
    if (self.isSelf && (self.navigationController.childViewControllers.count == 1)) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
    }
    
    [self setup];
    self.maxCount = 9;
    
    [self sendRequset];
}
- (void)sendRequset {
    WEAKSELF
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[CYNetworkManager manager].httpSessionManager POST:DEF_User_Profile parameters:@{@"account":self.account} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        NSString *code = responseObject[@"result"];
        if (code.integerValue == 0) {
            weakSelf.haveLoadDone = YES;
            weakSelf.edgesForExtendedLayout = UIRectEdgeNone;
            weakSelf.userModel = [CYUserModel mj_objectWithKeyValues:responseObject[@"data"]];
            weakSelf.userModel.isSelf = weakSelf.isSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.header.model = weakSelf.userModel;
                [weakSelf.avatar sd_setImageWithURL:[NSURL URLWithString:weakSelf.userModel.headimgurl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image) {
                        [weakSelf.bg setImage:[image imageByBlurExtraLight]];
                    } else {
                        [weakSelf.avatar setImage:[UIImage imageNamed:@"chat-women"]];
                        [weakSelf.bg setImage:[[UIImage imageNamed:@"chat-women"] imageByBlurExtraLight]];
                    }
                }];
                weakSelf.scrollView.hidden = NO;
                [weakSelf.leftTableView reloadData];
                [weakSelf.centerTableView reloadData];
                [weakSelf.rightTableView reloadData];
            });
        } else {
            weakSelf.haveLoadDone = NO;
            [LCProgressHUD showFailure:@"请求失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        weakSelf.haveLoadDone = NO;
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];}
#pragma Actions
- (void)avatarTap:(UITapGestureRecognizer *)tap {
    if (self.isSelf) {
        MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
        pickerVc.topShowPhotoPicker = YES;
        pickerVc.status = PickerViewShowStatusCameraRoll;
        pickerVc.maxCount = 1;
        [pickerVc showPickerVc:self];
        
        WEAKSELF
        pickerVc.callBack = ^(NSArray *assets){ //图片装在数组里面
            [LCProgressHUD showLoading:nil];
            MLSelectPhotoAssets *asset = assets.firstObject;
            UIImage *img = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
            [UploadImageTool uploadImage:img progress:^(NSString *key, float percent) {
            } success:^(NSString *url) {
                [LCProgressHUD hide];
                [weakSelf.avatar setImage:img];
                [weakSelf.bg setImage:[img imageByBlurExtraLight]];
                url = [NSString stringWithFormat:@"%@%@",QiniuHeader,url];
                [[CYNetworkManager manager].httpSessionManager POST:DEF_User_UpdateHeaderImage parameters:@{@"account":self.account,@"token":[SQUser sharedUser].token,@"headimgurl":url} progress:^(NSProgress * _Nonnull downloadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                }];
            } failure:^{
                [LCProgressHUD showFailure:@"上传失败"];
            } type:NO];
        };
    } else {
        UIImageView *fromView = (UIImageView *)tap.view;
        NSMutableArray *items = [NSMutableArray array];
        YYPhotoGroupItem *item = [[YYPhotoGroupItem alloc] init];
        item.thumbView = (UIImageView *)tap.view;
        item.largeImageURLStr = self.userModel.headimgurl;
        [items addObject:item];
        YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:items];
        [photoView presentFromImageView:fromView toContainer:[AppDelegate appDelegate].window.rootViewController.view fromIndex:0 animated:YES completion:nil vc:self];
    }
}

#pragma mark - setup
- (void)setup {
    // 底部横向滑动的scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.hidden = YES;
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = [UIColor colorWithWhite:0.998 alpha:1];
    
    // 绑定代理
    scrollView.delegate = self;
    
    // 设置滑动区域
    scrollView.contentSize = CGSizeMake(3 * CDRViewWidth, 0);
    scrollView.pagingEnabled = YES;
    self.scrollView = scrollView;
    
    // 创建headerView
    HeaderView *header = [HeaderView headerView:(CGRect){0, 0, CDRViewWidth, 150} userModel:self.userModel];
    WEAKSELF
    header.desLabBlock = ^{
        if (weakSelf.isSelf) {
            SQEditViewController *vc = [[SQEditViewController alloc] init];
            vc.title = @"更新签名";
            vc.placeholder = @"请输入个人签名";
            vc.limit = 100;
            vc.callBlock = ^(NSString *text){
                weakSelf.header.descLab.text = text;
                [[CYNetworkManager manager].httpSessionManager POST:DEF_User_UpdateAboutMe parameters:@{@"account":self.account,@"token":[SQUser sharedUser].token,@"aboutme":text} progress:^(NSProgress * _Nonnull downloadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSString *code = responseObject[@"result"];
                    if (code.integerValue == 0) {
                        [LCProgressHUD showSuccess:@"更新成功"];
                    } else {
                        [LCProgressHUD showFailure:@"请求失败"];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    header.userNameBlock = ^{
        if (weakSelf.isSelf) {
            SQEditViewController *vc = [[SQEditViewController alloc] init];
            vc.title = @"更新昵称";
            vc.placeholder = @"请输入昵称";
            vc.limit = 10;
            vc.callBlock = ^(NSString *text){
                weakSelf.header.userName.text = text;
                [[CYNetworkManager manager].httpSessionManager POST:DEF_User_UpdateNick parameters:@{@"account":self.account,@"token":[SQUser sharedUser].token,@"username":text} progress:^(NSProgress * _Nonnull downloadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSString *code = responseObject[@"result"];
                    if (code.integerValue == 0) {
                        [LCProgressHUD showSuccess:@"更新成功"];
                    } else {
                        [LCProgressHUD showFailure:@"请求失败"];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    self.header = header;
    // 创建segmentedControl
    WZBSegmentedControl *sectionView = [WZBSegmentedControl segmentWithFrame:(CGRect){0, 150, CDRViewWidth, 44} titles:@[@"相册", @"动态", @"标签"] tClick:^(NSInteger index) {
        
        // 改变scrollView的contentOffset
        self.scrollView.contentOffset = CGPointMake(index * CDRViewWidth, 0);
        
        
        // 刷新最大OffsetY
        [self reloadMaxOffsetY];
    }];
    
    // 赋值给全局变量
    self.sectionView = sectionView;
    
    // 设置其他颜色
    [sectionView setNormalColor:[UIColor blackColor] selectColor:THEME_COLOR sliderColor:THEME_COLOR edgingColor:[UIColor clearColor] edgingWidth:0];
    
    // 去除圆角
    sectionView.layer.cornerRadius = sectionView.backgroundView.layer.cornerRadius = .0f;
    
    // 加两条线
    for (NSInteger i = 0; i < 2; i++) {
        UIView *line = [UIView new];
        line.backgroundColor = WZBColor(228, 227, 230);
        line.frame = CGRectMake(0, 43.5 * i, CDRViewWidth, 0.5);
        [sectionView addSubview:line];
    }
    
    // 调下frame
    CGRect frame = sectionView.backgroundView.frame;
    frame.origin.y = frame.size.height - 1.5;
    frame.size.height = 1;
    sectionView.backgroundView.frame = frame;
    
    // headerView
    UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){0, 0, CDRViewWidth, CGRectGetMaxY(sectionView.frame)}];
    headerView.clipsToBounds = YES;
    UIImageView *bg = [[UIImageView alloc] initWithFrame:headerView.bounds];
    bg.contentMode = UIViewContentModeScaleAspectFill;
    [headerView addSubview:bg];
    self.bg = bg;
    headerView.backgroundColor = [UIColor colorWithWhite:0.998 alpha:1];
    [headerView addSubview:header];
    [headerView addSubview:sectionView];
    self.headerView = headerView;
    
    [self.view addSubview:headerView];
    
    // 创建三个tableView
    self.leftTableView = [self tableViewWithX:0];
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.centerTableView = [self tableViewWithX:CDRViewWidth];
    self.rightTableView = [self tableViewWithX:CDRViewWidth * 2];
    [self.rightTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CYAllUserTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"CYAllUserTableViewCellID"];
    // 加载头部头像
    UIView *avatarView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 35, 35}];
    avatarView.backgroundColor = [UIColor clearColor];
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:(CGRect){0, 26.5, 35, 35}];
    avatar.userInteractionEnabled = YES;
    [avatar addTarget:self action:@selector(avatarTap:)];
    avatar.layer.masksToBounds = YES;
    avatar.layer.cornerRadius = 35 / 2;
    avatar.contentMode = UIViewContentModeScaleAspectFill;
    [avatarView addSubview:avatar];
    self.navigationItem.titleView = avatarView;
    avatar.transform = CGAffineTransformMakeScale(2, 2);
    avatar.alpha = 0.0;
    self.avatar = avatar;
}
// 创建tableView
- (UITableView *)tableViewWithX:(CGFloat)x {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(x, 0, CDRViewWidth, CDRViewHeight - 0)];
    [self.scrollView addSubview:tableView];
    tableView.backgroundColor = BackGroundColor;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, CDRViewHeight/2, 0);
    tableView.tableFooterView = [UIView new];
    // 代理&&数据源
    tableView.delegate = self;
    tableView.dataSource = self;
    
    // 创建一个假的headerView，高度等于headerView的高度
    UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){0, 0, CDRViewWidth, 194}];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SQPhotoTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"SQPhotoTableViewCell"];
    tableView.tableHeaderView = headerView;
    return tableView;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return 1;
    }
    if (tableView == self.centerTableView) {
        return self.userModel.userAct.count;
    }
    if (tableView == self.rightTableView) {
        return 1;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView) {
        SQPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SQPhotoTableViewCell"];
        cell.isSelf = self.isSelf;
        cell.photosArray = self.userModel.userPhotos;
        WEAKSELF
        cell.addPhotoBlock = ^{
            if (weakSelf.isSelf) {
                [weakSelf selectPhoto];
            }
        };
        cell.delectPhotoBlock = ^(NSInteger index) {
            
            if (self.userModel.photos.length > 1) {
                NSArray *tempArr = [self.userModel.photos mj_JSONObject];
                NSMutableArray *arr = [NSMutableArray arrayWithArray:tempArr];
                [arr removeObjectAtIndex:index-1];
                NSString *photos = [arr JSONString];
                [SVProgressHUD show];
                [[CYNetworkManager manager].httpSessionManager POST:DEF_User_UpdatePhotos parameters:@{@"account":self.account,@"token":[SQUser sharedUser].token,@"photos":photos} progress:^(NSProgress * _Nonnull downloadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    LxDBAnyVar(responseObject);
                    [SVProgressHUD dismiss];
                    
                    NSString *code = responseObject[@"result"];
                    if (code.integerValue == 0) {
                        [LCProgressHUD showSuccess:@"删除成功"];
                        [SVProgressHUD dismiss];
                        weakSelf.userModel.photos = responseObject[@"photos"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.leftTableView reloadData];
                        });
                    } else {
                        [LCProgressHUD showFailure:@"删除失败"];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [SVProgressHUD dismiss];
                    [LCProgressHUD showFailure:error.localizedFailureReason];
                }];
            }
        };
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.backgroundColor = [UIColor colorWithWhite:0.998 alpha:1];
    if (tableView == self.centerTableView) {
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
        }
        NSString *text = self.userModel.userAct[indexPath.row];
        cell.textLabel.text = text.length > 1 ? [NSString stringWithFormat:@"%@ 发表了动态",[TimeTool changeDataFromTimeInteralStr:text]] : @"暂无动态";
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor orangeColor];
        cell.detailTextLabel.textColor = [THEME_COLOR colorWithAlphaComponent:0.8];
        return cell;
    }
    if (tableView == self.rightTableView) {
        CYAllUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYAllUserTableViewCellID"];
        cell.model = self.userModel;
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        return 3*VIEW_WIDTH + 2 *VIEW_MARGIN;
    }
    if (tableView == self.centerTableView) {
        return 50;
    }
    if (tableView == self.rightTableView) {
        return self.userModel.cellH;
    }
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.leftTableView) {

    }
    if (tableView == self.centerTableView) {
        
    }
    if (tableView == self.rightTableView) {
        
        if (self.isSelf) {
            SQTipViewController *vc = [[SQTipViewController alloc] init];
            vc.tags = self.userModel.tags;
            WEAKSELF
            vc.tagsBlock = ^(NSString *tags){
                LxDBAnyVar([NSThread currentThread]);
                weakSelf.userModel.tags = tags;
                [weakSelf.rightTableView reloadData];
                
                [[CYNetworkManager manager].httpSessionManager POST:DEF_User_UpdateTags parameters:@{@"account":self.account,@"token":[SQUser sharedUser].token,@"tags":tags} progress:^(NSProgress * _Nonnull downloadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSString *code = responseObject[@"result"];
                    if (code.integerValue == 0) {
                        [LCProgressHUD showSuccess:@"资料更新成功"];
                    } else {
                        [LCProgressHUD showFailure:@"请求失败"];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                }];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
- (void)setting {
    [self.navigationController pushViewController:[SettingViewController new] animated:YES];
}
#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 如果当前滑动的是tableView
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        
        // 如果滑动没有超过150
        if (contentOffsetY < 150) {
            
            // 让这三个tableView的偏移量相等
            self.leftTableView.contentOffset = self.centerTableView.contentOffset = self.rightTableView.contentOffset = scrollView.contentOffset;
            
            // 改变headerView的y值
            CGRect frame = self.headerView.frame;
            CGFloat y = -self.rightTableView.contentOffset.y;
            frame.origin.y = y;
            self.headerView.frame = frame;
            
            // 一旦大于等于150了，让headerView的y值等于150，就停留在上边了
        } else if (contentOffsetY >= 150) {
            CGRect frame = self.headerView.frame;
            frame.origin.y = -150;
            self.headerView.frame = frame;
        }
    }
    
    if (scrollView == self.scrollView) {
        // 改变segmentdControl
        [self.sectionView setContentOffset:(CGPoint){scrollView.contentOffset.x / 3, 0}];
        return;
    }
    
    
    // 处理顶部头像
    CGFloat scale = scrollView.contentOffset.y / 80;
    
    // 如果大于80，==1，小于0，==0
    if (scrollView.contentOffset
        .y > 80) {
        scale = 1;
    } else if (scrollView.contentOffset.y <= 0) {
        scale = 0;
    }
    
    // 缩放
    self.avatar.transform = CGAffineTransformMakeScale(2 - scale, 2 - scale);
    
    // 同步y值
    CGRect frame = self.avatar.frame;
    frame.origin.y = (1 - scale) * 8;
    self.avatar.frame = frame;
    
}

// 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        
        // 刷新最大OffsetY
        [self reloadMaxOffsetY];
    }
}

// 刷新最大OffsetY，让三个tableView同步
- (void)reloadMaxOffsetY {
    
    // 计算出最大偏移量
    CGFloat maxOffsetY = MAXValue(self.leftTableView.contentOffset.y, self.centerTableView.contentOffset.y, self.rightTableView.contentOffset.y);
    
    // 如果最大偏移量大于150，处理下每个tableView的偏移量
    if (maxOffsetY > 150) {
        if (self.leftTableView.contentOffset.y < 150) {
            self.leftTableView.contentOffset = CGPointMake(0, 150);
        }
        if (self.centerTableView.contentOffset.y < 150) {
            self.centerTableView.contentOffset = CGPointMake(0, 150);
        }
        if (self.rightTableView.contentOffset.y < 150) {
            self.rightTableView.contentOffset = CGPointMake(0, 150);
        }
    }
}
- (void)selectPhoto {
    
    
    if (self.userModel.userPhotos.count == 9) {
        NSString *str = [NSString stringWithFormat:@"一次最多只能上传%ld张哦~",(long)self.maxCount];
        SHOW_ALERT(str);
        return;
    } else {
        NSInteger maxPhotos = self.maxCount - self.userModel.userPhotos.count;
        MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
        pickerVc.topShowPhotoPicker = YES;
        pickerVc.status = PickerViewShowStatusCameraRoll;
        pickerVc.maxCount = maxPhotos - self.assets.count;
        [pickerVc showPickerVc:self];
        
        WEAKSELF
        pickerVc.callBack = ^(NSArray *assets){ //图片装在数组里面
                NSMutableArray *temp = [NSMutableArray array];
                for (int i = 0; i<assets.count; i++) {
                    MLSelectPhotoAssets *asset = assets[i];
                    UIImage *image = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
                    [temp addObject:image];
                }
                [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
                [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
                [SVProgressHUD show];
                [UploadImageTool uploadImages:temp progress:^(CGFloat progress) {
                    [SVProgressHUD showProgress:progress status:[NSString stringWithFormat:@"正在上传"]];
                } success:^(NSArray *urls) {
                    
                    NSMutableArray *arr = [NSMutableArray array];
                    if (self.userModel.photos.length > 1) {
                        [arr addObjectsFromArray:[self.userModel.photos mj_JSONObject]];
                    }
                    [arr addObjectsFromArray:urls];
                    NSString *photos = [arr JSONString];
                    [[CYNetworkManager manager].httpSessionManager POST:DEF_User_UpdatePhotos parameters:@{@"account":self.account,@"token":[SQUser sharedUser].token,@"photos":photos} progress:^(NSProgress * _Nonnull downloadProgress) {
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        LxDBAnyVar(responseObject);
                        [SVProgressHUD dismiss];
                        
                        NSString *code = responseObject[@"result"];
                        if (code.integerValue == 0) {
                            [LCProgressHUD showSuccess:@"上传成功"];
                            [SVProgressHUD dismiss];
                            weakSelf.userModel.photos = responseObject[@"photos"];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf.leftTableView reloadData];
                            });
                        } else {
                            [LCProgressHUD showFailure:@"上传失败"];
                        }
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [SVProgressHUD dismiss];
                        [LCProgressHUD showFailure:error.localizedFailureReason];
                    }];
                    
                } failure:^{
                    [SVProgressHUD dismiss];
                } type:NO];
        };
    }
}
- (void)share {
    
    WEAKSELF
    DTActionSheet *sheet = [DTActionSheet sheetWithTitle:nil buttonTitles:@[@"举报",@"拉黑",@"分享"] redButtonIndex:-1 callback:^(NSUInteger clickedIndex) {
        if (clickedIndex == 0) {
            if (weakSelf.isSelf) {
                SHOW_ALERT(@"操作失败，不能举报自己");
                return ;
            } else {
                DTActionSheet *reportSheet = [DTActionSheet sheetWithTitle:nil buttonTitles:@[@"广告",@"色情低俗",@"欺诈或恶意营销",@"谩骂",@"其他"] redButtonIndex:-1 callback:^(NSUInteger clickedIndex) {
                    [LCProgressHUD showLoading:nil];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [LCProgressHUD hide];
                        SHOW_ALERT(@"感谢您的反馈，社长会在24小时内进行核实，核实成功后，按照私人社区用户协议进行相应处罚");
                    });
                }];
                [reportSheet showInWindow];
            }
        } else if (clickedIndex == 1) {
            if (weakSelf.isSelf) {
                SHOW_ALERT(@"操作失败，不能拉黑自己");
                return ;
            } else {
                NSMutableArray *blackArr = [CYDataCache cy_ObjectForKey:SRSQBlcakUser];
                if (blackArr) {
                    [blackArr addObject:weakSelf.userModel.account];
                }else {
                    blackArr = [NSMutableArray array];
                }
                [CYDataCache cy_setObject:blackArr forKey:SRSQBlcakUser];
                [LCProgressHUD showLoading:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [LCProgressHUD hide];
                    SHOW_ALERT(@"已成功加入黑名单，社区动态列表以及广场将会屏蔽该用户，您可在设置-黑名单，管理您的黑名单列表");
                });
            }
        } else if (clickedIndex == 2){
            [weakSelf shareUser];
        }
    }];
    [sheet showInWindow];
}
- (void)shareUser {
    
    NSString *pre = SQAPI;
    NSString *shareUrl = [NSString stringWithFormat:@"%@/share?srsqaccount=%@",pre,self.account];
    
    NSString *shareTitle = @"私人社区";
    NSString *other = [NSString stringWithFormat:@"💓💓给你推荐一个%@😘",self.userModel.sex.integerValue == 1 ? @"汉子" : @"妹子"];
    NSString *shareText  = _isSelf ? @"💓💓这是我在私人社区app的主页，赶紧下载app看看吧😘" : other;
    NSString *coverUrl = self.userModel.headimgurl;
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams setObject:safityObject(coverUrl) forKey:@"image"];
    [shareParams setObject:safityObject(shareTitle) forKey:@"title"];
    [shareParams setObject:safityObject(shareUrl) forKey:@"url"];
    [shareParams setObject:safityObject(shareText) forKey:@"shareText"];
    [shareParams setObject:@"1" forKey:@"share_type"];
    
    [DTShowHudView showShareViewWithContents:shareParams successBlock:^{
        
    }];
}
@end
