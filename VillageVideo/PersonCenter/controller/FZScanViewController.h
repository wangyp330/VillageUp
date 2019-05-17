//
//  FZScanViewController.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZBaseViewController.h"
typedef void(^uuidBlock)(NSString *uuid);
@interface FZScanViewController : FZBaseViewController
@property(nonatomic,copy)uuidBlock uuidBlock;
@end
