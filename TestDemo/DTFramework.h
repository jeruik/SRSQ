//
//  DTObject.h
//  Cinderella
//
//  Created by mac on 15/5/30.
//  Copyright (c) 2015年 cloudstruct. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DTFramework)

- (void)attachUserInfo:(id)userInfo;

- (id)userInfo;

- (void)attachUserInfo:(id)userInfo forKey:(char const *)key;

- (id)userInfoForKey:(char const *)key;

- (id)initFromDictionary:(NSDictionary *)dictionary;

- (id)initFromDictionary:(NSDictionary *)dictionary dateFormatter:(NSDateFormatter *)dateFormatter;

- (id)updateDataWithDictionary:(NSDictionary *)dictionary;

- (id)updateDataWithDictionary:(NSDictionary *)dictionary dateFormatter:(NSDateFormatter *)dateFormatter;

id is_null(id A, id B);


@end

@interface NSTimer (DTTimerBlocks)

+ (NSTimer *)delay:(NSTimeInterval)timeInterval andExecuteBlock:(void (^)(void))block;

@end

@interface NSDateFormatter (DTFramework)

+ (NSDateFormatter *)DTDefaultDateFormatter;

+ (NSDateFormatter *)DTDefaultJSONDateFormatter;

@end

@interface NSNotificationCenter (DTFramework)

- (void)DTPostNotificationName:(NSString *)aName object:(id)anObject withDelay:(NSTimeInterval)delay;

@end

@interface NSNumberFormatter (DTFramework)

+ (NSNumberFormatter *)sharedInstance;

@end
