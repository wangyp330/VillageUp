//
//  FZPlayARViewController.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZPlayARViewController.h"
#import "FZARWebCollectionViewCell.h"
#import "FZARVideoCollectionViewCell.h"

#import "ZFDouYinViewController.h"
#import "AppDelegate.h"
#import "FZMessageSocketMgr.h"
#import "UIView+ZFFrame.h"
static NSString *VideoID = @"FZARVideoCollectionViewCell";
static NSString *WebID = @"FZARWebCollectionViewCell";
@interface FZPlayARViewController()<UICollectionViewDelegate,UICollectionViewDataSource,FZShowARClassViewDelegate>{
    ZFDouYinViewController *vc;
}
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *go;
@property (nonatomic, strong) UIButton *back;
@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)FZShowARClassView *showARClassView;
@end
@implementation FZPlayARViewController
-(MPMoviePlayerController *)mPMoviePlayerController{
        if (!_mPMoviePlayerController) {
            _mPMoviePlayerController = [[MPMoviePlayerController alloc]init];
            _mPMoviePlayerController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3);
//            [_mPMoviePlayerController play];
        }
    return _mPMoviePlayerController;
}


-(FZShowARClassView *)showARClassView{
    if (!_showARClassView) {
        _showARClassView = [[FZShowARClassView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-160, SCREEN_WIDTH, 160)];
        _showARClassView.FZShowARClassViewDelegate = self;
    }
    return _showARClassView;
}
-(void)didSelectClass:(NSInteger)videoPath{
    vc = [[ZFDouYinViewController alloc]init];
    vc.dataArray = [NSMutableArray arrayWithArray:self.VideoArray];
    [vc playTheIndex:videoPath];
    [self presentViewController:vc animated:YES completion:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.mPMoviePlayerController isFullscreen]) {
    }else{
    [self.mPMoviePlayerController stop];
    }
        

    [self.go removeFromSuperview];
    [self.back removeFromSuperview];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.mPMoviePlayerController play];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    UIWindow * window = [[UIApplication sharedApplication].windows lastObject];
    
     [self.view addSubview:self.backBtn];
    [window addSubview:self.go];
    [window addSubview:self.back];
    if (self.dataArray.count == 1) {
        self.go.hidden = YES;
        self.back.hidden = YES;
    }else{
        self.go.hidden = NO;
        self.back.hidden = NO;
    }
    [self initCollectionView];
    if (self.VideoArray.count > 0) {
        [self.view addSubview:self.showARClassView];
        self.showARClassView.videoArray = [NSArray arrayWithArray:self.VideoArray];
    }
  
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if ([self.mPMoviePlayerController isFullscreen]) {
    }else{
        if (self.mPMoviePlayerController) {
            [self.mPMoviePlayerController stop];
            //        self.mPMoviePlayerController = nil;
        }
    }

}
-(void)dealloc{
    if (self.mPMoviePlayerController) {
        [self.mPMoviePlayerController stop];
                self.mPMoviePlayerController = nil;
    }
}
#pragma mark  设置CollectionView的的参数
- (void) initCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.minimumLineSpacing = 0.000001f;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置CollectionView的属性
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/3,SCREEN_WIDTH, SCREEN_HEIGHT/3) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.centerY = self.view.centerY;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.scrollEnabled = NO;
    [self.view addSubview:self.collectionView];
    //注册Cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"FZARVideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FZARVideoCollectionViewCell"];
      [self.collectionView registerNib:[UINib nibWithNibName:@"FZARWebCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FZARWebCollectionViewCell"];
}
-(void)setVideopath:(NSString *)videopath{
    
    
}
#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
    
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[FZARVideoCollectionViewCell class]]) {
//              [self.mPMoviePlayerController stop];
    }


}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *parm = [NSMutableDictionary new];
    if (self.uuid.length > 0) {
        [parm setObject:self.uuid forKey:@"uuid"];
    }
    if ([cell isKindOfClass:[FZARVideoCollectionViewCell class]]) {
        [self.mPMoviePlayerController stop];
        [self.mPMoviePlayerController.view removeFromSuperview];
          [cell.contentView addSubview:self.mPMoviePlayerController.view];
         self.mPMoviePlayerController.contentURL = [NSURL URLWithString:self.dataArray[indexPath.item]];
         [self.mPMoviePlayerController play];
        if (self.uuid.length > 0) {
            if (self.dataArray.count > indexPath.item) {
                [parm setObject:self.dataArray[indexPath.item] forKey:@"videoPath"];
                [[FZMessageSocketMgr shareInstance] sendMessage:parm andmetho:@"arsyc_play_playvideo"];
            }
        }
    }else{
           [self.mPMoviePlayerController stop];
    }
}
#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{


    NSString *keyStr=self.dataArray[indexPath.item];
    if ([keyStr hasSuffix:@".mp4"]) {
     
        FZARVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VideoID forIndexPath:indexPath];
