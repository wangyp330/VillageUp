//
//  FZNetWorkMgr.m
//  
//
//  Created by wukai on 2017/5/15.
//
//

#import "FZNetWorkMgr.h"
#import "AFNetworking.h"
//#import "FZBaseViewController.h"

@interface FZNetWorkMgr ()
{
    BOOL isNetWorkStatusReached;
}

@property (nonatomic, assign) BOOL isConnectNet;
@property (nonatomic, strong) NSString *netType;

@end

@implementation FZNetWorkMgr

#pragma mark - Initial
+ (instancetype)shareInstance
{
    static FZNetWorkMgr *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self shareInstance];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initializeAFNetworkReachabilityManager];
    }
    return self;
}


#pragma mark - Networking Reachability
- (void)initializeAFNetworkReachabilityManager
{
    isNetWorkStatusReached = NO;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                NSLog(@"未识别的网络");
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"不可达的网络(未连接)");
                _isConnectNet = NO;
                _netType = @"不可达的网络(未连接)";
                //[weakSelf sendNotification:kNotification_FZNetWorkMgr_NetWorkStateDidChanged];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                NSLog(@"2G,3G,4G...的网络");
                _isConnectNet = YES;
                _netType = @"2G/3G/4G";
                //[weakSelf sendNotification:kNotification_FZNetWorkMgr_NetWorkStateDidChanged];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"wifi的网络");
                _isConnectNet = YES;
                _netType = @"wifi";
                //[weakSelf sendNotification:kNotification_FZNetWorkMgr_NetWorkStateDidChanged];
                break;
            }
            default:
                break;
        }
        isNetWorkStatusReached = YES;
    }];
}

- (BOOL)isNetWorkConnected
{
    return isNetWorkStatusReached ? _isConnectNet : YES;
}

- (NSString *)connectedNetWorkType
{
    return _netType;
}

@end
