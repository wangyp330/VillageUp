//
//  OwenProductViewController.m
//  PlayShortVideo
//
//  Created by missyun on 2018/8/1.
//  Copyright © 2018年 mac. All rights reserved.
//
#import "OwenProductViewController.h"
#import "ShortVideoModel.h"
#import "UIView+ZFFrame.h"
#import <VTMagic.h>
#import "ZFDouYinViewController.h"
#import "FZDraftViewController.h"
#import "FZBaseNavigationViewController.h"
@interface OwenProductViewController ()<VTMagicReuseProtocol>{
    ZFDouYinViewController *vc;
}
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign) NSInteger pageNo;
@property(nonatomic,assign)NSInteger signInt;
@end

@implementation OwenProductViewController

#pragma mark - 懒加载
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
    //网络请求
//    self->_pageNo ++;
//    // 结束刷新
//    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
//    [parm setObject:@(_pageNo) forKey:@"pageNo"];
//    [parm setObject:self.userId forKey:@"userId"];
//    if (self.isContainsDraft && self.isContainsDraft.length > 0) {
//        [parm setObject:self.isContainsDraft forKey:@"isContainsDraft"];
//    }
//    [FZNetworkingManager requestLittleAntMethod:self.method parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
//        if (self->_pageNo == 1) {
//            [self.dataSource removeAllObjects];
//        }
//        NSLog(@"");
//        if (success == YES) {
//            [[response objectForKey:@"response"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                ShortVideoModel *mdoel = [[ShortVideoModel alloc]initWithDictionary:obj error:nil];
//                [self.dataSource addObject:mdoel];
//            }];
//            self.dataArray  = [NSArray arrayWithArray:self.dataSource];
//            [self.collectionView reloadData];
//            self->vc.dataArray = [[NSMutableArray alloc]initWithArray:self.dataArray];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"hahaha" object:nil];
//        }
//    }];
    
    //网络请求
    self->_pageNo ++;
    // 结束刷新
    [self requestdATA];
//      self.signInt = 1;
    
}
-(void)DianZsnShortVideo{
       self->_pageNo = 1;
        self.signInt = 0;
    [self requestdATA];
}
-(void)success{
    self->_pageNo = 1;
      self.signInt = 0;
    [self requestdATA];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.method isEqualToString:@"getMyLikeVideos"]) {
        self.collectionView.height =SCREEN_HEIGHT;
        [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[[UIColor whiteColor] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
    }else{
        self.collectionView.height =self.magicController.magicView.height;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[[UIColor clearColor] colorWithAlphaComponent:0]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}
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
    self->_pageNo = 1;
      self.signInt = 0;

   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterLoginView) name:NotificationIsLikeShortVideo object:nil];
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DianZsnShortVideo) name:NotificationDianZsnShortVideo object:nil];
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(success) name:@"punblishSuccess" object:nil];
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
          self.signInt = 0;
    }];
    // 上拉刷新
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        [self.collectionView.mj_footer  beginRefreshing];
        //网络请求
        self->_pageNo ++;
        // 结束刷新
        [self requestdATA];
//         self.signInt = 1;
        
    }];
    if (!self.collectionView.mj_footer.isRefreshing) {
        self.collectionView.mj_footer.alpha = 0;
    }else{
        self.collectionView.mj_footer.alpha = 1;
    }
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
     [parm setObject:self.userId forKey:@"userId"];
    if (self.isContainsDraft && self.isContainsDraft.length > 0) {
        [parm setObject:self.isContainsDraft forKey:@"isContainsDraft"];
    }
    [FZNetworkingManager requestLittleAntMethod:self.method parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        if (self->_pageNo == 1) {
            [self.dataSource removeAllObjects];
        }
        NSLog(@"");
        if (success == YES) {
            [[response objectForKey:@"response"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ShortVideoModel *mdoel = [[ShortVideoModel alloc]initWithDictionary:obj error:nil];
                [self.dataSource addObject:mdoel];
            }];
            
        self.dataArray  = [NSArray arrayWithArray:self.dataSource];
        [self.collectionView reloadData];
//        self->vc.dataArray = [[NSMutableArray alloc]initWithArray:self.dataArray];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"hahaha" object:nil];
        }
        [self.collectionView.mj_header   endRefreshing];
        [self.collectionView.mj_footer  endRefreshing];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVProgressHUD hidGif];
    }];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //判断是否包含草稿箱  第一个数据  staue
    if (self.dataArray.count > 0) {
        ShortVideoModel *model = self.dataArray[0];
        if ([model.status isEqualToString:@"0"]) {
            //草稿箱
            if (indexPath.row == 0) {
                NSLog(@"草稿箱");
                FZDraftViewController *VC= [[FZDraftViewController alloc]init];
               FZBaseNavigationViewController *na = [[FZBaseNavigationViewController alloc]initWithRootViewController:VC];
                [self presentViewController:na animated:YES completion:nil];
            }else{
                vc = [[ZFDouYinViewController alloc]init];
//                if (self.signInt == 1) {
//
//                }else{
//                    [self.dataSource removeObjectAtIndex:0];
                    self.signInt = 1;
//                }
                if (self.dataSource.count > 1 ) {
                    
                    if (!model.auditInfo || [model.auditInfo.isPass isEqualToString:@"0"]) {
                        [MBProgressHUD showSuccess:@"审核未通过不能观看" toView:self.view];
                        
                        return;
                    }
                    
                    vc.dataArray = [[NSMutableArray alloc]initWithArray:self.dataSource];
                    [vc.dataArray removeObjectAtIndex:0];
                    vc.dataArray = vc.dataArray;
                    vc.pageNumber = self.pageNo;
                    vc.method = self.method;
                    [vc playTheIndex:indexPath.item-1];
                    [self presentViewController:vc animated:YES completion:nil];
                }
            }

        }else{
            if (!model.auditInfo || [model.auditInfo.isPass isEqualToString:@"0"]) {
                
                [MBProgressHUD showSuccess:@"审核未通过不能观看" toView:self.view];
                return;
            }
            vc = [[ZFDouYinViewController alloc]init];
            vc.dataArray = [[NSMutableArray alloc]initWithArray:self.dataArray];
            vc.pageNumber = self.pageNo;
            vc.method = self.method;
            [vc playTheIndex:indexPath.item];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }

}

#pragma mark - 处理空页面
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂时无数据~";
    if ([self.method isEqualToString:@"getUserCreateVideoList"]) {
        title = @"还没有作品，快去发布吧~";
    }else if ([self.method isEqualToString:@"getMyLikeVideos"]){
        title = @"还没有喜欢的小视频，快去点赞吧~";
    }
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"空页"];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    return -80;
    
}
@end

