//
//  CYDataCache.h
//  Junengwan
//
//  Created by 董招兵 on 16/6/24.
//  Copyright © 2016年 上海触影文化传播有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYCache.h"

NSString* _Nullable  CY_CahceDataPath();

@interface CYDataCache : NSObject
/**
 *  根据文件名拼接一个路径
 *
 *  @param object 保存的对象
 *  @param key    文件名
 */
+ (void)cy_setObject:(id _Nullable)object forKey:(NSString *_Nonnull)key;

/**
 *  根据文件名读取数据
 *
 *  @param key 文件名
 *
 *  @return 返回一个对象
 */
+ (id _Nullable)cy_ObjectForKey:(NSString *_Nonnull)key;

/**
 *  根据文件名删除文件
 *
 *  @param key 文件名
 */
+ (void)removeObjectForKey:(NSString *_Nonnull)key;

- (instancetype _Nullable)init UNAVAILABLE_ATTRIBUTE;

+ (instancetype _Nullable) new UNAVAILABLE_ATTRIBUTE;

@end
