//
//  FZPublishSelectChallageTripView.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZChallageModel.h"
@protocol delectSomeTripDelegate <NSObject>

-(void)delectSomeTrtp:(FZChallageModel *)model;

@end
typedef void(^actionBlock)(int index);
@interface FZPublishSelectChallageTripView : UIView
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;//数据
@property(nonatomic,copy)actionBlock block;
@property(nonatomic,weak)id<delectSomeTripDelegate> delegate;
@end
