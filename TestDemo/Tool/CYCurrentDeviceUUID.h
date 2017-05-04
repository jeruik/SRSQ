//
//  CYUUID.h
//  Junengwan
//
//  Created by dongzb on 16/6/8.
//  Copyright © 2016年 上海触影文化传播有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYCurrentDeviceUUID : NSObject

/**
 *  获取当前设备的唯一标示
 */
+ (NSString *_Nullable)currentUUIDString;

/**
 *  删除当前设备的唯一标示
 */
+ (BOOL)deleteCurrentUUIDString;
+ (NSString *_Nullable)getAppVersion;


@end
