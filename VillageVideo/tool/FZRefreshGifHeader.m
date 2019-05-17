//
//  FZRefreshGifHeader.m
//  LittleAnts
//
//  Created by wukai on 2017/6/2.
//  Copyright © 2017年 com.excoord. All rights reserved.
//

#import "FZRefreshGifHeader.h"
#import "UIColor+Hex.h"

@implementation FZRefreshGifHeader

- (void)prepare
{
    [super prepare];
    self.lastUpdatedTimeLabel.hidden = YES;
    [self setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    self.stateLabel.font = [UIFont systemFontOfSize:12];
    self.stateLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.arrowView.image = nil;
    self.labelLeftInset = 15;
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
}

@end
