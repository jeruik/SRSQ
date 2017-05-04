//
//  NSObject+IvarNull.h
//  剧能玩2.1
//
//  Created by dzb on 15/11/16.
//  Copyright © 2015年 刘森. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSObject (IvarNull)
/**
 *  检查成员变量是否为空
 */
- (instancetype _Nullable)checkMemberNull;

/**
 *  过滤掉模型里 null 的属性 为""
 */
_Nullable id  safityCheckMemberValueNull(id _Nullable object);

/**
 *  根据字典里边非 null 的值来替换掉模型对应的属性名称
 */
- (instancetype _Nullable)replaceNotNullValueWithKeyValues:(NSDictionary *_Nullable)keyValues;

- (void)allKeyValuesSetNull;


@end


@interface NSDictionary (valueNull)

/**
 *  检查字典里空值
 */
- (NSDictionary *_Nullable)checkValueNull;

@end


@interface NSData (DataBase64)


- (NSString *_Nullable)dataBase64Sting;


@end
