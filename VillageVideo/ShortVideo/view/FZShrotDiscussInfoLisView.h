//
//  FZShrotDiscussInfoLisView.h
//  LittentAntShortVideo
//
//  Created by mac on 2018/8/4.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FZShrotDiscussInfoLisViewDelegate <NSObject>

-(void)didMissFZShrotDiscussInfoLisView;
-(void)writeDisCuss:(NSString *)targetID;
@end
@interface FZShrotDiscussInfoLisView : UIView
@property(nonatomic,weak)id<FZShrotDiscussInfoLisViewDelegate>delegate;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)NSString  *targetId;;
@property(nonatomic,strong)UITableView *tableview;
@end
