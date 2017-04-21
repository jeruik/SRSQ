//
//  DTSandboxHelper.h
//  Cinderella
//
//  Created by mac on 15/8/16.
//  Copyright (c) 2015年 Dantou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTSandbox : NSObject
+ (NSString *)homePath;     // 程序主目录，可见子目录(3个):Documents、Library、tmp
+ (NSString *)appPath;        // 程序目录，不能存任何东西
+ (NSString *)docPath;        // 文档目录，需要ITUNES同步备份的数据存这里，可存放用户数据
+ (NSString *)libPrefPath;    // 配置目录，配置文件存这里
+ (NSString *)libCachePath;    // 缓存目录，系统永远不会删除这里的文件，ITUNES会删除
+ (NSString *)tmpPath;        // 临时缓存目录，APP退出后，系统可能会删除这里的内容
+ (BOOL)hasExistsAtPath:(NSString *)path; //判断目录是否存在，不存在则创建
+ (BOOL)hasExistsAtPathOrCreate:(NSString *)path; //判断目录是否存在，不存在则创建


+ (DTSandbox*)sharedInstance;
+ (float)fileSizeAtPath:(NSString *)path;
+ (float)folderSizeAtPath:(NSString *)path;

+ (void)clearCache;
+ (float)cacheSize;


- (NSString*)messageCachePathByObjectId:(NSString*)objectId;
- (NSString*)archivePathOfFile:(NSString*)fileName;

@end
