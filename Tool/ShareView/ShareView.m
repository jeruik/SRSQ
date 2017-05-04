//
//  ShareView.m
//  Cinderella
//
//  Created by ng on 15/9/7.
//  Copyright (c) 2015年 Dantou. All rights reserved.
//

#import "ShareView.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "CYShareContentModel.h"


@interface ShareView ()
{
    NSDictionary  *_params;
    CGFloat *_bgHeight;
    UIButton *_lastShareBtn;
}
// <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 黑色的遮盖
        self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH,DEF_SCREEN_HEIGHT)];
        self.coverView.backgroundColor = [UIColor blackColor];
        self.coverView.alpha = 0;
        [self addSubview:self.coverView];

        // 放分享按钮的背景View
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, DEF_SCREEN_HEIGHT, DEF_SCREEN_WIDTH, 200)];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgView];
        
        
        // titleLabel
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,20, CDRViewWidth, 20)];
        self.titleLabel.text = @"分享";
        self.titleLabel.textColor = [UIColor lightGrayColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.bgView addSubview:self.titleLabel];
        
        
        // 分享按钮的图片
        UIImage *image1 = [UIImage imageNamed:@"share_platform_wechat"];
        UIImage *image2 = [UIImage imageNamed:@"share_platform_wechattimeline.png"];
        UIImage *image3 = [UIImage imageNamed:@"sina_log_share"];
        UIImage *image4 = [UIImage imageNamed:@"qq_log_share"];
        
        NSArray *images = @[image1,image2,image3,image4];
        NSArray *titles = @[@"微信",@"朋友圈",@"微博",@"QQ"];
        
        CGSize size = image1.size;
        CGFloat width = CDRViewWidth/titles.count;
        CGFloat height = size.height;
        for (int i =0; i<titles.count; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.tag = i+10;
            [button setImage:images[i] forState:UIControlStateNormal];
            [button setFrame:CGRectMake(i*width, [self.titleLabel bottom]+30, width, height)];

            [button addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.bgView addSubview:button];
            
            UILabel *lab = [UILabel new];
            lab.text = titles[i];
            lab.textColor = [UIColor blackColor];
            lab.font = [UIFont systemFontOfSize:13];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.frame = button.frame;
            CGFloat margin = 5;
            [lab setY:button.bottom-margin];
            [self.bgView addSubview:lab];
            _lastShareBtn = button;
        }
        // 横线
        // 取消
        self.cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancel setFrame:CGRectMake(0, _lastShareBtn.bottom + 50, CDRViewWidth, 30)];
        [self.cancel setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancel setTitleColor:RGBCOLOR(11, 80, 186) forState:UIControlStateNormal];
        [self.cancel addTarget:self action:@selector(hiddenShareView) forControlEvents:UIControlEventTouchUpInside];
        self.cancel.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:self.cancel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _cancel.top - 10 , CDRViewWidth, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        lineView.alpha = 0.5;
        [self.bgView addSubview:lineView];
        self.lineView = lineView;

    }
    return self;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

/**
 *  加载数据
 */
- (void)loadDatas {
    
    CYShareContentModel *shareTypeQQ                = [[CYShareContentModel alloc] init];
    shareTypeQQ.shareIcon                           = @"";
    shareTypeQQ.shareTitle                          = @"";
    shareTypeQQ.shareType                           = CYShareTypeQQ;
    
    
    CYShareContentModel *shareTypeWechatSession     = [[CYShareContentModel alloc] init];
    shareTypeWechatSession.shareIcon                = @"";
    shareTypeWechatSession.shareTitle               = @"";
    shareTypeWechatSession.shareType                = CYShareTypeWechatSession;
    
    CYShareContentModel *shareTypeWechatTimeLine    = [[CYShareContentModel alloc] init];
    shareTypeWechatTimeLine.shareIcon               = @"";
    shareTypeWechatTimeLine.shareTitle              = @"";
    shareTypeWechatTimeLine.shareType               = CYShareTypeWechatTimeline;
    
    CYShareContentModel *shareTypeWechatSinaWeibo   = [[CYShareContentModel alloc] init];
    shareTypeWechatSinaWeibo.shareIcon              = @"";
    shareTypeWechatSinaWeibo.shareTitle             = @"";
    shareTypeWechatSinaWeibo.shareType              = CYShareTypeSina;
    
    [self.dataArray addObject:shareTypeQQ];
    [self.dataArray addObject:shareTypeWechatSession];
    [self.dataArray addObject:shareTypeWechatTimeLine];
    [self.dataArray addObject:shareTypeWechatSinaWeibo];
    
    [self.collectionView reloadData];
}
/**
 *   弹出分享的视图
 *
 *  @param params  分享参数
 *  @param success 成功后的回调
 */
