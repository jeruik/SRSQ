//
//  SQReleaseActController.m
//  TestDemo
//
//  Created by 小菜 on 17/2/23.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "SQReleaseActController.h"
#import "CYTextInputView.h"
#import "EmotionKeyboard.h"
#import "Const.h"
#import "SendStatusPhotoView.h"
#import "MLSelectPhotoAssets.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "MLSelectPhotoBrowserViewController.h"
#import "UIImage+ImageCut.h"
#import "CYUserAlbumView.h"
#import "INTULocationManager.h"
#import "UploadImageTool.h"
#import "JSONKit.h"
#import "SendStatusToolbar.h"
#import "EmotionTextView.h"

@interface SQReleaseActController ()<UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,SendStatusToolbarDelegate>


@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic , strong) NSMutableArray<UIImage *> *assets;

@property (nonatomic, weak) SendStatusPhotoView *photoView;
@property (nonatomic, weak) EmotionTextView *textView;
@property (nonatomic, strong) EmotionKeyboard *keyboard;
@property (nonatomic, strong) SendStatusToolbar *toolbar;
@property (nonatomic, strong) NSString *city;
/** 是否正在切换键盘 */
@property (nonatomic, assign) BOOL switchingKeybaord;
@end

@implementation SQReleaseActController
- (NSMutableArray *)assets{
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}
/**
 * 懒加载 保证只创建一次
 */
- (EmotionKeyboard *)keyboard
{
    if (!_keyboard) {
        _keyboard = [[EmotionKeyboard alloc] initWithFrame:FRAME(0, 0, self.view.width, 216)];
    }
    return _keyboard;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"动态发布";
    self.maxCount = 9;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(releaseAct)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    [self setupTextView];
    [self setupPhotosView];
    [self location];
    [self setupToolBar];

}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Action
- (void)location {
    WEAKSELF
    [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
                                                                     timeout:10.0
                                                        delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
                                                                       block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                                                           if (status == INTULocationStatusSuccess) {
                                                                               CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                                                                               // 反向地理编译出地址信息
                                                                               [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                                                                                   if (! error) {
                                                                                       if ([placemarks count] > 0) {
                                                                                           CLPlacemark *placemark = [placemarks firstObject];
                                                                                           
                                                                                           // 获取城市
                                                                                           NSString *city = placemark.locality;
                                                                                           if (! city) {
                                                                                               city = placemark.administrativeArea;
                                                                                           }
                                                                                           weakSelf.city = [NSString stringWithFormat:@"%@%@",placemark.administrativeArea,placemark.subLocality];
                                                                                       }
                                                                                   }
                                                                               }];
                                                                           }
                                                                       }];
}
- (void)back{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - 选择相册
- (void)selectPhotos {
#define FIRST_DRU 0.15
#define SEC_DUR 0.2
#define LAST_DUR 0.15
    
#define SPRING 10.0
#define VELOCITY 20.0
#define SCALE 0.99
    [self.textView endEditing:YES];
    WEAKSELF
    CYUserAlbumView *gift = [[CYUserAlbumView alloc] initWithFrame:[UIScreen mainScreen].bounds withButtonCount:2];
    gift.tag = 9999;
    gift.btnClickBlock = ^(NSInteger index,UIImageView *img) {
        if (index == 0) {
            [weakSelf openCamera];
        }else {
            [weakSelf selectPhoto];
        }
    };
    [[AppDelegate appDelegate].window addSubview:gift];
    
    [UIView animateWithDuration:FIRST_DRU delay:0 usingSpringWithDamping:SPRING initialSpringVelocity:VELOCITY options:UIViewAnimationOptionCurveEaseInOut animations:^{
        gift.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:SEC_DUR animations:^{
            gift.contentView.transform = CGAffineTransformMakeScale(SCALE, SCALE);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:LAST_DUR animations:^{
                gift.contentView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
            }];
        }];
    }];
}
- (void)selectPhoto {
    
    NSInteger maxPhotos = self.maxCount;
    if (self.assets.count >= maxPhotos) {
        NSString *str = [NSString stringWithFormat:@"一次最多只能上传%ld张哦~",self.maxCount];
        SHOW_ALERT(str);
        return;
    }
    
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    pickerVc.topShowPhotoPicker = YES;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = maxPhotos - self.assets.count;
    [pickerVc showPickerVc:self];
    
    WEAKSELF
    pickerVc.callBack = ^(NSArray *assets){ //图片装在数组里面
        
        if(weakSelf.assets.count < weakSelf.maxCount) {
            [weakSelf.photoView removeAllSubviews];
            NSMutableArray *temp = [NSMutableArray array];
            for (int i = 0; i<assets.count; i++) {
                MLSelectPhotoAssets *asset = assets[i];
                UIImage *image = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
                [temp addObject:image];
            }
            [weakSelf.assets addObjectsFromArray:temp];
            for (int i = 0; i < weakSelf.assets.count; i++) {
                [weakSelf.photoView addPhoto:weakSelf.assets[i] tag:i];
            }
            if (weakSelf.photoView.subviews.count == 0) {
                [weakSelf.photoView addSubview:weakSelf.photoView.addBtn];
            }
        }
    };
}
#pragma mark - 初始化
/**
 * 添加输入控件
 */
