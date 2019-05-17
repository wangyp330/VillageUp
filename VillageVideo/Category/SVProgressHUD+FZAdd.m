//
//  SVProgressHUD+FZAdd.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/24.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "SVProgressHUD+FZAdd.h"

@implementation SVProgressHUD (FZAdd)
+(void)showGif{
    [SVProgressHUD setMinimumDismissTimeInterval:MAXFLOAT];
    // 设置背景颜色为透明色
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    // 利用SVP提供类方法设置 通过UIImage分类方法返回的动态UIImage对象
    [SVProgressHUD showImage:[UIImage imageWithGIFNamed:@"间隔动画2"] status:@""];
    [SVProgressHUD setImageViewSize:CGSizeMake(150, 125)];
}
+(void)hidGif{
    [SVProgressHUD dismiss];
}
@end
