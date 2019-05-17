//
//  FZChallengeViewController.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZChallengeViewController.h"

@interface FZChallengeViewController ()

@end

@implementation FZChallengeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestrt];
}
-(void)requestrt{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:@(-1) forKey:@"pageNo"];
    [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"tagContent"];
     [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"tagType"];
    [FZNetworkingManager requestLittleAntMethod:@"getTagsByContent" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
 
        NSLog(@"");
       
    }];
    
}
#pragma maek 数据
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray =[[NSMutableArray alloc]init];
        
    }
    return _dataArray;
}
@end
