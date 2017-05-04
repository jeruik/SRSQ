//
//  CYDataCache.m
//  Junengwan
//
//  Created by 董招兵 on 16/6/24.
//  Copyright © 2016年 上海触影文化传播有限公司. All rights reserved.
//

#import "CYDataCache.h"



@implementation CYDataCache

 NSString* _Nullable  CY_CahceDataPath() {
     return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"/CYCache"];
}

+ (void)cy_setObject:(id _Nullable)object forKey:(NSString *_Nonnull)key {
    if (!object || !key) return;
    [[self currentCache] setObject:object forKey:key];
}

+ (id _Nullable)cy_ObjectForKey:(NSString *_Nonnull)key {
    if (!key) return nil;
    return [[self currentCache] objectForKey:key];
}

+ (void)removeObjectForKey:(NSString *_Nonnull)key {
    if (!key) return ;
    [[self currentCache] removeObjectForKey:key];
}

+ (YYCache *)currentCache {
    
    YYCache *yyCache = [[YYCache alloc] initWithPath:CY_CahceDataPath()];
    yyCache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    yyCache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    return yyCache;
    
}



@end
