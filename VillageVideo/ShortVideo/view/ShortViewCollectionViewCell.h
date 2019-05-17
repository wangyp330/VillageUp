//
//  ShortViewCollectionViewCell.h
//  PlayShortVideo
//
//  Created by missyun on 2018/7/31.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShortVideoModel.h"
@interface ShortViewCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property(nonatomic,strong)UILabel *laebl;
@property(nonatomic,strong)ShortVideoModel *model;
@property (weak, nonatomic) IBOutlet UIButton *lookCount;
@property (weak, nonatomic) IBOutlet UILabel *LikeCout;
@property (weak, nonatomic) IBOutlet UIButton *buttonView;
@property (weak, nonatomic) IBOutlet UIView *buttomView;
@property (weak, nonatomic) IBOutlet UIImageView *upImage;

@end
