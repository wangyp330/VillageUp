//
//  FZShortVideoViewController.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZShortVideoViewController.h"
#import "BaseCollectionViewController.h"
#import "FZRecommendViewController.h"
#import <VTMagic/VTMagic.h>
#import <Masonry.h>
#import "VideoRecordViewController.h"
#import <RTRootNavigationController.h>
#import "UIView+ZFFrame.h"
#import "FZSearchHistoryViewController.h"
#import "FZBaseNavigationViewController.h"
#define kSearchBarWidth (60.0f)
#define hasAgreeUserAgreement @"_hasAgreeUserAgreement_"
@interface FZShortVideoViewController ()<VTMagicViewDataSource, VTMagicViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) FZRecommendViewController *topicViewController;
@property (nonatomic, strong) FZRecommendViewController *forumViewController;
@property (nonatomic, strong) FZRecommendViewController *cityViewController;
@property (nonatomic, strong) NSArray *menuList;
@property(nonatomic,strong)UIButton *publishBtn;

@end

@implementation FZShortVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor whiteColor];
    self.magicView.navigationColor = [UIColor whiteColor];
    self.magicView.layoutStyle = VTLayoutStyleCenter;
    self.magicView.switchStyle = VTSwitchStyleStiff;
    self.magicView.navigationHeight = 44.f;
    self.magicView.againstStatusBar = YES;
    self.magicView.needPreloading = NO;
    [self integrateComponents];
    [self integrateComponentsrightButton];
    [self configCustomSlider];
    
    [self generateTestData];
    [self.magicView reloadData];

}
- (void)integrateComponentsrightButton {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(14, 33, 20, 20)];
    [rightButton addTarget:self action:@selector(rightButton) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"小视频搜索"] forState:(UIControlStateNormal)];
    [self.view addSubview:rightButton];
//    rightButton.center = self.view.center;
//    self.magicView.rightNavigatoinItem = rightButton;
}
//搜索
-(void)rightButton{
    FZSearchHistoryViewController *VC= [[FZSearchHistoryViewController alloc]init];
    FZBaseNavigationViewController *na = [[FZBaseNavigationViewController alloc]initWithRootViewController:VC];
    VC.hostUrl = [NSString stringWithFormat:@"%@/#/searchHistory?uid=%@",App_JAIOXUYE_BASE_URL,[FZUserInformation shareInstance].userModel.uid];
    [self presentViewController:na animated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    return _menuList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:[UIColor colorWithHexString:@"676C6F"] forState:UIControlStateNormal];
        [menuItem setTitleColor:APP_BLUE_COLOR forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont systemFontOfSize:17];
    }
    return menuItem;
}
- (CGFloat)magicView:(VTMagicView *)magicView itemWidthAtIndex:(NSUInteger)itemIndex{
    
    return KScreenScaleRatioWidth(100);
}
- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    NSString  *menuInfo = _menuList[pageIndex];
    if ([menuInfo isEqualToString:@"推荐"]) { // if (0 == pageIndex) {
        return self.topicViewController;
    } else if([menuInfo isEqualToString:@"全部"]){
        return self.forumViewController;
    }else{
        return self.cityViewController;
    }
}

#pragma mark - actions
- (void)subscribeAction {
    NSLog(@"取消／恢复菜单栏选中状态");
    // select/deselect menu item
    if (self.magicView.isDeselected) {
        [self.magicView reselectMenuItem];
        self.magicView.sliderHidden = NO;
    } else {
        [self.magicView deselectMenuItem];
        self.magicView.sliderHidden = YES;
    }
}

#pragma mark - functional methods
- (void)generateTestData {
    _menuList = @[@"推荐",@"同城",@"全部"];
}
- (void)configCustomSlider {
    UIImageView *sliderView = [[UIImageView alloc] init];
    [sliderView setImage:[UIImage imageNamed:@"矩形框"]];
    sliderView.layer.masksToBounds = YES;
    sliderView.layer.cornerRadius = 2;
    sliderView.contentMode = UIViewContentModeScaleAspectFit;
    [self.magicView setSliderView:sliderView];
    self.magicView.sliderHeight = 2.5f;
    self.magicView.sliderOffset = -2;
}
- (UIViewController *)topicViewController {
    if (!_topicViewController) {
        _topicViewController = [[FZRecommendViewController alloc] init];
        _topicViewController.method = @"getLittleVideoListByUserId";
    }
    return _topicViewController;
}

- (UIViewController *)forumViewController {
    if (!_forumViewController) {
        _forumViewController = [[FZRecommendViewController alloc] init];
        _forumViewController.method = @"getAllLittleVideoList";
    }
    return _forumViewController;
}
- (UIViewController *)cityViewController {
    if (!_cityViewController) {
        _cityViewController = [[FZRecommendViewController alloc] init];
        _cityViewController.method = @"getLittleVideoByCity";
    }
    return _cityViewController;
}
- (void)integrateComponents {
    UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [publishButton setBackgroundImage:[UIImage imageNamed:@"发布"] forState:(UIControlStateNormal)];
    publishButton.backgroundColor = [UIColor clearColor];;
    publishButton.layer.masksToBounds = YES;
//    publishButton.layer.borderWidth = 3;
//    publishButton.layer.borderColor = [UIColor whiteColor].CGColor;
//    publishButton.layer.cornerRadius = 72;
    [publishButton addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
    [publishButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    publishButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-60,[UIScreen mainScreen].bounds.size.height-120, 71,52);
    publishButton.centerX = self.view.centerX;
    [self.view addSubview: publishButton];
    [self.view bringSubviewToFront:publishButton];
}

-(void)publishAction:(UIButton *)sender{
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:hasAgreeUserAgreement]) {
        
        VideoRecordViewController *vc = [[VideoRecordViewController alloc]init];
        RTRootNavigationController *MineNav =[[RTRootNavigationController alloc]initWithRootViewControllerNoWrapping:vc];
        vc.viderType = @"0";
        vc.targetId = @"";
        [self presentViewController:MineNav animated:YES completion:^{
            
        }];
        
        
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"为了您更好的使用APP,请您仔细阅读登录页用户协议，点击同意即表示你同意协议内容，不同意用户协议将无法正常使用本APP"  message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        
        
    }
//    VideoRecordViewController *vc = [[VideoRecordViewController alloc]init];
//    RTRootNavigationController *MineNav =[[RTRootNavigationController alloc]initWithRootViewControllerNoWrapping:vc];
//    vc.viderType = @"0";
//    vc.targetId = @"";
//    [self presentViewController:MineNav animated:YES completion:^{
//
//    }];
}
//监听点击事件 代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([btnTitle isEqualToString:@"取消"]) {
        NSLog(@"你点击了取消");
    }else if ([btnTitle isEqualToString:@"确定"] ) {
        NSLog(@"你点击了确定");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:hasAgreeUserAgreement];
        VideoRecordViewController *vc = [[VideoRecordViewController alloc]init];
        RTRootNavigationController *MineNav =[[RTRootNavigationController alloc]initWithRootViewControllerNoWrapping:vc];
        vc.viderType = @"0";
        vc.targetId = @"";
        [self presentViewController:MineNav animated:YES completion:^{
            
        }];
    }
    
}
@end
