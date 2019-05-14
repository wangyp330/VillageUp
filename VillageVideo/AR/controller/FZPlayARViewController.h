//
//  FZPlayARViewController.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZShowARClassView.h"
#import <MediaPlayer/MediaPlayer.h>
typedef void(^dismBck)(void);
@interface FZPlayARViewController : UIViewController
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)NSArray *VideoArray;
@property(nonatomic,strong) NSString  *uuid;
@property(nonatomic,copy)dismBck dismBck;
@property(nonatomic,strong)MPMoviePlayerController *mPMoviePlayerController;;
@end
