//
//  FZTools.m
//  watchManager
//
//  Created by Mac on 2019/3/26.
//  Copyright © 2019年 FZ. All rights reserved.
//

#import "FZTools.h"
#import "AppDelegate.h"

@implementation FZTools

+(float)navHeight{
    CGFloat height= 64;
    if ([FZTools isIphoneXSeries]) {
        height = 88;
    }
    return height;
}

+(float)tabbarHeight{
    CGFloat height= 49;
    if ([FZTools isIphoneXSeries]) {
        height = 83;
    }
    return height;
}

+ (BOOL)isIphoneXSeries{
    BOOL iPhoneXSeries = NO;
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    return iPhoneXSeries;
}
@end
