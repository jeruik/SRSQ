//
//  CYNetworkError.h
//  Junengwan
//
//  Created by dongzb on 16/3/29.
//  Copyright © 2016年 上海触影文化传播有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYResponseError : NSError

/** < errorCode > */
@property (nonatomic,assign) NSInteger errorCode;

/** < errorMsg > */
@property (nonatomic,copy,nullable) NSString *errorMsg;


@end
