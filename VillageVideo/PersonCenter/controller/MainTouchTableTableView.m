//
//  MainTouchTableTableView.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/9/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MainTouchTableTableView.h"

@implementation MainTouchTableTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
