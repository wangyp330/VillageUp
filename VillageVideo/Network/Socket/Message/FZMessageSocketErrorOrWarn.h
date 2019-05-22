//
//  FZMessageSocketErrorOrWarn.h
//  FZBaseLib
//
//  Created by Mac on 2018/8/15.
//  Copyright © 2018年 FZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FZMessageSocketErrorOrWarn : NSObject

-(void)errorWithErrorInfo:(NSDictionary *)errorInfo;
-(void)warnWithWarnInfo:(NSDictionary *)warnInfo;
@end
