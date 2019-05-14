      //
//  AppDelegate.m
//  LittentAntShortVideo
//
//  Created by mac on 2018/8/2.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+FZConfig.h"
#import <CoreLocation/CoreLocation.h>
#import <WXApi.h>
#import "DHGuidePageHUD.h"
#import <Bugly/Bugly.h>
@interface AppDelegate ()<CLLocationManagerDelegate,WXApiDelegate>
@property (nonatomic,strong ) CLLocationManager *locationManager;//定位服务
@property (nonatomic,copy)    NSString *currentCity;//城市
@property (nonatomic,copy)    NSString *strLatitude;//经度
@property (nonatomic,copy)    NSString *strLongitude;//维度
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configIp];
    // 启动图片延时: 1秒
    [NSThread sleepForTimeInterval:1];
    [self setAppWindows];
     [self locatemap];
    if ([NSUSERGET(BOOLFORKEY) integerValue] > 0) {
        NSInteger number = [NSUSERGET(BOOLFORKEY) intValue];
        NSString *a =[NSString stringWithFormat:@"%ld",number+1];
     NSUSERSET(a, BOOLFORKEY);
    }else{
        NSUSERSET(@"1", BOOLFORKEY);
    }
    
    [AppDelegate initializeEnterView];
    [WXApi registerApp:@"wxb18c28a3313f183e"];

#warning  APPStore 上传bugly 其余不上传
#if 1
     [Bugly startWithAppId:@"2d751596bb"];
# else
    
#endif
    
    
    if ([FZUserInformation shareInstance].userModel.uid .length > 0) {
        NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
        [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"uid"];
        [FZNetworkingManager requestLittleAntMethod:@"getLittleVideoUserById" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
            NSLog(@"");
            if (success == YES) {
                NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
                if (![[NSString stringWithFormat:@"%@",[response objectForKey:@"response"]] isEqualToString:@"<null>"]) {
                     [userDef setObject:[response objectForKey:@"response"] forKey:@"userInfo"];
                    [userDef setObject:[NSString stringWithFormat:@"%@",[response objectForKey:@"isIosCheckVersion"]] forKey:@"isIosCheckVersion"];
                }else{
                    [userDef removeObjectForKey:@"userInfo"];
                }
               
            }
        }];
    }

    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    [WXApi handleOpenURL:url delegate:self];
    
    return YES;
    
}
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    [WXApi handleOpenURL:url delegate:self];
    
    return YES;
}
//授权后回调 WXApiDelegate
-(void)onResp:(BaseReq *)resp
{
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    
    if ([resp isKindOfClass:[SendAuthResp class]]) //判断是否为授权请求，否则与微信支付等功能发生冲突
    {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0)
        {
            NSLog(@"code %@",aresp.code);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatDidLoginNotification" object:self userInfo:@{@"code":aresp.code}];
        }
    }
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) //判断是否为授权请求，否则与微信支付等功能发生冲突
    {
        SendMessageToWXResp *aresp = (SendMessageToWXResp *)resp;
        if (aresp.errCode== 0)
        {
           
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SendMessageToWXResp" object:self userInfo:nil];
        }
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)locatemap{
    
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
        _currentCity = [[NSString alloc]init];
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 5.0;
        [_locationManager startUpdatingLocation];
    }
}
#pragma mark - 定位失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication]openURL:settingURL];
    }];
}
#pragma mark - 定位成功
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [_locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //当前的经纬度
    NSLog(@"当前的经纬度 %f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    //这里的代码是为了判断didUpdateLocations调用了几次 有可能会出现多次调用 为了避免不必要的麻烦 在这里加个if判断 如果大于1.0就return
    NSTimeInterval locationAge = -[currentLocation.timestamp timeIntervalSinceNow];
//    if (locationAge > 1.0){//如果调用已经一次，不再执行
//        return;
//    }
    //地理反编码 可以根据坐标(经纬度)确定位置信息(街道 门牌等)
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count >0) {
            CLPlacemark *placeMark = placemarks[0];
            self->_currentCity = placeMark.locality;
            if (!self->_currentCity) {
                self->_currentCity = @"无法定位当前城市";
            }
            
            NSUSERSET(placeMark.locality, @"city");
            //看需求定义一个全局变量来接收赋值
            NSLog(@"当前国家 - %@",placeMark.country);//当前国家
            NSLog(@"当前城市 - %@",_currentCity);//当前城市
            NSLog(@"当前位置 - %@",placeMark.subLocality);//当前位置
            NSLog(@"当前街道 - %@",placeMark.thoroughfare);//当前街道
            NSLog(@"具体地址 - %@",placeMark.name);//具体地址
        }else if (error == nil && placemarks.count){
            
            NSLog(@"NO location and error return");
        }else if (error){
            
            NSLog(@"loction error:%@",error);
        }
    }];
}


#pragma ip
-(void)configIp{
    if (![NDSUD objectForKey:@"base_IP"]) {
        [NDSUD setObject:@"0" forKey:@"isDebug"];
        [NDSUD setObject:@"www.maaee.com" forKey:@"base_IP"];
        [NDSUD setObject:@"jiaoxue.maaee.com:8094" forKey:@"jx_IP"];
    }
}
@end
