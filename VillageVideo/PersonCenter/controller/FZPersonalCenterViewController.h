//
//  FZPersonalCenterViewController.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/9/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZBaseViewController.h"

@interface FZPersonalCenterViewController : FZBaseViewController
@property(nonatomic,assign)BOOL isSelf;//是否是自己
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,assign)NSInteger  higth;
@property(nonatomic,strong) UserInfo *userModel;
@end
