//
//  FZPublishCollectionReusableHeaderView.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^selectBlock)(void);
@interface FZPublishCollectionReusableHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *tripLAbel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property(nonatomic,copy)selectBlock block;
@end
