//
//  FZChallengAndTripViewController.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZBaseViewController.h"
#import "ShortVideoModel.h"
#import "FZChallageModel.h"
@protocol FZChallengAndTripViewControllerDelegate <NSObject>

-(void)didSelectClass:(FZChallageModel *)model;

@end
@interface FZChallengAndTripViewController : FZBaseViewController
@property(nonatomic,weak)id<FZChallengAndTripViewControllerDelegate> delegate;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end
