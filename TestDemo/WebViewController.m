//
//  WebViewController.m
//  TestDemo
//
//  Created by 小菜 on 17/3/2.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>


@interface WebViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"私人社区用户协议";
    WKWebView *web = [[WKWebView alloc] initWithFrame:self.view.bounds];
    web.backgroundColor = [UIColor whiteColor];
    web.UIDelegate = self;
    web.navigationDelegate = self;
    
    [self.view addSubview:web];
    _webView = web;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"srsqAgree.html" ofType:nil];
    
    if(path){
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            // iOS9. One year later things are OK.
            NSURL *fileURL = [NSURL fileURLWithPath:path];
            [self.webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
        } else {
        }
    }
}

- (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL {
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    // Create "/temp/www" directory
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSURL *temDirURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"www"];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    // Now copy given file to the temp directory
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    // Files in "/temp/www" load flawlesly :)
    return dstURL;
}


- (void)close {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
