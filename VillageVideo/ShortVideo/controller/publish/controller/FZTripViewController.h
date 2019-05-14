//
//  FZTripViewController.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZBaseViewController.h"
@protocol FZTripViewControllerDelegate <NSObject>

-(void)didSelectTrip:(NSArray  *)array;

@end
@interface FZTripViewController : FZBaseViewController
@property(nonatomic,weak)id<FZTripViewControllerDelegate> delegate;
@property(nonatomic,strong)NSArray * dataSource;
@end
