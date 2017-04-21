必要框架
MediaPlayer.framework
AVFoundation.framework


#import "KrVideoPlayerController.h"

@interface ViewController ()
@property (nonatomic, strong) KrVideoPlayerController  *videoController;
@end

@implementation ViewController

- (void)viewDidLoad {
[super viewDidLoad];
// Do any additional setup after loading the view, typically from a nib.
[self playVideo];
}
- (void)playVideo{
NSURL *url = [NSURL URLWithString:@"http://krtv.qiniudn.com/150522nextapp"];
[self addVideoPlayerWithURL:url];
}

- (void)addVideoPlayerWithURL:(NSURL *)url{
if (!self.videoController) {
CGFloat width = [UIScreen mainScreen].bounds.size.width;
self.videoController = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(0, 64, width, width*(9.0/16.0))];
__weak typeof(self)weakSelf = self;
[self.videoController setDimissCompleteBlock:^{
weakSelf.videoController = nil;
}];
[self.videoController setWillBackOrientationPortrait:^{
[weakSelf toolbarHidden:NO];
}];
[self.videoController setWillChangeToFullscreenMode:^{
[weakSelf toolbarHidden:YES];
}];
[self.view addSubview:self.videoController.view];
}
self.videoController.contentURL = url;

}
//隐藏navigation tabbar 电池栏
- (void)toolbarHidden:(BOOL)Bool{
self.navigationController.navigationBar.hidden = Bool;
self.tabBarController.tabBar.hidden = Bool;
[[UIApplication sharedApplication] setStatusBarHidden:Bool withAnimation:UIStatusBarAnimationFade];
}

//---------------------------
View controller-based status bar appearance    NO
