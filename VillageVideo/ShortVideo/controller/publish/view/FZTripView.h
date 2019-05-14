//
//  FZTripView.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZChallageModel.h"
@protocol FZTripViewDelegate <NSObject>

-(void)tripViewDidTip:(NSString *)tripTitle tag:(NSInteger )tag;

@end
@interface FZTripView : UIView
-(instancetype)initWithTitle:(NSString *)title tag:(NSInteger)tag;
@property(nonatomic,weak)id<FZTripViewDelegate> delegate;
@end
