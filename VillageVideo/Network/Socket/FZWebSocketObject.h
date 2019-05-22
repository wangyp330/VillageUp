//
//  FZWebSocketObject.h
//  FZBaseLib
//
//  Created by Mac on 2018/7/6.
//  Copyright © 2018年 FZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket.h>


typedef NS_ENUM(NSInteger, WEBSOCKET_CONNECTION_TYPE)
{
    WEBSOCKET_CONNECTION_TYPE_CLASS = 0x100,
    WEBSOCKET_CONNECTION_TYPE_MESSAGE
};


@interface FZWebSocketObject : NSObject

@property (nonatomic, strong) SRWebSocket *webSocket;             //连接对象
@property (nonatomic, assign) WEBSOCKET_CONNECTION_TYPE connectionType;     //连接类型
@property (nonatomic, strong)   NSString *connectionURL;                      //连接URL
@property (nonatomic, assign) BOOL isConnected;

@property (nonatomic, assign) NSUInteger heartCount;//心跳时间 判断是否重连 3分钟没收到pong 
@end