- (void)setupTextView {
    
    // 在这个控制器中，textView的contentInset.top默认会等于64
    EmotionTextView *textView = [[EmotionTextView alloc] init];
    // 垂直方向上永远可以拖拽（有弹簧效果）
    textView.alwaysBounceVertical = YES;
    textView.frame = self.view.bounds;
    textView.height = 268;
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeholder = @"写点什么吧";
    textView.delegate = self;
    [self.view addSubview:textView];
    
    self.textView = textView;
    
    [[self.textView.rac_textSignal map:^id(NSString *text) {
        return @(text.length > 250);
    }] subscribeNext:^(NSNumber *value) {
        if (value.boolValue) {
            SHOW_ALERT(@"内容长度限制在250个字符内");
            self.textView.text = [self.textView.text substringToIndex:250];
        }
    }];
    
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    //键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //表情选中的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionSeletct:) name:EmotionDidSelectNotification object:nil];
    
    //删除文字通知 （接收通知）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDelete) name:EmotionDidDeleteNotification object:nil];
}
/**
 * 添加相册
 */
- (void)setupPhotosView {
    
    SendStatusPhotoView *photoView = [[SendStatusPhotoView alloc] initWithFrame:self.textView.bounds];
    [self.view addSubview:photoView];
    self.photoView = photoView;
    
    photoView.y = self.textView.bottom;
    photoView.backgroundColor = [UIColor whiteColor];
    CGFloat imageWH = (self.view.width - (4+1) * 10)/4;
    photoView.height = imageWH + 20;
    WEAKSELF
    photoView.imageViewClickBlock = ^(UIImageView *imageView){
       
    };
    photoView.addBtnClickBlock = ^{
        [weakSelf selectPhotos];
    };
    
    photoView.subViewChangeBlock = ^(NSInteger row){
        weakSelf.photoView.height = (row)*imageWH + 10*(row+1);
    };
}
- (void)setupToolBar {
    SendStatusToolbar *toolbar = [[SendStatusToolbar alloc] init];
    toolbar.width = self.view.width;
    toolbar.height = 44;
    toolbar.y = self.view.height - toolbar.height;
    toolbar.delegate = self;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
}
- (void)emotionClick {
    if (self.textView.inputView == nil) {  //意味着使用系统键盘
        self.textView.inputView = self.keyboard;
    } else {
        self.textView.inputView = nil;
    }
    //退出键盘
    [self.textView endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //弹出键盘
        [self.textView becomeFirstResponder];
    });
}
#pragma mark - 监听方法
/**
 * 键盘的frame发生改变时调用（显示、隐藏等）
 */
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    // 如果正在切换键盘，就不要执行后面的代码 如果switchingKeybaord 为yes 意味着正在切换键盘，直接返回，不要调整尺寸
    if (self.switchingKeybaord) return;
    
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //执行动画
    [UIView animateWithDuration:duration animations:^{
        if (keyboardF.origin.y > self.view.height) { //键盘位置已经超出屏幕
            self.toolbar.y = self.view.height - self.toolbar.height;
        } else {
            self.toolbar.y = keyboardF.origin.y - self.toolbar.height;
        }
    }];
    
    //    CLYLog(@"%@",notification.userInfo);
}
#pragma mark SendStatusToolbar代理方法

- (void)sendStatusToolbar:(SendStatusToolbar *)toolbar didclickButton:(SendStatusToolbarButtonType)buttonType
{
    switch (buttonType) {
        case SendStatusToolbarButtonTypeCamera: // 拍照
            [self openCamera];
            break;
            
        case SendStatusToolbarButtonTypePicture: // 相册
            [self selectPhoto];
            break;
            
        case SendStatusToolbarButtonTypeMention: // @
            
            break;
            
        case SendStatusToolbarButtonTypeTrend: // #
            
            break;
            
        case SendStatusoolbarButtonTypeEmotion: // 表情\键盘
            [self switchKeyboard];
            break;
    }
}
- (void)switchKeyboard
{
    if (self.textView.inputView == nil) {  //意味着使用系统键盘
        self.textView.inputView = self.keyboard;
        //显示键盘按钮
        self.toolbar.showKeyboardButton = YES;
    } else {
        self.textView.inputView = nil;
        
        self.toolbar.showKeyboardButton = NO;
    }
    //开始切换键盘
    self.switchingKeybaord = YES;
    
    //退出键盘
    [self.textView endEditing:YES];
    
    //结束键盘切换
    self.switchingKeybaord = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //弹出键盘
        [self.textView becomeFirstResponder];
    });
}
/**
 * 删除文字
 */
