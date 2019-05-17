//
//  FZUserInformation.m
//  LIttleAntForParent
//
//  Created by excoord on 2018/6/6.
//  Copyright © 2018年 FZ. All rights reserved.
//

#import "FZUserInformation.h"

@implementation FZUserInformation
static FZUserInformation* _instance = nil;

+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    return _instance ;
}

-(FZUserModel *)userModel{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary  *userInfo = [userDef objectForKey:@"userInfo"];
    FZUserModel *mm ;
    if (userInfo.count > 0) {
        mm = [[FZUserModel alloc]initWithDictionary:userInfo error:nil];
    }
    return mm;
}
@end
