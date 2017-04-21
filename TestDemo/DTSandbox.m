//
//  DTSandboxHelper.m
//  Cinderella
//
//  Created by mac on 15/8/16.
//  Copyright (c) 2015年 Dantou. All rights reserved.
//

#import "DTSandbox.h"
#import "SDImageCache.h"
@interface DTSandbox()
@property(nonatomic, strong) NSString* messageCahcePath;
@property(nonatomic, strong) NSString* archivePath;
@end

@implementation DTSandbox
+ (NSString *)homePath{
    return NSHomeDirectory();
}

+ (NSString *)appPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)docPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)libPrefPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preference"];
}

+ (NSString *)libCachePath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
}

+ (NSString *)tmpPath
{return [NSHomeDirectory() stringByAppendingFormat:@"/tmp"];
}

+ (BOOL)hasExistsAtPathOrCreate:(NSString *)path
{
    if ([DTSandbox hasExistsAtPath:path] ){
        return YES;
    }else{
        return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }
}

+ (BOOL)hasExistsAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

static DTSandbox * sharedInstance = nil;
+(DTSandbox*)sharedInstance{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedInstance = [[DTSandbox alloc] init];
    });
    return sharedInstance;
}

+(float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize = 0.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[DTSandbox fileSizeAtPath:absolutePath];
        }
        return folderSize;
    }
    return 0.0;
}

+(float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

+(void)clearCache{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSArray* paths = @[[DTSandbox docPath], [DTSandbox libCachePath], [DTSandbox tmpPath]];
    for (NSString *path in paths) {
        if ([fileManager fileExistsAtPath:path]) {
            NSArray *childerFiles=[fileManager subpathsAtPath:path];
            for (NSString *fileName in childerFiles) {
                NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
                [fileManager removeItemAtPath:absolutePath error:nil];
            }
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}

+(float)cacheSize{
    NSArray* paths = @[
                       [DTSandbox docPath]
                       ,[DTSandbox libCachePath]
                       ,[DTSandbox tmpPath]
                       ];
    float size = 0;
    for (NSString *path in paths) {
        size += [DTSandbox folderSizeAtPath:path];
    }
    //size += [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;;
    return size;
}

- (id)init {
    self = [super init];
    if (self) {
        self.messageCahcePath = [[DTSandbox docPath] stringByAppendingString:@"/messageCache"];
        self.archivePath = [[DTSandbox docPath] stringByAppendingString:@"/archive"];
        [DTSandbox createDir:self.messageCahcePath];
        [DTSandbox createDir:self.archivePath];
        
    }
    return self;
}

+(void)createDir:(NSString*)dir{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL isDir = YES;
    if ([fileManager fileExistsAtPath:dir isDirectory:&isDir] == NO) {
        [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            [NSException raise:@"error when create dir" format:@"error"];
        }
    }
}

- (NSString*)messageCachePathByObjectId:(NSString*)objectId{
    return [self.messageCahcePath stringByAppendingPathComponent:objectId];
}

- (NSString*)archivePathOfFile:(NSString*)fileName{
    return [self.archivePath stringByAppendingPathComponent:fileName];
}

@end
