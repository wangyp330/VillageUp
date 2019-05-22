//
//  BiningTableviewViewController.h
//  PlayShortVideo
//
//  Created by missyun on 2018/8/1.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZBaseViewController.h"
typedef void(^selectBlock)(id model);
@interface BiningTableviewViewController : FZBaseViewController
@property(nonatomic,strong)NSString *method;
@property(nonatomic,copy)selectBlock selectBlock;
@end
