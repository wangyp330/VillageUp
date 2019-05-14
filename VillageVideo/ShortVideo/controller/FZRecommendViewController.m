//
//  FZRecommendViewController.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZRecommendViewController.h"
#import "ShortVideoModel.h"
#import <VTMagic/VTMagic.h>
#import "ZFDouYinViewController.h"
#import <UIImage+GIF.h>
@interface FZRecommendViewController ()<VTMagicReuseProtocol>{
    ZFDouYinViewController *vc;
}
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign) NSInteger pageNo;
@end

@implementation FZRecommendViewController
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
//    //网络请求
//    self->_pageNo ++;
//    // 结束刷新
//    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
//    [parm setObject:@(_pageNo) forKey:@"pageNo"];
//    [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
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
//            self->vc.dataArray = [NSMutableArray arrayWithArray:self.dataArray];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"hahaha" object:nil];
//        }
//    }];
    //网络请求
    self->_pageNo ++;
    // 结束刷新
    [self requestdATA];

}
-(void)slidin{
    // 下拉刷新
    self.pageNo = 1;
    [self requestdATA];
}
- (void)viewDidLoad {
    [super viewDidLoad];
      self->_pageNo = 1;
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slidin) name:@"punblishSuccess" object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterLoginView) name:NotificationIsLikeShortVideo object:nil];
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
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    // 处理视图点击事件...
    // 下拉刷新
    [self requestdATA];
}

- (void)showGifToView:(UIView *)view{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    //使用SDWebImage 放入gif 图片
    UIImage *im = [UIImage imageNamed:@"loading12.gif"];
    NSData *imageData = UIImagePNGRepresentation(im);
    UIImage *image =[UIImage imageWithGIFData:imageData];
    
    //自定义imageView
    UIImageView *cusImageV = [[UIImageView alloc] initWithImage:image];
    
    //设置hud模式
    hud.mode = MBProgressHUDModeCustomView;
    
    //设置在hud影藏时将其从SuperView上移除,自定义情况下默认为NO
    hud.removeFromSuperViewOnHide = YES;
    
    //设置方框view为该模式后修改颜色才有效果
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    //设置方框view背景色
    hud.bezelView.backgroundColor = [UIColor clearColor];
    
    //设置总背景view的背景色，并带有透明效果
    hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    hud.customView = cusImageV;
    
}

#pragma mark - 自定义MBProgressHUD动画

-(void)requestdATA{


    [SVProgressHUD showGif];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:@(_pageNo) forKey:@"pageNo"];
    [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
    if ([self.method isEqualToString:@"getLittleVideoByCity"]) {
        NSString *cityName = NSUSERGET(@"city");
        if (cityName.length > 0) {
          [parm setObject:cityName forKey:@"cityName"];
        }else{
             [parm setObject:@"" forKey:@"cityName"];
        }
      
    }
    [FZNetworkingManager requestLittleAntMethod:self.method parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
         [self.collectionView.mj_header   endRefreshing];
        if (self->_pageNo == 1) {
            [self.dataSource removeAllObjects];
        }
          NSLog(@"");
        if (success == YES) {
            NSArray *array=[response objectForKey:@"response"];
            [[response objectForKey:@"response"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ShortVideoModel *mdoel = [[ShortVideoModel alloc]initWithDictionary:obj error:nil];
                [self.dataSource addObject:mdoel];
            }];
            self.dataArray  = [NSArray arrayWithArray:self.dataSource];
            self->vc.dataArray = [NSMutableArray arrayWithArray:self.dataArray];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"hahaha" object:nil];
            [self.collectionView reloadData];
            if (array.count > 0) {
                [self.collectionView.mj_footer endRefreshing];
            }else{
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }
        [SVProgressHUD hidGif];
    }];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    vc = [[ZFDouYinViewController alloc]init];
    vc.dataArray = [NSMutableArray arrayWithArray:self.dataArray];
    vc.pageNumber = self.pageNo;
    vc.method = self.method;
    [vc playTheIndex:indexPath.item];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 处理空页面
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"还没有作品，快去发布吧~";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0f],
                                 NSForegroundColorAttributeName:[UIColor grayColor]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"空页"];
}

@end
