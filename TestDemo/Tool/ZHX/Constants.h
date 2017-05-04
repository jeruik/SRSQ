//
//  Constants.h
//  Cinderella
//
//  Created by mac on 15/5/20.
//  Copyright (c) 2015年 cloudstruct. All rights reserved.
//

#import <Foundation/Foundation.h>

/** DEBUG LOG **/
#ifdef DEBUG
#   define DTLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);
#else
#   define DTLog(...)
#endif



#define isIphone5       CDRViewHeight == 568
#define isIphone4s      CDRViewHeight == 480
#define isIPhone6       CDRViewHeight == 667
#define isIPHONE_6PLUS  CDRViewHeight == 736

/** DEBUG LOG **/

#define DEBUG_SHOW_API NO

#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;
#define FONT_SIZE(_size_) [UIFont systemFontOfSize:_size_]
#define safityObject(_obj) (!_obj||_obj == (id)[NSNull null]) ? @"" :_obj
#define FRAME(x,y,w,h) CGRectMake(x,y,w,h)

#define SR_Window [AppDelegate appDelegate].window

#define rad(angle) ((angle) / 180.0 * M_PI)

#define SHOW_ALERT(_TITLE_)  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_TITLE_ delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];\
[alert show];

#define IOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0) && ([[UIDevice currentDevice].systemVersion doubleValue] <= 8.0)

#define DTColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define DTRandomColor DTColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define VIEW_MARGIN 5
#define VIEW_WIDTH (CDRViewWidth-10 - VIEW_MARGIN * 2) / 3
//#define TITLE_VIEW_H  40

#define CDRViewHeight [[UIScreen mainScreen] bounds].size.height
#define CDRViewWidth  [[UIScreen mainScreen] bounds].size.width

#define CDRHeightScale CDRViewHeight/667
#define CDRWidthScale CDRViewWidth/375

#define Angle2Radian(angle) ((angle) / 180.0 * M_PI)

#define RGBCOLOR(R,G,B) ([UIColor colorWithRed: R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:1])
#define RGBACOLOR(R,G,B,A) [RGBCOLOR(R, G, B) colorWithAlphaComponent:A]

#define HexColor(str)       ([UIColor colorWithHexString:str])
#define BackGroundColor     ([UIColor colorWithWhite:0.953 alpha:1.000])
#define Third_Color         ([UIColor colorWithHexString:@"#333333"])
#define Six_Color           ([UIColor colorWithHexString:@"#666666"])
#define NineColor           ([UIColor colorWithHexString:@"#999999"])

#define NAV_BAR_HEIGHT              64
#define AngleRadion(angle) ((angle) / 180.0 * M_PI)

#define THEME_COLOR [ThemeHelper theme] 

typedef NS_ENUM(NSInteger, ShowType)
{
    ShowTypePush, // push方式展示
    ShowTypeModal
};
#define CYChatUser_Array @"CYChatUser_Array"
#define SRSQRport [[SQUser sharedUser].account stringByAppendingString:@"_SRSQRport"]
#define SRSQBlcakUser [[SQUser sharedUser].account stringByAppendingString:@"_SRSQBlcakUser"]



