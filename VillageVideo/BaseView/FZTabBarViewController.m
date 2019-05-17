//
//  FZTabBarViewController.m
//  LittentAntShortVideo
//
//  Created by mac on 2018/8/2.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZTabBarViewController.h"
#import "FZBaseNavigationViewController.h"
#import "ViewController.h"
#import "FZARViewController.h"//AR
#import "FZShortVideoViewController.h"//短视频
#import "FZPersonalCenterViewController.h"
#import "FZNewsViewController.h"
#import "AppDelegate.h"
#import <RTRootNavigationController.h>
#define TabBarVC              @"vc"                //--tabbar对应的视图控制器
#define TabBarTitle           @"title"             //--tabbar标题
#define TabBarImage           @"image"             //--未选中时tabbar的图片
#define TabBarSelectedImage   @"selectedImage"     //--选中时tabbar的图片
#define TabBarItemBadgeValue  @"badgeValue"        //--未读个数
#define TabBarCount 4                              //--tabbarItem的个数
typedef NS_ENUM(NSInteger,FZTabType) {
    // --这里的顺序，决定了 tabbar 从左到右item的显示顺序
    FZTabTypeAR,         //AR
    FZTabTypeShortVideo,        //短视频
    FZTabTypeNews,        //自媒体
    FZTabTypeMine,            //我的
};
@interface FZTabBarViewController ()<UITabBarControllerDelegate>
@property (nonatomic, strong)  NSDictionary *configs;
@end

@implementation FZTabBarViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubNav];
}

- (NSArray*)tabbars{
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSInteger tabbar = 0; tabbar < TabBarCount; tabbar++) {
        [items addObject:@(tabbar)];
    }
    return items;
}

- (void)setUpSubNav {
    
    NSMutableArray *vcArray = [[NSMutableArray alloc] init];
    [self.tabbars enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary * item =[self vcInfoForTabType:[obj integerValue]];
        NSString *vcName = item[TabBarVC];
        NSString *title  = item[TabBarTitle];
        NSString *imageName = item[TabBarImage];
        NSString *imageSelected = item[TabBarSelectedImage];
        Class clazz = NSClassFromString(vcName);
        UIViewController *vc = [[clazz alloc]init];
        vc.hidesBottomBarWhenPushed = NO;
        FZBaseNavigationViewController *nav = [[FZBaseNavigationViewController alloc] initWithRootViewController:vc];
        nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                       image:[UIImage imageNamed:imageName]
                                               selectedImage:[[UIImage imageNamed:imageSelected] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        nav.tabBarItem.tag = idx;
//        NSInteger badge = [item[TabBarItemBadgeValue] integerValue];
//        if (badge) {
//            nav.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",badge];
//        }
        
        [[UITabBar appearance] setTintColor:APP_BLUE_COLOR]; // 设置TabBar上 字体颜色
        [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
        
        [vcArray addObject:nav];
    }];
    self.viewControllers = [NSArray arrayWithArray:vcArray];
    
}

#pragma mark - VC
- (NSDictionary *)vcInfoForTabType:(FZTabType)type{
    
    if (_configs == nil)
    {
        _configs = @{
                     @(FZTabTypeAR) : @{
                             TabBarVC           : @"FZNewsViewController",
                             TabBarTitle        : @"村貌",
                             TabBarImage        : @"tab_0_nor",
                             TabBarSelectedImage: @"tab_0_sel",
                             TabBarItemBadgeValue: @(1)
                             },
                     @(FZTabTypeShortVideo)     : @{
                             TabBarVC           : @"FZARViewController",
                             TabBarTitle        : @"学习",
                             TabBarImage        : @"tab_1_nor",
                             TabBarSelectedImage: @"tab_1_sel",
                             TabBarItemBadgeValue: @(0)
                             },
                     @(FZTabTypeNews): @{
                             TabBarVC           : @"FZShortVideoViewController",
                             TabBarTitle        : @"小视频",
                             TabBarImage        : @"tab_2_nor",
                             TabBarSelectedImage: @"tab_2_sel",
                             TabBarItemBadgeValue: @(0)
                             
                             },
                     @(FZTabTypeMine)     : @{
                             TabBarVC           : @"FZPersonalCenterViewController",
                             TabBarTitle        : @"学习空间",
                             TabBarImage        : @"tab_3_nor",
                             TabBarSelectedImage: @"tab_3_sel",
                             TabBarItemBadgeValue: @(0)
                             
                             }
                     };
        
    }
    return _configs[@(type)];
}
@end
