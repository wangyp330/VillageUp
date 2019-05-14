//
//  FZShortVideolikeAnimation.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/20.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FZShortVideolikeAnimation : NSObject
/**  获取单例对象*/
+ (instancetype)shareInstance;

/**  系统touch来触发的动画*/
- (void)createAnimationWithTouch:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

/**  点击来触发的动画*/
- (void)createAnimationWithTap:(UITapGestureRecognizer *)tap;
@end
