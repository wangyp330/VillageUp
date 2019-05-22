//
//  FZUserInformation.h
//  LIttleAntForParent
//
//  Created by excoord on 2018/6/6.
//  Copyright © 2018年 FZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZUserModel.h"
@interface FZUserInformation : NSObject
+(instancetype)shareInstance;
-(FZUserModel *)userModel;
@end
