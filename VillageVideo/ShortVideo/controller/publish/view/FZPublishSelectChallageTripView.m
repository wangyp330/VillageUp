//
//  FZPublishSelectChallageTripView.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/14.
//  Copyright © 2018年 mac. All rights reserved.
//


#import "FZPublishSelectChallageTripView.h"
#import "FZTripCollectionViewCell.h"
#import "FZPublishCollectionReusableHeaderView.h"
#import "UIView+ZFFrame.h"
#import "FZCollectionCell.h"
@interface FZPublishSelectChallageTripView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,FZTripCollectionViewCellDelegate,FZCollectionCellDelegate>{
    UIView *lineView;
}
@property(nonatomic,strong)FZPublishCollectionReusableHeaderView *header;

@property(nonatomic,strong)UILabel *label;
@end
@implementation FZPublishSelectChallageTripView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCollectionView];
    }
    return self;
}
#pragma mark  设置CollectionView的的参数
- (void) initCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //设置CollectionView的属性
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
//    self.collectionView.layer.borderWidth = 1;
    [self addSubview:self.collectionView];
    //注册Cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"FZTripCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FZTripCollectionViewCell"];
       [self.collectionView registerNib:[UINib nibWithNibName:@"FZCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"FZCollectionCell"];
    [self.collectionView registerNib:[UINib nibWithNibName: @"FZPublishCollectionReusableHeaderView" bundle: nil] forSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier: @"FZPublishCollectionReusableHeaderView"];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 95, SCREEN_WIDTH, 1)];
    _label.backgroundColor = APP_Gray_COLOR;
    [self.collectionView addSubview:self.label];

}
#pragma mark <UICollectionViewDataSource>
-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = [NSMutableArray arrayWithArray:dataArray];
    [self.collectionView reloadData];
}
#pragma mark -  删除
- (void)remove:(UIButton *)btn withCell:(FZTripCollectionViewCell *)cell{
   
    FZChallageModel *model = cell.model;
    if (self.delegate && [self.delegate respondsToSelector:@selector(delectSomeTrtp:)]) {
        [self.delegate delectSomeTrtp:model];
    }
    NSArray *arr = self.dataArray[1];
    if (arr.count == 0) {
        self.label.y = 95;
    }
    if ([self.dataArray[0] count] > 0 && [self.dataArray[1] count]  == 0) {
        self.label.y = 120;
    }
    if ([self.dataArray[0] count] == 0 && [self.dataArray[1] count]  > 0) {
        self.label.y = 120;
    }
    if ([self.dataArray[0] count] >0 && [self.dataArray[1] count]  > 0) {
        self.label.y = 160;
    }
    
} 
#pragma mark -  删除
- (void)removechallage:(UIButton *)btn withCell:(FZCollectionCell *)cell{
    
    FZChallageModel *model = cell.model;
    if (self.delegate && [self.delegate respondsToSelector:@selector(delectSomeTrtp:)]) {
        [self.delegate delectSomeTrtp:model];
    }
    NSArray *arr = self.dataArray[1];
    if (arr.count == 0) {
        self.label.y = 95;
    }
    if ([self.dataArray[0] count] > 0 && [self.dataArray[1] count]  == 0) {
        self.label.y = 120;
    }
    if ([self.dataArray[0] count] == 0 && [self.dataArray[1] count]  > 0) {
        self.label.y = 120;
    }
    if ([self.dataArray[0] count] >0 && [self.dataArray[1] count]  > 0) {
        self.label.y = 160;
    }
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    __weak typeof(self)weakSelf = self;
    if (kind == UICollectionElementKindSectionHeader) {       //头视图
        _header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FZPublishCollectionReusableHeaderView" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            lineView.hidden = YES;
            _header.tripLAbel.text = @"";
            _header.image.image = [UIImage imageNamed:@"挑战"];
            _header.title.text = @"添加挑战";
            _header.block = ^() {
                if (weakSelf.block) {
                    weakSelf.block(0);
                }
            };
        }else{
            _header.tripLAbel.text = @"使用标签更容易上首页哦！";
            lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
            lineView.backgroundColor = APP_Gray_COLOR;
            [_header addSubview:lineView];
            _header.image.image = [UIImage imageNamed:@"标签"];
            _header.title.text = @"添加标签";
            _header.block = ^() {
                if (weakSelf.block) {
                    weakSelf.block(1);
                }
            };
       
        }
//        _header.layer.borderWidth = 1;
//        _header.layer.borderColor = APP_Gray_COLOR.CGColor;
        reusableView = _header;
    }
    return reusableView;
}
-(CGSize)collectionView: (UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection: (NSInteger)section{
    
    
    
    return CGSizeMake(SCREEN_WIDTH, 40);
    
}
#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FZChallageModel *model = self.dataArray[indexPath.section][indexPath.row];
    CGFloat width = [self getWidthWithText:model.tagTitle height:40 font:14];
    if ([self.dataArray[indexPath.section] count] == 0) {
       
        return  CGSizeMake((SCREEN_WIDTH-31)/4,CGFLOAT_MIN);
        
    }else
        if ([self.dataArray[0] count] > 0 && [self.dataArray[1] count]  == 0) {
             self.label.y = 120;
        }
    if ([self.dataArray[0] count] == 0 && [self.dataArray[1] count]  > 0) {
        self.label.y = 130;
    }
    if ([self.dataArray[0] count] >0 && [self.dataArray[1] count]  > 0) {
        self.label.y = 160;
    }
    if (indexPath.section == 0) {
         return  CGSizeMake(SCREEN_WIDTH,33);
    }
    
       return  CGSizeMake(width+20,33);
}

//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                     context:nil];
    return rect.size.width;
    
}

#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 50,5, 13);//（上、左、下、右）
}


#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        FZCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FZCollectionCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = self.dataArray[indexPath.section][indexPath.row];
        return cell;
    }else{
        FZTripCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FZTripCollectionViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = self.dataArray[indexPath.section][indexPath.row];
        return cell;
    }

    return nil;
}
#pragma mark  点击CollectionView触发事件
#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
@end
