//
//  NotificationCenter.h
//  便利记
//
//  Created by excoord on 2018/5/15.
//  Copyright © 2018年 excoord. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationCenter : NSObject
/// 用户退出成功
extern NSString * const NotificationUserQuitCount;
/// 用户登陆成功
extern NSString * const NotificationUserLoginCount;
/// 用户点赞成功
extern NSString * const NotificationIsLikeShortVideo;
extern NSString * const NotificationDianZsnShortVideo;
@end
