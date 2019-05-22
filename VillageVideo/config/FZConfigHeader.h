//
//  FZConfigHeader.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#ifndef FZConfigHeader_h
#define FZConfigHeader_h

#define WeakSelf    __weak __typeof(&*self)weakSelf = self;

/**颜色**/
#define APP_VIEW_BG_COLOR  [UIColor colorWithHexString:@"f6f6f6"]
#define APP_BLUE_COLOR     [UIColor colorWithHexString:@"4285F4"]
#define APP_Gray_COLOR  [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1]

// 判断是否是iPhone X
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 状态栏高度
#define STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)
// 导航栏高度
#define NAVIGATION_BAR_HEIGHT (iPhoneX ? 88.f : 64.f)
// tabBar高度
#define TAB_BAR_HEIGHT (iPhoneX ? (49.f + 34.f) : 49.f)
// home indicator
#define HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0.f)

/****其他*****/
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

//6s比例
#define KScreenScaleRatio(m) m*(SCREEN_HEIGHT/667.0)
#define KScreenScaleRatioWidth(m) m*(SCREEN_WIDTH/375.0)

#define UINAVIGATION_HEIGHT 64
#define UINAVIGATION_HEIGHT_LANDSCAPE 32

#define UITABBAR_HEIGHT 49
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define Current_UserAccount @"currentUser_account"
#define NDSUD       [NSUserDefaults standardUserDefaults]
//NSUserDefaults 存取值
#define NSUSERSET(VALUE, KEY)  [[NSUserDefaults standardUserDefaults] setObject:VALUE forKey:KEY]
#define NSUSERGET(KEY)  [[NSUserDefaults standardUserDefaults] objectForKey:KEY]

#define USER_ACCOUNT [[FZUserInformation shareInstance].userModel.colAccount uppercaseString]

#define nilToEmpty(object) (object != nil) ? object : @""

#define AntNest_BlackList @"antNestBlackList"

//消除警告
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wundeclared-selector\"") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
#endif
