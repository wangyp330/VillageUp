//
//  FZStartViewController.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZBaseViewController.h"
#import "FZChallageModel.h"
typedef void(^challage)(FZChallageModel *model);
@interface FZStartViewController : FZBaseViewController
@property(nonatomic,strong)NSString *titleaa;

@property (nonatomic, copy) challage block;
@end
