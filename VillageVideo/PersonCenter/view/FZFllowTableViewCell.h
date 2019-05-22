//
//  FZFllowTableViewCell.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZFllowModel.h"
#import "FZUserModel.h"
@interface FZFllowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headimGE;
@property (weak, nonatomic) IBOutlet UILabel * NAMElaabel;
@property(nonatomic,strong)FZFllowModel *model;
@property(nonatomic,assign)NSInteger type;//0:粉丝1.关注 3.审核
@property (weak, nonatomic) IBOutlet UIButton *attemntBtn;
@property(nonatomic,strong)FZUserModel *mmm;
@end
