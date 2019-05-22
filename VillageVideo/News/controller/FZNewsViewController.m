//
//  FZNewsViewController.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZNewsViewController.h"
#import "FZARViewController.h"
#import "FZPersonalCenterViewController.h"
#import "FZShortVideoViewController.h"
#import "FZBaseWebViewController.h"
#import "ShortVideoModel.h"
#import "ZFDouYinViewController.h"
#import "FZCompleteInformationViewController.h"
#import "FZBaseNavigationViewController.h"
#import "ShareView.h"
#import <WXApi.h>
#import "DHGuidePageHUD.h"
@interface FZNewsViewController ()<UIWebViewDelegate,FZWebViewControllerDelegate>{
    ZFDouYinViewController *vc;
    FZBaseWebViewController *webvc;
}
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSMutableArray  *dataArray;
@end

@implementation FZNewsViewController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//     [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)fzwebViewControllCallHandlerWithMethod:(NSString *)method data:(NSDictionary *)data{
    [self.dataArray removeAllObjects];
    if ([method isEqualToString:@"playArticleVideo"]) {
        //播放视频
        [[data objectForKey:@"videos"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ShortVideoModel *model = [[ShortVideoModel alloc]initWithDictionary:obj error:nil];
            [self.dataArray addObject:model];
        }];
        vc = [[ZFDouYinViewController alloc]init];
        vc.dataArray = [[NSMutableArray alloc]initWithArray:self.dataArray];
        vc.pageNumber = 10000;
        vc.index = [[data objectForKey:@"pageNo"] integerValue];
        [vc playTheIndex:[[data objectForKey:@"position"] intValue]];
        [self presentViewController:vc animated:YES completion:nil];
    }
    if ([method isEqualToString:@"playVideo"]) {
//        //播放视频
    }
    if ([method isEqualToString:@"perfectUserInfo"]) {
        //播放视频
        FZCompleteInformationViewController *vc = [[FZCompleteInformationViewController alloc]init];
//        FZBaseNavigationViewController *na = [[FZBaseNavigationViewController alloc]initWithRootViewController:vc];
      
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([method isEqualToString:@"shareWechat"]) {
    }
}
- (void)viewDidLoad {
    
    /*
     [headerDic setObject:@"ios" forKey:@"machineType"];
  
  
     [headerDic setObject:versionNumString forKey:@"version"];
     */
       NSDictionary *binfoDictionary = [[NSBundle mainBundle] infoDictionary];
       NSString *versionNumString = [[binfoDictionary objectForKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""];
    [super viewDidLoad];
    webvc = [[FZBaseWebViewController alloc]init];
    webvc.webView.scrollView.bounces = NO;
//    vc.title = @"审核列表";
    webvc.delegate=self;
    NSString  * isDisPlay   = @"0";
    // 设置功能指引 ，给web传值 控制指引页显示
    if ([NSUSERGET(BOOLFORKEY) isEqualToString:@"1"]) {
        //第一次登陆
        isDisPlay = @"1";
    }else{
        isDisPlay = @"0";
    }
//App_JAIOXUYE_BASE_URL
    //webvc.hostUrl = [NSString stringWithFormat:@"%@/#/articleList?userId=%@&machineType=%@&version=%@&isDisPlay=%@",App_JAIOXUYE_BASE_URL,[FZUserInformation shareInstance].userModel.uid,@"ios",versionNumString,isDisPlay];
   webvc.hostUrl = [NSString stringWithFormat:@"%@/#/articleList?userId=%@&machineType=ios&version=%@&villgeId=%@&groupId=%@",PhoneWebIP,[FZUserInformation shareInstance].userModel.uid,versionNumString,[FZUserInformation shareInstance].userModel.villageId,[FZUserInformation shareInstance].userModel.groupId];
    //
    
    [self addChildViewController:webvc];
    webvc.view.frame = self.view.frame;
    [self.view addSubview:webvc.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slidin) name:@"FZCompleteInformationViewController" object:nil];

}
-(void)slidin{
    [webvc loadWebView];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