- (void)showShareView:(id)params successBlock:(void(^)())success;
{
    self.success = success;
    _shareContents = params;
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.alpha = 0.3;
        self.bgView.frame = CGRectMake(0, DEF_SCREEN_HEIGHT -200, DEF_SCREEN_WIDTH,200);
    }];
}
- (void)showShareInavitationView:(id)params successBlock:(void(^)())success;
{
    self.success = success;

    [self.coverView removeFromSuperview];
    [self.titleLabel removeFromSuperview];
    [self.cancel removeFromSuperview];
    [self.lineView removeFromSuperview];
    
    CGFloat shareLabMargin = 50;
    for (id btn in self.bgView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn setY:shareLabMargin];
        }
        else if ([btn isKindOfClass:[UILabel class]]) {
            UILabel *lab = (UILabel *)btn;
            lab.height = 0;
        }
    }
    self.bgView.frame = CGRectMake(0, 0, CDRViewWidth,300);
    UILabel *shareTitle = [UILabel new];
    shareTitle.textColor = [UIColor lightGrayColor];
    shareTitle.font = [UIFont systemFontOfSize:16];
    shareTitle.text = @"分享";
    shareTitle.textAlignment = NSTextAlignmentCenter;
    shareTitle.frame = CGRectMake(0, 0, CDRViewWidth, shareLabMargin);
    [self addSubview:shareTitle];
}

/**
 *  隐藏分享视图
 */
- (void)hiddenShareView
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.bgView setFrame:CGRectMake(0, DEF_SCREEN_HEIGHT, DEF_SCREEN_WIDTH, 200)];
    }completion:^(BOOL finished)
    {
        [self removeFromSuperview];
    }];
}
/**
 *  点击遮盖处移除分享的界面
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.bgView.height == 120) return;
    [self hiddenShareView];
}


- (void)shareBtnClick:(UIButton*)button {

    NSString *url       = [self.shareContents[@"url"] length]>0?self.shareContents[@"url"]:@"https://srsq.herokuapp.com/";
    NSString *text      = [self.shareContents[@"shareText"] length]>0?self.shareContents[@"shareText"]:@"srsq社区精选";
    NSString *title     = [self.shareContents[@"title"]length]>0?self.shareContents[@"title"]:@"私人社区";
    // 分享的图片 iamge 对象
    NSString *image_url = self.shareContents[@"image"];

    UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:image_url];
    if (!image) {
        image = [UIImage imageNamed:@"share"];
    }
    if (text.length>100) {
        text = [text stringByReplacingCharactersInRange:NSMakeRange(100, text.length-100) withString:@"..."];
    }
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:text
                                     images:image
                                        url:[NSURL URLWithString:url]
                                      title:title
                                       type:SSDKContentTypeAuto];
    
    SSDKPlatformType type = 0;
    switch (button.tag) {
        case 10:
            type = SSDKPlatformSubTypeWechatSession;
            break;
        case 11:
            type = SSDKPlatformSubTypeWechatTimeline;
            break;
        case 12:
            type = SSDKPlatformTypeSinaWeibo;
            break;
        case 13:
            type = SSDKPlatformSubTypeQQFriend;
            break;
    }
    

    @weakify(self);
    //2、分享
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        @strongify(self);
     
        switch (state) {
            case SSDKResponseStateCancel:
                //   [LCProgressHUD showStatus:LCProgressHUDStatusSuccess text:@"取消分享"];
            case SSDKResponseStateFail:
                // [LCProgressHUD showStatus:LCProgressHUDStatusSuccess text:@"分享失败"];
                break;
            case SSDKResponseStateSuccess :
            {
                [LCProgressHUD showStatus:LCProgressHUDStatusSuccess text:@"分享成功"];
                if (self.success) {
                    self.success();
                }
            }
                break;
            default:
                break;
        }
    }];
    

    [self hiddenShareView];

}

@end
