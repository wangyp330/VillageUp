//
//  FZShrotDiscussInfoLisViewCell.h
//  LittentAntShortVideo
//
//  Created by mac on 2018/8/4.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZShortVideoDiscussModel.h"
#import <UIImageView+WebCache.h>
@interface FZShrotDiscussInfoLisViewCell : UITableViewCell
@property(nonatomic,strong)FZShortVideoDiscussModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *userHeader;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *isLike;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
