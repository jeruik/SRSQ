//
//  DTObject.m
//  Cinderella
//
//  Created by mac on 15/5/30.
//  Copyright (c) 2015年 cloudstruct. All rights reserved.
//

#import "DTFramework.h"
#import "DTDictionary.h"
#import <objc/runtime.h>

static char const *const kDTUserDictionaryKey = "kDTUserDictionaryKey";

@implementation NSObject (DTFramework)

id is_null(id A, id B) {
    if (!A || [[NSNull null] isEqual:A]) {
        return B;
    } else {
        return A;
    }
    return nil;
}

- (void)attachUserInfo:(id)userInfo {
    objc_setAssociatedObject(self, kDTUserDictionaryKey, userInfo, OBJC_ASSOCIATION_RETAIN);
}

- (id)userInfo {
    return objc_getAssociatedObject(self, kDTUserDictionaryKey);
}

- (void)attachUserInfo:(id)userInfo forKey:(const char *)key {
    if (key != nil) {
        objc_setAssociatedObject(self, key, userInfo, OBJC_ASSOCIATION_RETAIN);
    }
}

- (id)userInfoForKey:(const char *)key {
    if (key != nil) {
        return objc_getAssociatedObject(self, key);
    } else {
        return nil;
    }
}

- (id)initFromDictionary:(NSDictionary *)dictionary {
    return [self initFromDictionary:dictionary dateFormatter:[NSDateFormatter DTDefaultDateFormatter]];
}

- (id)initFromDictionary:(NSDictionary *)dictionary dateFormatter:(NSDateFormatter *)dateFormatter {
    self = [self init];
    if (self != nil) {
        NSDictionary *propDefs = [self DTPropertyDefinitions];

        if (propDefs && dictionary) {
            NSArray *propKeys = [propDefs allKeys];
            if (propKeys) {
                for (NSString *key in propKeys) {
                    id value = dictionary[key];

                    if ([value isKindOfClass:[NSNull class]]) {
                        value = nil;
                    }

                    if ([@"NSDate" isEqualToString:[propDefs valueForKey:key]]) {
                        value = [dateFormatter dateFromString:value];
                    }

                    [self setValue:value forKey:key];
                }
            }
        }
    }
    return self;
}

- (id)updateDataWithDictionary:(NSDictionary *)dictionary {
    return [self updateDataWithDictionary:dictionary dateFormatter:[NSDateFormatter DTDefaultDateFormatter]];
}

- (id)updateDataWithDictionary:(NSDictionary *)dictionary dateFormatter:(NSDateFormatter *)dateFormatter {
    if (self != nil) {
        NSDictionary *propDefs = [self DTPropertyDefinitions];

        if (propDefs && dictionary) {
            NSArray *propKeys = [propDefs allKeys];
            if (propKeys) {
                for (NSString *key in propKeys) {
                    id value = [self getValueForKey:key fromDictionary:dictionary propertiesArray:propDefs andDateFormatter:dateFormatter];
                    if (value == nil) {
                        char *ivarPropertyName = property_copyAttributeValue((__bridge objc_property_t) (key), "V");
                        if (ivarPropertyName != NULL) {
                            NSString *ivarName = @(ivarPropertyName);
                            value = [self getValueForKey:ivarName fromDictionary:dictionary propertiesArray:propDefs andDateFormatter:dateFormatter];
                        }
                        free(ivarPropertyName);
                    }
                    [self setValue:value forKey:key];
                }
            }
        }
    }
    return self;
}

- (id)getValueForKey:(NSString *)key fromDictionary:(NSDictionary *)dictionary propertiesArray:(NSDictionary *)propDefs andDateFormatter:(NSDateFormatter *)dateFormatter {
    NSString *propertyClassString = propDefs[key];
    Class propertyClass = NSClassFromString(propertyClassString);
    id value = dictionary[key];

    if ([value isKindOfClass:[NSNull class]] || !value
            || [value isKindOfClass:[NSDictionary class]]) {
        value = nil;
    }
    else if ([propertyClass isSubclassOfClass:[NSString class]]
            && [value isKindOfClass:[NSNumber class]]) {
        // number converted into a string.
        value = [value stringValue];
    }
    else if ([propertyClass isSubclassOfClass:[NSNumber class]]
            && [value isKindOfClass:[NSString class]]) {
        // String converted into a number.  We can't tell what its
        // intention ls (float, integer, etc), so let the number
        // formatter make a best guess for us.
        NSNumberFormatter *numberFormatter = [NSNumberFormatter sharedInstance];
        value = [numberFormatter numberFromString:value];
    }
    else if (dateFormatter
            && [propertyClass isSubclassOfClass:[NSDate class]]
            && [value isKindOfClass:[NSString class]]) {
        // If the caller provided a date formatter, try converting
        // the date into a string.
        value = [dateFormatter dateFromString:value];
    }
    return value;
}

- (NSDictionary *)DTPropertyDefinitions {
    NSMutableDictionary *propDefs = [NSMutableDictionary dictionary];
    unsigned int count;

    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *propName = @(property_getName(property));
        NSString *attrs = @(property_getAttributes(property));
        NSArray *attrParts = [attrs componentsSeparatedByString:@","];
        if (attrParts != nil && attrParts.count > 0) {
            NSString *className = [attrParts[0] substringFromIndex:1];
            className = [className stringByReplacingOccurrencesOfString:@"@" withString:@""];
            className = [className stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            propDefs[propName] = className;
        }
    }
    free(properties);
    return [NSDictionary dictionaryWithDictionary:propDefs];
}

@end

@implementation NSTimer (DTTimerBlocks)

+ (void)invokeBlock:(NSTimer *)timer {
    if (timer.userInfo) {
        void (^block)() = (void (^)()) timer.userInfo;
        if (block) {
            block();
        }
    }
}

+ (NSTimer *)delay:(NSTimeInterval)timeInterval andExecuteBlock:(void (^)(void))block {
    return [self scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(invokeBlock:) userInfo:block repeats:NO];
}

@end

@implementation NSDateFormatter (DTFramework)

+ (NSDateFormatter *)DTDefaultDateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDTRFC3339DateFormatter];
    return dateFormatter;
}

+ (NSDateFormatter *)DTDefaultJSONDateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:kDTDefuaultJSONDateFormatter];
    return dateFormatter;
}

@end

@implementation NSNumberFormatter (DTFramework)

+ (NSNumberFormatter *)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance setNumberStyle:NSNumberFormatterDecimalStyle];
    });
    return sharedInstance;
}

@end