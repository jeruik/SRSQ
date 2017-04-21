//
//  DTDictionary.h
//  Cinderella
//
//  Created by mac on 15/5/30.
//  Copyright (c) 2015年 cloudstruct. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (DTFramework)

- (void)setObjectIfNotNil:(id)anObject forKey:(id)aKey;

@end

extern NSString *const kDefaultDTDateFormatter;
extern NSString *const kDTRFC3339DateFormatter;
extern NSString *const kDTDefuaultJSONDateFormatter;

@interface NSDictionary (DTFramework)

- (id)nonNullObjectForKey:(NSString *)key;

- (NSDate *)dateForKey:(NSString *)key withFormatter:(NSString *)dateFormatter;

- (NSDictionary *)dictionaryForKeys:(NSString *)key;

@end
