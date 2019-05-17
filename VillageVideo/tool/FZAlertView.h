//
//  FZAlertView.h
//  FZBaseLib
//
//  Created by Mac on 2018/7/9.
//  Copyright © 2018年 FZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"

@class FZAlertView;
@protocol FZAlertViewDelegate

@optional
- (void)fzAlertViewButtonTouched:(FZAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface FZAlertView : NSObject <CustomIOSAlertViewDelegate>
@property (copy,nonatomic) void (^fzAlertViewButtonTouchedBlock)(FZAlertView *alertView, int buttonIndex) ;

//@property(nonatomic,weak)id<FZAlertViewDelegate>delegate;

-(instancetype)initWithButtonTitles:(NSArray *)titles title:(NSString *)title message:(NSString *)message;
-(instancetype)initWithFiledAlert;

-(void)setFzAlertViewButtonTouchedBlock:(void (^)(FZAlertView *alertView, int buttonIndex))fzAlertViewButtonTouchedBlock;

-(void)show;
-(void)close;


/*
 if (delegate != NULL) {
 [delegate customIOS7dialogButtonTouchUpInside:self clickedButtonAtIndex:[sender tag]];
 }
 
 if (onButtonTouchUpInside != NULL) {
 onButtonTouchUpInside(self, (int)[sender tag]);
 }
 */
@end
