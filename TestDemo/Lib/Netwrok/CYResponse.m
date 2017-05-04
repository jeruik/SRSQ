//
//  CYNetworkResponse.m
//  Junengwan
//
//  Created by dongzb on 16/3/29.
//  Copyright © 2016年 上海触影文化传播有限公司. All rights reserved.
//

#import "CYResponse.h"
#import "LCProgressHUD.h"
@implementation CYResponse

/** <提示错误信息> */
- (void)showErrorMsg
{
    if (![NSThread mainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [LCProgressHUD showStatus:LCProgressHUDStatusError text:self.desc];
        });
    }else {
        [LCProgressHUD showStatus:LCProgressHUDStatusError text:self.desc];
    }
    
}

@end
