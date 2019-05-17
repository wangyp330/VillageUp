//
//  BaseCollectionViewController.h
//  PlayShortVideo
//
//  Created by missyun on 2018/8/1.
//  Copyright © 2018年 mac. All rights reserved.
//
#import "FZBaseViewController.h"

@interface BaseCollectionViewController : FZBaseViewController
@property(nonatomic,strong)NSArray *dataArray;//数据
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,assign)NSInteger number;
@end
