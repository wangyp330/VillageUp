//
//  FZSocketMgr.h
//  FZBaseLib
//
//  Created by Mac on 2018/7/5.
//  Copyright © 2018年 FZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZWebSocketObject.h"


@protocol FZWebSocketDelegate <NSObject>

@optional
- (void)fzWebSocket:(FZWebSocketObject *)socketObj didReceiveMessage:(id)message;


- (void)fzWebSocketDidOpen:(FZWebSocketObject *)socketObj;

- (void)fzWebSocket:(FZWebSocketObject *)socketObj didFailWithError:(NSError *)error;

- (void)fzWebSocket:(FZWebSocketObject *)socketObj didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;

- (void)fzWebSocket:(FZWebSocketObject *)socketObj didReceivePong:(NSData *)pongPayload;

@end


@interface FZWebSocketMgr : NSObject

#pragma mark - startBlock
//@property(nonatomic,copy) void (^reconnectSocketBlock)(void);

#pragma mark - endBlock


@property(nonatomic,weak)id<FZWebSocketDelegate>delegate;
@property(nonatomic,strong)NSMutableArray *delegates;//管理delegate对象
@property (nonatomic, strong) NSMutableArray<FZWebSocketObject *> *totalConnections; //当前管理的所有连接对象信息

+ (FZWebSocketMgr*)shareInstance;


-(void)starHeart;//开始心跳

//增加打开socket
-(void)addSocketByType:(WEBSOCKET_CONNECTION_TYPE)type delegate:(id)delegate;

//关闭socket
- (void)closeWebSocketConnectionWithType:(WEBSOCKET_CONNECTION_TYPE)connectionType;

//socket 状态
- (BOOL)isConnectedWithType:(WEBSOCKET_CONNECTION_TYPE)type;

//socket 发送数据dic
- (void)sendRequestWithData:(NSDictionary *)data WithType:(WEBSOCKET_CONNECTION_TYPE)connectionType;

//发送id 类型数据
-(void)send:(id)sender connectType:(WEBSOCKET_CONNECTION_TYPE)type;
@end
