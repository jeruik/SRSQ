//
//  NSObject+IvarNull.m
//  剧能玩2.1
//
//  Created by dzb on 15/11/16.
//  Copyright © 2015年 刘森. All rights reserved.
//

#import "NSObject+IvarNull.h"
#import <objc/runtime.h>
@implementation NSObject (IvarNull)

/**
 *  检查成员变量是否为空
 */
- (instancetype)checkMemberNull
{
    return safityCheckMemberValueNull(self);
}

- (void)allKeyValuesSetNull {
    
    unsigned count = 0;
    Ivar  *ivars = class_copyIvarList([self class], &count);
    for (int i =0; i<count; i++) {
        Ivar  var = ivars[i];
        const char *name = ivar_getName(var);
        NSString *key = [NSString stringWithFormat:@"%s",name];
        [self setValue:nil forKey:key];
        id value = [self valueForKey:key];
        value = nil;
    }
    
    free(ivars);
}

id  safityCheckMemberValueNull(id object) {
    if (!object) return nil;
    unsigned count = 0;
    Ivar  *ivars = class_copyIvarList([object class], &count);
    for (int i =0; i<count; i++) {
        Ivar  var = ivars[i];
        const char *name = ivar_getName(var);
        NSString *key = [NSString stringWithFormat:@"%s",name];
        id value = [object valueForKeyPath:key];
        @try {
            if (!value) {
                value = @"";
            }
            [object setValue:value forKey:key];
        }
        @catch (NSException *exception) {
            DTLog(@"exception:%@", exception);
        }
        @finally {
            
        }
    }
    return object;
}

/**
 *  根据字典里边非 null 的值来替换掉模型对应的属性名称
 */
- (instancetype)replaceNotNullValueWithKeyValues:(NSDictionary *)keyValues {
    unsigned count = 0;
    Ivar  *ivars = class_copyIvarList([self class], &count);
    for (int i =0; i<count; i++) {
        Ivar  var = ivars[i];
        const char *name = ivar_getName(var);
        NSString *key = [NSString stringWithFormat:@"%s",name];
        NSString *firstChar = [key substringToIndex:1];
        NSRange range = [key rangeOfString:firstChar];
        if (range.location != NSNotFound) {
           key = [key stringByReplacingCharactersInRange:range withString:@""];
        }
        id dictValue = keyValues[key];
        if ([dictValue isKindOfClass:[NSString class]]) {
            if ([dictValue isEqualToString:@""]) {
                continue;
            }
        }
        if (dictValue) {
            [self setValue:dictValue forKey:key];
        }
    }
    return self;
}

@end

@implementation NSDictionary (valueNull)

- (NSDictionary*)checkValueNull
{
   __block NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:self];
    
    [mutableDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        @try{
            if (obj == [NSNull null]||obj==nil) {
                obj = @"";
            }else if ([obj isKindOfClass:[NSNumber class]]){
                obj = [NSString stringWithFormat:@"%@",obj];
            }
            [mutableDict setValue:obj forKey:key];
        }
        @catch(NSException *exception) {
            DTLog(@"exception:%@", exception);
        }
        @finally {
            
        }
    }];
    return mutableDict;
}

@end


@implementation NSData (DataBase64)


- (NSString *_Nullable)dataBase64Sting {
    
    const uint8_t* input = (const uint8_t*)[self bytes];
    NSUInteger length = [self length];
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    NSUInteger i,i2;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        for (i2=0; i2<3; i2++) {
            value <<= 8;
            if (i+i2 < length) {
                value |= (0xFF & input[i+i2]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    (uint8_t)table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    (uint8_t)table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? (uint8_t)table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? (uint8_t)table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
}

@end


