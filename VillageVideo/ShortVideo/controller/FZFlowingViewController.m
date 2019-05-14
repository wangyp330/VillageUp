//
//  FZFlowingViewController.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZFlowingViewController.h"
#import "ShortVideoModel.h"
#import <RTRootNavigationController.h>
#import "VideoRecordViewController.h"
#import "UIView+ZFFrame.h"
#import "ZFDouYinViewController.h"
#define hasAgreeUserAgreement @"_hasAgreeUserAgreement_"
@interface FZFlowingViewController ()<UIAlertViewDelegate>{
    ZFDouYinViewController *vc;
}
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign) NSInteger pageNo;
@property(nonatomic,strong)UIButton *publishBtn;
@end

@implementation FZFlowingViewController


- (void)integrateComponents {
    UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [publishButton setBackgroundImage:[UIImage imageNamed:@"跟拍"] forState:(UIControlStateNormal)];
    [publishButton addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
    [publishButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    publishButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-100,[UIScreen mainScreen].bounds.size.height-100, 60, 60);
    [self.view addSubview: publishButton];
//    [self.collectionView bringSubviewToFront:publishButton];
}

-(void)publishAction:(UIButton *)sender{
    
            if ([[NSUserDefaults standardUserDefaults] boolForKey:hasAgreeUserAgreement]) {
                
                VideoRecordViewController *vc = [[VideoRecordViewController alloc]init];
                RTRootNavigationController *MineNav =[[RTRootNavigationController alloc]initWithRootViewControllerNoWrapping:vc];
                vc.viderType = @"1";
                vc.targetId = self.videoFatherId;
                [self presentViewController:MineNav animated:YES completion:^{
                    
                }];
                
                
            }else{
               
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"为了您更好的使用APP,请您仔细阅读登录页用户协议，点击同意即表示你同意协议内容，不同意用户协议将无法正常使用本APP"  message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
                
                
            }
    
//    VideoRecordViewController *vc = [[VideoRecordViewController alloc]init];
//    RTRootNavigationController *MineNav =[[RTRootNavigationController alloc]initWithRootViewControllerNoWrapping:vc];
//    vc.viderType = @"1";
//    vc.targetId = self.videoFatherId;
//    [self presentViewController:MineNav animated:YES completion:^{
        
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
                 vc.viderType = @"1";
                 vc.targetId = self.videoFatherId;
                 [self presentViewController:MineNav animated:YES completion:^{
                     
                 }];
             }
                 
 }
-(void)conFigNa{
    
    UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 5, 14, 22);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBackToHome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
}
-(void)clickBackToHome{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 懒加载
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
    
}
- (void)vtm_prepareForReuse
{
    NSLog(@"clear old data if needed:%@", self);
    [self.collectionView setContentOffset:CGPointZero];
}
-(void)enterLoginView{
    self.pageNo = -1;;
    [self requestdATA];

}
-(void)slidin{
    self.pageNo = -1;;
    [self requestdATA];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.height =self.view.height;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slidin) name:@"punblishSuccess" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterLoginView) name:NotificationIsLikeShortVideo object:nil];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    // 下拉刷新
    [self requestdATA];
    self.collectionView.mj_header= [MJRefreshNormalHeader   headerWithRefreshingBlock:^{
        // 增加数据
        [self.collectionView.mj_header  beginRefreshing];
        //网络请求
        [self.dataSource removeAllObjects];
        self->_pageNo = 1;
        [self requestdATA];
    }];
    // 上拉刷新
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        [self.collectionView.mj_footer  beginRefreshing];
        //网络请求
        self->_pageNo ++;
        // 结束刷新
        [self requestdATA];
        
    }];
    if (!self.collectionView.mj_footer.isRefreshing) {
        self.collectionView.mj_footer.alpha = 0;
    }else{
        self.collectionView.mj_footer.alpha = 1;
    }
    [self integrateComponents];
    [self conFigNa];
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    // 处理视图点击事件...
    // 下拉刷新
    [self requestdATA];
}
-(void)requestdATA{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SVProgressHUD showGif];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:@(_pageNo) forKey:@"pageNo"];
    [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
    [parm setObject:self.videoFatherId forKey:@"videoFatherId"];
    [FZNetworkingManager requestLittleAntMethod:@"getVideosByFatherId" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
//        if (self->_pageNo == -1) {
            [self.dataSource removeAllObjects];
//        }
        NSLog(@"");
        if (success == YES) {
            [[response objectForKey:@"response"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ShortVideoModel *mdoel = [[ShortVideoModel alloc]initWithDictionary:obj error:nil];
                [self.dataSource addObject:mdoel];
            }];
            self.dataArray  = [NSArray arrayWithArray:self.dataSource];
            [self.collectionView reloadData];
        }
        [self.collectionView.mj_header   endRefreshing];
        [self.collectionView.mj_footer  endRefreshing];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVProgressHUD hidGif];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    vc = [[ZFDouYinViewController alloc]init];
    vc.dataArray = [NSArray arrayWithArray:self.dataArray];
    vc.pageNumber = self.pageNo;
//    vc.method = self.method;
    [vc playTheIndex:indexPath.item];
    [self presentViewController:vc animated:YES completion:nil];
}
@end
