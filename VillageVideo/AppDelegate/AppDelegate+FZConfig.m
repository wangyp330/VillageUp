//
//  AppDelegate+FZConfig.m
//  LittentAntShortVideo
//
//  Created by mac on 2018/8/2.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "AppDelegate+FZConfig.h"
#import "FZTabBarViewController.h"
#import "FZLoginViewController.h"
#import "NotificationCenter.h"
#import "FZBaseNavigationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "DHGuidePageHUD.h"
#import "FZUserAgreementViewController.h"
#define hasAgreeUserAgreement @"_hasAgreeUserAgreement_"
#define isFirstInstallApp     @"_isFirstInstallApp_"
typedef void (^Animation)(void);
@interface AppDelegate()<CLLocationManagerDelegate>

@end
@implementation AppDelegate (FZConfig)
-(void)setAppWindows
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self.window makeKeyAndVisible];
}
+ (void)initializeEnterView{
    
    [[NSNotificationCenter defaultCenter] addObserver:[AppDelegate class] selector:@selector(setRootViewController) name:NotificationUserLoginCount object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:[AppDelegate class] selector:@selector(enterLoginView) name:NotificationUserQuitCount object:nil];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString  *user = [userDef objectForKey:@"UserState"];
    if ([user isEqualToString:@"1"]) {
        [AppDelegate setRootViewController];
    }else{
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:hasAgreeUserAgreement]) {
//                 [AppDelegate enterLoginView];
//        }else{
//            [AppDelegate enterUserAgreement];
//        }
        [AppDelegate enterLoginView];
    }
}
-(void)enterMainFrameView{
    [AppDelegate setRootViewController ];
}
-(void)enterLoginViewaaa{
    [AppDelegate enterLoginView];
}
+(void)enterUserAgreement{
    FZUserAgreementViewController *viewOne = [[FZUserAgreementViewController alloc]init];
    viewOne.view.backgroundColor = [UIColor redColor];
    viewOne.title = @"用户协议";
    viewOne.agree = ^(BOOL isAgree) {
        if (isAgree) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:hasAgreeUserAgreement];
            [AppDelegate enterLoginView];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"为了您更好的使用APP,请您仔细阅读，不同意用户政策将无法正常使用本APP"  message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alertView show];
        }
    };
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:viewOne];
    [self changeRootViewController:na animated:YES];
}
+ (void)enterLoginView
{
    FZLoginViewController *loginVC = [[FZLoginViewController alloc] init];
    FZBaseNavigationViewController *navigation = [[FZBaseNavigationViewController alloc] initWithRootViewController:loginVC];
    [self changeRootViewController:navigation animated:YES];
}
+ (void)changeRootViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    __block UIWindow *window =((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    Animation animation = ^{
        [UIView setAnimationsEnabled:NO];
        window.rootViewController = viewController;
        [UIView setAnimationsEnabled:animated];
    };
    
    [UIView transitionWithView:window duration:0.3f options:UIViewAnimationOptionTransitionNone
                    animations:animation completion:nil];
}
+(void)setRootViewController
{
    //    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    app.window.rootViewController = [[SYJTabBarController alloc] init];
    
    
    //    SYJNavigationController *navigation = [[SYJNavigationController alloc] initWithRootViewController:loginVC];
    //    [self changeRootViewController:navigation animated:YES];
    
    FZTabBarViewController *rootVC = [[FZTabBarViewController alloc] init];
    [self changeRootViewController:rootVC animated:YES];
}

@end
