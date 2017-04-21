//
//  DTDictionary.m
//  Cinderella
//
//  Created by mac on 15/5/30.
//  Copyright (c) 2015年 cloudstruct. All rights reserved.
//

#import "DTDictionary.h"

@implementation NSMutableDictionary (DTFramework)

- (void)setObjectIfNotNil:(id)anObject forKey:(id)aKey {
    if (anObject != nil && aKey != nil) {
        self[aKey] = anObject;
    }
}

@end

NSString *const kDefaultDTDateFormatter = @"yyyy-MM-dd HH:mm:ss";
NSString *const kDTRFC3339DateFormatter = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";
NSString *const kDTDefuaultJSONDateFormatter = @"yyyy-MM-dd'T'HH:mm:ss'Z'";

@implementation NSDictionary (DTFramework)

- (id)nonNullObjectForKey:(NSString *)key forClass:(Class)forClass {
    id value = self[key];
    if (value != nil && ![value isKindOfClass:[NSNull class]]) {
        return value;
    }
    return nil;
}

- (id)nonNullObjectForKey:(NSString *)key {
    return [self nonNullObjectForKey:key forClass:nil];
}

- (NSDate *)dateForKey:(NSString *)key withFormatter:(NSString *)dateFormatter {
    id value = [self nonNullObjectForKey:key];
    if (value) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:dateFormatter];
        value = [df dateFromString:value];
    }
    return value;
}

- (NSDictionary *)dictionaryForKeys:(NSString *)key {
    return [self nonNullObjectForKey:key forClass:[NSDictionary class]];
}

@end