- (void)emotionDidDelete
{
    //    CLYLog(@"emotionDidDelete");
    [self.textView deleteBackward];
}

/**
 *  表情被选中了
 */
- (void)emotionSeletct:(NSNotification *)notification
{
    //通过通知对应的key取出对应的模型
    EmotionModel *emotion = notification.userInfo[SelectEmotionKey];
    [self.textView insertEmotion:emotion];
}
- (void)openCamera
{
    NSInteger maxPhotos = self.maxCount;
    if (self.assets.count >= maxPhotos) {
        NSString *str = [NSString stringWithFormat:@"一次最多只能上传%ld张哦~",self.maxCount];
        SHOW_ALERT(str);
        return;
    }
    
    //相机不可用直接返回
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
    
    UIImagePickerController *pic = [[UIImagePickerController alloc] init];
    pic.sourceType = UIImagePickerControllerSourceTypeCamera;
    pic.delegate = self;
    [self presentViewController:pic animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate  代理方法，拍照后的处理
/**
 * 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    CGSize scaleSize = [UIImage getScaleImageFromSize:image.size width:DEF_SCREEN_WIDTH];
    image = [image imageCompressForSize:image targetSize:scaleSize];
    
    [self.assets addObject:image];
    [self.photoView removeAllSubviews];
    for (int i = 0; i < self.assets.count; i++) {
        [self.photoView addPhoto:self.assets[i] tag:i];
    }
    if (self.photoView.subviews.count == 0) {
        [self.photoView addSubview:self.photoView.addBtn];
    }
}
#pragma mark - actions
/**
 * 监听文字改变
 */
- (void)textDidChange {
    
}
- (void)releaseAct {
    [self.view endEditing:YES];
    if (self.textView.fullText.length == 0) {
        [LCProgressHUD showFailure:@"请输入文字"];
        return;
    }
    WEAKSELF
    
    void(^sendActBlock)(NSArray *) = ^(NSArray *urlArr){
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSTimeInterval start = [currentDate timeIntervalSince1970]*1000;
        NSString *num = [NSString stringWithFormat:@"%.f",start];
        CGSize imgWH = CGSizeMake(0, 0);
        if (weakSelf.assets.count == 1) {
            UIImage *img = weakSelf.assets.firstObject;
            imgWH.width = img.size.width / 2;
            imgWH.height = img.size.height / 2;
        }
        NSString *photos = urlArr.count > 0 ? [urlArr JSONString] : @"1";
        NSDictionary *dict = @{
                               @"account": [SQUser sharedUser].account,
                               @"token": [SQUser sharedUser].token,
                               @"actcontent": self.textView.fullText,
                               @"acttime": num,
                               @"commoncount": @(0),
                               @"headimgurl": [SQUser sharedUser].headimgurl,
                               @"photostr": photos,
                               @"sex": [SQUser sharedUser].sex,
                               @"sqlocal": self.city ? self.city : @"未知",
                               @"username": [SQUser sharedUser].username,
                               @"zancount": @(0),
                               @"rcuserid": [SQUser sharedUser].rcuserid,
                               @"width" : @(imgWH.width),
                               @"height" : @(imgWH.height)
                               };
        [[CYNetworkManager manager].httpSessionManager POST:DEF_ACT_Release parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            LxDBAnyVar(responseObject);
            [SVProgressHUD dismiss];
            NSString *code = responseObject[@"result"];
            if (code.integerValue == 0) {
                [LCProgressHUD showSuccess:@"发布成功"];
            } else {
                [LCProgressHUD showSuccess:@"发布失败"];
            }
            if (weakSelf.releaseBlock) {
                weakSelf.releaseBlock();
            }
            [weakSelf back];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            [LCProgressHUD showFailure:error.localizedFailureReason];
        }];

    };
    
    [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    if (self.assets.count > 0) {
        [UploadImageTool uploadImages:self.assets progress:^(CGFloat progress) {
            [SVProgressHUD showProgress:progress status:[NSString stringWithFormat:@"正在发布"]];
        } success:^(NSArray *urlArr) {
            sendActBlock(urlArr);
        } failure:^{
            
        } type:NO];
    } else {
        sendActBlock(@[]);
    }
}
#pragma mark - UITextViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
