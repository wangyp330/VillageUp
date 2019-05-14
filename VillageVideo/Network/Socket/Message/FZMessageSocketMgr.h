//
//  FZMessageSocketMgr.h
//  FZBaseLib
//
//  Created by Mac on 2018/7/6.
//  Copyright © 2018年 FZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZWebSocketMgr.h"
#import "FZArsycPlayVideoModel.h"
@class FZChatMessageModel;

@protocol FZMessageSocketDelegate <NSObject>

-(void)receivedMessage:(FZChatMessageModel *)model;
-(void)receivedSuccessMessage:(FZArsycPlayVideoModel *)model;
@optional
@end




@interface FZMessageSocketMgr : NSObject


@property(nonatomic,weak)id<FZMessageSocketDelegate>delegate;
/**
 *  单例模式
 */
+ (FZMessageSocketMgr *)shareInstance;


-(void)open; //打开

//连接 messageSocket
-(void)openMessageSocket;

-(void)closeMessageSocket;



#pragma mark - 发送command & data
//发送消息
- (void)sendMessage:(NSMutableDictionary*)messagedic andmetho:(NSString *)methond;
//发送消息
- (void)sendMessage:(NSMutableDictionary*)messagedic;

//消息已读未读
-(void)commandSendMessageReadWithUUID:(NSString *)uuid;

@end
