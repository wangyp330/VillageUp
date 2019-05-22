//
//  OwenProductViewController.h
//  PlayShortVideo
//
//  Created by missyun on 2018/8/1.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BaseCollectionViewController.h"

@interface OwenProductViewController : BaseCollectionViewController
@property(nonatomic,strong)NSString *method;
@property(nonatomic,assign)NSInteger headHigth;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *isContainsDraft;//是否包含草稿箱 1.包含（自己） 0.不包含（别人）
@end
