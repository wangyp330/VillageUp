//
//  WebviewProgressLine.h
//  LittleAnts
//
//  Created by excoord on 2017/11/7.
//  Copyright © 2017年 com.excoord. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebviewProgressLine : UIView
//进度条颜色
@property (nonatomic,strong) UIColor  *lineColor;

@property (nonatomic,assign) CGFloat fullWidth; //满条宽度

//开始加载
-(void)startLoadingAnimation;

//结束加载
-(void)endLoadingAnimation;
@end
