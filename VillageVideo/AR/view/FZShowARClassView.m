//
//  FZShowARClassView.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZShowARClassView.h"
#import "FZShowARClassCollectionViewCell.h"
#import "ShortVideoModel.h"
#import <YYWebImage/YYWebImage.h>
#import "FZARCollectionReusableHeadView.h"
#import "ShortViewCollectionViewCell.h"
@interface FZShowARClassView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)FZARCollectionReusableHeadView *header;
@end
@implementation FZShowARClassView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self initCollectionView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 40)];
        label.text = @"推荐视频";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.05];
        [self addSubview:label];
    }
    return self;
}
#pragma mark  设置CollectionView的的参数
- (void) initCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置CollectionView的属性
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40,SCREEN_WIDTH, 120) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.05];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = YES;
    [self addSubview:self.collectionView];
    //注册Cell
    //注册Cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"ShortViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ShortViewCollectionViewCell"];
//        [self.collectionView registerNib:[UINib nibWithNibName: @"FZARCollectionReusableHeadView" bundle: nil] forSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier: @"FZARCollectionReusableHeadView"];
}
//-(void)setVideopath:(NSString *)videopath{
//
//    self.dataArray  = [videopath componentsSeparatedByString:@","];
//    [self.collectionView reloadData];
//
//}
-(void)setVideoArray:(NSArray *)videoArray{
    self.dataArray  = [NSArray arrayWithArray:videoArray];
    [self.collectionView reloadData];
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

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *identify = @"FZShowARClassCollectionViewCell";
//    FZShowARClassCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
//    ShortVideoModel *model = self.dataArray[indexPath.row];
//    cell.coverImage.yy_imageURL = [NSURL URLWithString:model.coverPath];
//    return cell;
    ShortViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShortViewCollectionViewCell" forIndexPath:indexPath];
    ShortVideoModel *model = self.dataArray[indexPath.row];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 4;
    cell.model = model;
    return cell;
}
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    UICollectionReusableView *reusableView = nil;
//    if (kind == UICollectionElementKindSectionHeader) {       //头视图
//        _header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FZARCollectionReusableHeadView" forIndexPath:indexPath];
//           _header.layer.borderColor = APP_Gray_COLOR.CGColor;
//        reusableView = _header;
//    }
//    return reusableView;
//}
//-(CGSize)collectionView: (UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection: (NSInteger)section{
//
//
//
//    return CGSizeMake(SCREEN_WIDTH, 40);
//
//}
#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(SCREEN_WIDTH /4,120);
}



#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 10);//（上、左、下、右）
}


#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.FZShowARClassViewDelegate && [self.FZShowARClassViewDelegate respondsToSelector:@selector(didSelectClass:)]) {
        [self.FZShowARClassViewDelegate didSelectClass:indexPath.row];
    }
 
}

#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
@end
