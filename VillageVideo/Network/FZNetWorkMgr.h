//
//  FZNetWorkMgr.h
//  
//
//  Created by wukai on 2017/5/15.
//
//

#import <Foundation/Foundation.h>

@interface FZNetWorkMgr : NSObject

/**
 *  单例模式
 */
+ (id)shareInstance;

#pragma mark - Networking Reachability
/**
 *  网络是否连接
 */
- (BOOL)isNetWorkConnected;

/**
 *  返回网络类型 字符串
 */
- (NSString *)connectedNetWorkType;

@end
