//
//  CYShareContentModel.h
//  Junengwan
//
//  Created by dongzb on 16/5/20.
//  Copyright © 2016年 上海触影文化传播有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,CYShareType) {
    CYShareTypeQQ = 0,
    CYShareTypeSina = 1,
    CYShareTypeWechatSession = 2,
    CYShareTypeWechatTimeline = 3
};

/**
 *  分享的模型
 */
@interface CYShareContentModel : NSObject

/** < text > */
@property (nonatomic,copy,nullable) NSString *shareIcon;

/** < shareTitle > */
@property (nonatomic,copy,nullable) NSString *shareTitle;

/** < shareType > */
@property (nonatomic,assign) CYShareType shareType;



@end
