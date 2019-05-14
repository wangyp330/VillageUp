//
//  FZPersonCenterViewController.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZBaseViewController.h"
#import "ShortVideoModel.h"
@interface FZPersonCenterViewController : FZBaseViewController
@property(nonatomic,assign)BOOL isSelf;//是否是自己
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,assign)NSInteger  higth;
@property(nonatomic,strong) UserInfo *userModel;
@end