//        [cell.contentView addSubview:self.mPMoviePlayerController.view];
        cell.backgroundColor = [UIColor clearColor];
       
   

//        [self.mPMoviePlayerController play];
        return cell;
    }else{
        FZARWebCollectionViewCell *cell0ne = [collectionView dequeueReusableCellWithReuseIdentifier:WebID forIndexPath:indexPath];
        NSString *keyStr=self.dataArray[indexPath.item];

        if ([keyStr hasSuffix:@".ppt"]) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
            [parm setObject:keyStr forKey:@"sourcePath"];
            [FZNetworkingManager requestLittleAntARMethod:@"getOfficeHadleFileBySourcePath" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
                
                if (success == YES) {
                    
                    NSDictionary *responseDic=[response objectForKey:@"response"];
                    NSString *htmlPath=[responseDic objectForKey:@"htmlPath"];
                    NSURL *url = [NSURL URLWithString:htmlPath];
                    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建
                    [cell0ne.webView loadRequest:request];//加载
//                    if (self.uuid.length > 0) {
//                        [parm setObject:htmlPath forKey:@"videoPath"];
//                        [[FZMessageSocketMgr shareInstance] sendMessage:parm andmetho:@"arsyc_play_playvideo"];
//                    }
                   
                }
            }];
        }else{
            NSURL *url = [NSURL URLWithString:keyStr];
            NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建
            [cell0ne.webView loadRequest:request];//加载
            
//            if (self.uuid.length > 0) {
//                [parm setObject:keyStr forKey:@"videoPath"];
//                [[FZMessageSocketMgr shareInstance] sendMessage:parm andmetho:@"arsyc_play_playvideo"];
//            }
       
        }
        return cell0ne;
    }
    return nil;
}
#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(SCREEN_WIDTH ,SCREEN_HEIGHT/3);
}



#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);//（上、左、下、右）
}


#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.FZShowARClassViewDelegate && [self.FZShowARClassViewDelegate respondsToSelector:@selector(didSelectClass:)]) {
//        [self.FZShowARClassViewDelegate didSelectClass:self.dataArray[indexPath.item]];
//    }
//
}

#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark - 获取ppt



- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
         self.backBtn.frame = CGRectMake(10, 10, 40, 40);
        self.go.frame = CGRectMake(SCREEN_WIDTH-50, SCREEN_HEIGHT/2, 40, 40);
        self.back.frame = CGRectMake(10, SCREEN_HEIGHT/2, 40, 40);
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"xgback"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (UIButton *)go {
    if (!_go) {
        _go = [UIButton buttonWithType:UIButtonTypeCustom];
        [_go setImage:[UIImage imageNamed:@"右箭头"] forState:UIControlStateNormal];
        _go.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];;
        [_go addTarget:self action:@selector(goAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _go;
}
- (UIButton *)back {
    if (!_back) {
        _back = [UIButton buttonWithType:UIButtonTypeCustom];
        [_back setImage:[UIImage imageNamed:@"左箭头"] forState:UIControlStateNormal];
        _back.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];;
        [_back addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _back;
}
-(void)goAction:(UIButton *)sender{
    NSIndexPath *firstIndexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    if (firstIndexPath.row == self.dataArray.count-1) {
        return;
    }else{
        [self.collectionView setContentOffset:CGPointMake(SCREEN_WIDTH*(firstIndexPath.item+1), 0) animated:YES];
        NSLog(@"hahahaha%f",SCREEN_WIDTH*(firstIndexPath.item+1));
    }

}

// 滑动到顶部时调用该方法

-(void)backAction:(UIButton *)sender{
    NSIndexPath *firstIndexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    if (firstIndexPath.row == 0) {
        return;
    }else{
        [self.collectionView setContentOffset:CGPointMake(SCREEN_WIDTH*(firstIndexPath.item-1), 0) animated:YES];
    }
}
- (void)backClick:(UIButton *)sender {
    //    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.mPMoviePlayerController stop];
    self.mPMoviePlayerController = nil;
    if (self.dismBck) {
        self.dismBck();
    }
    
}
@end
