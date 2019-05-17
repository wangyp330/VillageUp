//
//  FZDraftTableViewCell.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/16.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShortVideoModel.h"
#import <YYWebImage.h>
@interface FZDraftTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UITextView *textvuew;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property(nonatomic,strong)ShortVideoModel *model;
@end
