//
//  FZTripCollectionViewCell.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZChallageModel.h"
@protocol FZTripCollectionViewCellDelegate <NSObject>


@end
@interface FZTripCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property(nonatomic,weak)id<FZTripCollectionViewCellDelegate> delegate;
@property(nonatomic,strong)FZChallageModel *model;
@end
