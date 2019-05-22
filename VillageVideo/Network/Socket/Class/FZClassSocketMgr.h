//
//  FZClassSocketMgr.h
//  FZBaseLib
//
//  Created by Mac on 2018/7/26.
//  Copyright © 2018年 FZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZWebSocketMgr.h"
#import "FZClasssSocketConstants.h"

@protocol FZClassSocketDelegate <NSObject>

@optional
-(void)classSocketConnectedSuccess;

-(void)classSocketReceivedInfoResultCommand:(NSString *)command receivedData:(NSDictionary *)receivedData;
@end

@interface FZClassSocketMgr : NSObject

@property(nonatomic,weak)id<FZClassSocketDelegate>delegate;

+ (FZClassSocketMgr *)shareInstance;

-(void)openClassSocket;

-(void)closeClassSocket;

#pragma mark - 发送command & data

//老师登录课堂
-(void)commandSend_teacherLoginWithClassCode:(NSString *)classCode classType:(NSString *)classType;

//下课
-(void)commandSend_classOver;

//课堂推送备课计划下的题目
-(void)commandSend_pushSubjecShowContentUrl:(NSString *)url;

//课堂使用课件
-(void)commandSend_class_pptWithControl:(NSInteger)control path:(NSString *)path;

//开启直播课
-(void)commandSend_teacherLiveClassWithTitle:(NSString *)title password:(NSString *)password coin:(NSInteger)coin;

//锁屏
-(void)commandSend_screen_lock:(BOOL)isLock;

//考勤
-(void)commandSend_classKaoqin;

//踢人
-(void)commandSend_pushKickOffWithUserId:(NSString *)userId;

//同屏播放
-(void)synchronizationPlayerVideo:(NSString *)url  uuid:(NSString *)uuid;


@end
