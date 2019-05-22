//
//  FZChallengTableViewCell.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZChallageModel.h"
@interface FZChallengTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *numberPerson;
@property(nonatomic,strong)FZChallageModel *model;

@end
