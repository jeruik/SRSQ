//
//  CYNetworkResponse.h
//  Junengwan
//
//  Created by dongzb on 16/3/29.
//  Copyright © 2016年 上海触影文化传播有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYResponse : NSObject

/** <提示错误信息> */
- (void)showErrorMsg;

/** < result > */
@property (nonatomic,assign) NSInteger result;

/** < Desc > */
@property (nonatomic,copy,nullable) NSString *desc;

/** < data > */ // 直接返回参数字典字段名为 Data
@property (nonatomic,strong,nullable) NSDictionary *data;

/** < responseData > */ //  没有Data字段 用responseData 取值
@property (nonatomic,assign,nullable) NSDictionary *responseData;


@end
