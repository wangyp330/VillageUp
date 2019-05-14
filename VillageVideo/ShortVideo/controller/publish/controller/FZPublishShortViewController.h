//
//  FZPublishShortViewController.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZBaseViewController.h"
@interface FZPublishShortViewController : FZBaseViewController
@property(nonatomic,strong)NSURL *viderPath;
@property(nonatomic,strong)NSString *viderType;//0 正常  1:跟拍
@property(nonatomic,strong)NSString *targetId;//视频ID
@property(nonatomic,strong)ShortVideoModel *model;//发布草稿内容
@property(nonatomic,strong)Tags *tagModel;
@end
