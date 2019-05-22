//
//  FZCollectionCell.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/23.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZChallageModel.h"
@protocol FZCollectionCellDelegate <NSObject>


@end
@interface FZCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property(nonatomic,strong)FZChallageModel *model;
@property(nonatomic,weak)id<FZCollectionCellDelegate> delegate;
@end
