//
//  FZMessageSocketErrorOrWarn.m
//  FZBaseLib
//
//  Created by Mac on 2018/8/15.
//  Copyright © 2018年 FZ. All rights reserved.
//

#import "FZMessageSocketErrorOrWarn.h"

@implementation FZMessageSocketErrorOrWarn
{
    NSString *_errorCode;
    NSString *_errorMessage;
}

-(void)errorWithErrorInfo:(NSDictionary *)errorInfo{
    _errorCode=[NSString stringWithFormat:@"%@",[errorInfo objectForKey:@"errorCode"]];
    _errorMessage=[NSString stringWithFormat:@"%@",[errorInfo objectForKey:@"message"]];
    if([_errorCode isEqualToString:@"-1"]){
        //账号互挤
//        FZAlertView *alertView=[[FZAlertView alloc]initWithButtonTitles:[NSArray arrayWithObjects:@"确定", nil] title:_errorMessage message:nil];
//        [alertView setFzAlertViewButtonTouchedBlock:^(FZAlertView *alertView, int buttonIndex) {
//            [alertView close];
//        }];
//        [alertView show];
    }
}

-(void)warnWithWarnInfo:(NSDictionary *)warnInfo{
    
}
@end
