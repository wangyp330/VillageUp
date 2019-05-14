//
//  FZBaseViewController.m
//  LittentAntShortVideo
//
//  Created by mac on 2018/8/2.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZBaseViewController.h"
#import "UIColor+Hex.h"
#import "FZNewsViewController.h"
#import "FZARViewController.h"
#import "FZShortVideoViewController.h"
#import <IQKeyboardManager.h>
#import "ZFUtilities.h"
@interface FZBaseViewController ()

@end

@implementation FZBaseViewController
-(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"],
                                                                      NSFontAttributeName : [UIFont systemFontOfSize:17]}];
//    [[UINavigationBar appearance] setBackgroundImage:[ZFUtilities imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forBarMetrics:(UIBarMetricsDefault)];
//    [[UINavigationBar appearance] setShadowImage:[ZFUtilities imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(0.5, 0.5)]];
    self.view.backgroundColor = APP_VIEW_BG_COLOR;
    if(![self isKindOfClass:[FZNewsViewController class]] && ![self isKindOfClass:[FZARViewController class]] && ![self isKindOfClass:[FZShortVideoViewController class]])
    {
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -100) forBarMetrics:UIBarMetricsDefault];
        [self.navigationItem setHidesBackButton:YES];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 44, 44);
        [btn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -32, 0, 0)];
        [btn addTarget:self action: @selector(goBackAction) forControlEvents: UIControlEventTouchUpInside];

        UIBarButtonItem * back = [[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.backBarButtonItem = back;
        [self.view addSubview:btn];
//        [self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"返回"]];
//        [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"返回"]];
//        UIBarButtonItem *backBBItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(goBackAction)];
        self.navigationItem.leftBarButtonItem = back;
       
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UITableView class]]) {
            UITableView *tab =(UITableView *) subView;
            tab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            tab.separatorColor = [UIColor colorWithHexString:@"e5e5e5"];
        }
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)goBackAction
{
    // 在这里增加返回按钮的自定义动作
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//纯数字正则校验
- (BOOL)isNumText:(NSString *)str
{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
}

- (BOOL)hasUserLogin
{
    //    BOOL isLogin = [NDSUD boolForKey:DEF_NDSUD_ISLOGIN];
    //    if (!isLogin)
    //    {
    ////        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ////        FZLoginViewController * mLogInViewController = [storyboard instantiateViewControllerWithIdentifier:@"kFZLoginViewController"];
    ////        [self presentViewController:mLogInViewController animated:YES completion:nil];
    //        return NO;
    //    }
    return YES;
}

@end
