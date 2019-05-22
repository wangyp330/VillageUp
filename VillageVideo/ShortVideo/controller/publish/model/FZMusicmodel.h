//
//  FZMusicmodel.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "JSONModel.h"

@interface FZMusicmodel :JSONModel
@property (nonatomic , copy) NSString              * uid;
@property (nonatomic , copy) NSString              * musicUrl;
@property (nonatomic , copy) NSString              * musicName;
@property (nonatomic , copy) NSString              * useCount;
@property (nonatomic , copy) NSString              * musicMan;
@property (nonatomic , copy) NSString              * musicId;
@property (nonatomic , copy) NSString              * cover;

@end
