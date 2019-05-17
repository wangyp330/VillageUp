//
//  FZLookFansViewController.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZBaseViewController.h"

@interface FZLookFansViewController : FZBaseViewController
@property(nonatomic,assign)NSInteger type;//0:粉丝1.关注 3.审核
@property(nonatomic,strong)NSString *userId;
@end
