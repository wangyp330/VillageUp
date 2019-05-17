//
//  FZChallageViewController.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZChallageViewController.h"
#import "ZFDouYinViewController.h"
#import "ShortVideoModel.h"
#import "FZShowARClassCollectionViewCell.h"
#import <YYWebImage.h>
#import "UIView+ZFFrame.h"
#import "VideoRecordViewController.h"
#import <RTRootNavigationController.h>
@interface FZChallageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    ZFDouYinViewController *vc;
}
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign) NSInteger pageNo;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIImageView *image;

@property(nonatomic,strong)UIButton *backBtn;
@end

@implementation FZChallageViewController
#pragma mark 懒加载
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCollectionView];
    [self requestdATA];
    [self integrateComponents];
    self.title = [NSString stringWithFormat:@"#%@",self.tagtitle];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
     self.navigationController.navigationBar.clipsToBounds=YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏背景"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor=[UIColor colorWithHexString:@"f3f3f3"];
}
- (void)goBackAction
{
    // 在这里增加返回按钮的自定义动作
    [self dismissViewControllerAnimated:YES completion:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismm" object:nil];
}
#pragma mark  设置CollectionView的的参数
- (void) initCollectionView
{
    CGFloat higth = 0;
    

    self.image = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 160)];
    self.image.userInteractionEnabled = YES;
        self.image.image = [UIImage imageNamed:@"-s-挑战背景色"];
        [self.view addSubview:self.image];
       [self.image addSubview:self.backBtn];
    
    UILabel *  labelOne = [[UILabel alloc]initWithFrame:CGRectMake(50, 15, SCREEN_WIDTH-100, 44)];
    labelOne.text =[NSString stringWithFormat:@"#%@",self.tagtitle];
    labelOne.font = [UIFont systemFontOfSize:17.0f];
    labelOne.textAlignment = NSTextAlignmentCenter;
    labelOne.textColor =[UIColor whiteColor];
    [self.image addSubview:labelOne];

     UITextView *text = [[UITextView alloc]initWithFrame:CGRectMake(13, 65, SCREEN_WIDTH-26, 80)];
    text.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    text.layer.masksToBounds = YES;
    text.layer.cornerRadius = 4;
    text.editable = NO;
    text.textColor = [UIColor whiteColor];
    text.font = [UIFont systemFontOfSize:13];
    text.contentInset = UIEdgeInsetsMake(5.0f, 10.0f, 10.0f, 10.0f);
    [self.image addSubview:text];
    text.text= self.tagConten;
    if (self.tagConten.length > 0) {
//        higth = 160;
         text.text= self.tagConten;
    }else{
//        higth = 64;
         text.text= @"此挑战暂未发布心情";
    }
    
    
    UIView *sorceBgView=[[UIView alloc]init];
    sorceBgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:sorceBgView];
    sorceBgView.frame=CGRectMake(0, 160+5, SCREEN_WIDTH, 40);
    UILabel *lab=[[UILabel alloc]init];
    lab.font=[UIFont systemFontOfSize:13];
    lab.textColor=[UIColor colorWithHexString:@"333333"];
    lab.textAlignment=NSTextAlignmentLeft;
    [sorceBgView addSubview:lab];
    lab.frame=CGRectMake(13, 0, 200, 40);
    lab.text=@"按发布时间排序";
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing = 0.000001f;
    //设置CollectionView的属性
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 160+45,SCREEN_WIDTH, SCREEN_HEIGHT-96) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    //注册Cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"FZShowARClassCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FZShowARClassCollectionViewCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
}
-(void)setVideopath:(NSString *)videopath{
    
    
}
#pragma mark  设置CollectionView的组数
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
//    header.backgroundColor = [UIColor whiteColor];
//        UILabel *  labelOne = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 44)];
//        labelOne.text =@"按发布时间排序";
//        labelOne.font = [UIFont systemFontOfSize:14.0f];
//
//        labelOne.textColor =[UIColor colorWithHexString:@"666666"];
//        [header addSubview:labelOne];
//        return header;
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return CGSizeMake(SCREEN_WIDTH, 44);
//}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
    
}
#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

        
        FZShowARClassCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FZShowARClassCollectionViewCell" forIndexPath:indexPath];
    ShortVideoModel *model = self.dataSource[indexPath.row];
        cell.coverImage.yy_imageURL = [NSURL URLWithString:model.coverPath]
    ;        return cell;

}
#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake((SCREEN_WIDTH-3)/3 ,(SCREEN_WIDTH-3)/3+39 );
}



#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 1.5, 0);//（上、左、下、右）
}


#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.5;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.5;
}

#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (self.FZShowARClassViewDelegate && [self.FZShowARClassViewDelegate respondsToSelector:@selector(didSelectClass:)]) {
    //        [self.FZShowARClassViewDelegate didSelectClass:self.dataArray[indexPath.item]];
    //    }
    
    vc = [[ZFDouYinViewController alloc]init];
    vc.dataArray = [NSMutableArray arrayWithArray:self.dataSource];
    vc.pageNumber = self.pageNo;
    [vc playTheIndex:indexPath.item];
    [self presentViewController:vc animated:YES completion:nil];
    //
}
-(void)requestdATA{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SVProgressHUD showGif];
   
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:@(-1) forKey:@"pageNo"];
    [parm setObject:self.tagId forKey:@"tagId"];
    [FZNetworkingManager requestLittleAntMethod:@"getVideoListByTagId" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        if (self->_pageNo == 1) {
            [self.dataSource removeAllObjects];
        }
        NSLog(@"");
        if (success == YES) {
            [[response objectForKey:@"response"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ShortVideoModel *mdoel = [[ShortVideoModel alloc]initWithDictionary:obj error:nil];
                [self.dataSource addObject:mdoel];
            }];
            [self.collectionView reloadData];
        }
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVProgressHUD hidGif];
    }];
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"BackToVideoCammer"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.backBtn.frame = CGRectMake(8, CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame), 36, 36);
}
-(void)backClick:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)integrateComponents {
    UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [publishButton setBackgroundImage:[UIImage imageNamed:@"跟拍拍摄"] forState:(UIControlStateNormal)];
    publishButton.backgroundColor = [UIColor clearColor];;
    publishButton.layer.masksToBounds = YES;
    //    publishButton.layer.borderWidth = 3;
    //    publishButton.layer.borderColor = [UIColor whiteColor].CGColor;
    //    publishButton.layer.cornerRadius = 72;
    [publishButton addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
    [publishButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    publishButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-60,[UIScreen mainScreen].bounds.size.height-120, 150,55);
    publishButton.centerX = self.view.centerX;
    [self.view addSubview: publishButton];
    [self.view bringSubviewToFront:publishButton];
}
-(void)publishAction:(UIButton *)sender{
    VideoRecordViewController *vc = [[VideoRecordViewController alloc]init];
    RTRootNavigationController *MineNav =[[RTRootNavigationController alloc]initWithRootViewControllerNoWrapping:vc];
    vc.targetId = @"";
    vc.tagModel = self.tagModel;
    [self presentViewController:MineNav animated:YES completion:^{
        
    }];
}
@end
