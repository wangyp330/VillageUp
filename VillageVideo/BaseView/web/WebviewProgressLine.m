//
//  WebviewProgressLine.m
//  LittleAnts
//
//  Created by excoord on 2017/11/7.
//  Copyright © 2017年 com.excoord. All rights reserved.
//

#import "WebviewProgressLine.h"
#import "UIView+ZFFrame.h"
@implementation WebviewProgressLine

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    self.backgroundColor = lineColor;
}

-(void)startLoadingAnimation{
    self.hidden = NO;
    CGRect frame = self.frame;
    frame.size.width = 0.0;
    self.frame = frame;
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = self.frame;
        frame.size.width = self.fullWidth * 0.6;
        self.frame = frame;
        weakSelf.frame = frame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            CGRect frame = self.frame;
            frame.size.width = self.fullWidth * 0.8;
            self.frame = frame;
        }];
    }];
    
    
}

-(void)endLoadingAnimation{
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = self.frame;
        frame.size.width = self.fullWidth;
        self.frame = frame;        
    } completion:^(BOOL finished) {
        weakSelf.hidden = YES;
    }];
}

@end
