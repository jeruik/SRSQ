//
//  CYUUID.m
//  Junengwan
//
//  Created by dongzb on 16/6/8.
//  Copyright © 2016年 上海触影文化传播有限公司. All rights reserved.
//

#import "CYCurrentDeviceUUID.h"
#import "SSKeychain.h"
#import "NSString+Extension.h"
static NSString *const KCurrentDeviceUUID       = @"KCurrentDeviceUUID";
static NSString *const KCurrentDeviceAccount    = @"junengwanTVUUID";

@implementation CYCurrentDeviceUUID

/**
 *  获取当前设备的唯一标示
 */
+ (NSString *_Nullable)currentUUIDString  {

    NSString *lastUUID = [SSKeychain passwordForService:KCurrentDeviceUUID account:KCurrentDeviceAccount];
    if (!lastUUID) {
        lastUUID = [[[NSUUID UUID] UUIDString] md5];
        [SSKeychain setPassword:lastUUID forService:KCurrentDeviceUUID account:KCurrentDeviceAccount];
    }
    return lastUUID;
}

/**
 *  删除当前设备的唯一标示
 */
+ (BOOL)deleteCurrentUUIDString {
    NSError *error = nil;
    return [SSKeychain deletePasswordForService:KCurrentDeviceUUID account:KCurrentDeviceAccount error:&error];
}

+ (NSString *_Nullable)getAppVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
