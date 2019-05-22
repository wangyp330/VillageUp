//
//  FZClassSocketMgr.m
//  FZBaseLib
//
//  Created by Mac on 2018/7/26.
//  Copyright © 2018年 FZ. All rights reserved.
//

#import "FZClassSocketMgr.h"


@interface FZClassSocketMgr ()<FZWebSocketDelegate>


@end

@implementation FZClassSocketMgr
{
    WEBSOCKET_CONNECTION_TYPE _connectionType;
    NSDictionary *_receivedData;
}

+ (FZClassSocketMgr *)shareInstance
{
    static FZClassSocketMgr *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}


-(void)openClassSocket{
    _connectionType=WEBSOCKET_CONNECTION_TYPE_CLASS;
    if ([[FZWebSocketMgr shareInstance] isConnectedWithType:_connectionType])
    {
        NSLog(@"message socket is connected, return");
        return;
    }
    [[FZWebSocketMgr shareInstance] addSocketByType:_connectionType delegate:self];
}

-(void)closeClassSocket{
    [[FZWebSocketMgr shareInstance] closeWebSocketConnectionWithType:_connectionType];
}



#pragma mark - 私有方法
- (void)sendData:(NSDictionary *)data command:(NSString *)command{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *comondData = @{@"command":command,@"data":data};
        [[FZWebSocketMgr shareInstance] sendRequestWithData:comondData WithType:WEBSOCKET_CONNECTION_TYPE_CLASS];
    });
}

-(void)dealReceivedData:(NSDictionary *)data{
    
    if ([data objectForKey:@"infoResult"]) {
         NSDictionary *infoResultDic = [data objectForKey:@"infoResult"];
        [self dealInfoResultData:infoResultDic];
    }else{
        [self dealErrorAndWorningData:data];
    }
}

-(void)dealInfoResultData:(NSDictionary *)data{
    NSString *receiveCMD = [NSString stringWithFormat:@"%@",[data objectForKey:@"command"]];
    NSDictionary *receivedData = [data objectForKey:@"data"];
    NSLog(@"classSocketCommand:%@",receiveCMD);
    
    if ([self.delegate respondsToSelector:@selector(classSocketReceivedInfoResultCommand:receivedData:)]) {
        [self.delegate classSocketReceivedInfoResultCommand:receiveCMD receivedData:receivedData];
    }
}

-(void)dealErrorAndWorningData:(NSDictionary *)data{
    NSDictionary *errorResultDic=[data objectForKey:@"errorResult"];
    NSString *statusCode = [NSString stringWithFormat:@"%@", data[@"statusCode"]];
    
    if ([errorResultDic objectForKey:@"errorInfo"]) {
        NSDictionary *errorInfoDic= [errorResultDic objectForKey:@"errorInfo"];
        NSLog(@"classSocketErrorInfoMessage:%@",[errorInfoDic objectForKey:@"message"]);
    }
    if ([statusCode isEqualToString:@"-1"]) {
        //error
    }else if ([statusCode isEqualToString:@"0"]){
        //warning
    }
}


#pragma mark - 发送command & data

-(void)commandSend_teacherLoginWithClassCode:(NSString *)classCode classType:(NSString *)classType{
//    NSString *userId=[FZUserInfo sharedUtil].colUid;
//    NSNumber *userIdn= @([userId integerValue]);;
//    NSString *account=[FZUserInfo sharedUtil].userModel.colAccount;
//    NSString *password=[FZUserInfo sharedUtil].userModel.colPasswd;
//    NSDictionary *data = @{@"userId":userIdn,@"account":account, @"classCode":classCode, @"password":password,@"classType":classType};
//    [self sendData:data command:ClassSocketCMD_teacherLogin];
}
//同屏播放
-(void)synchronizationPlayerVideo:(NSString *)url  uuid:(NSString *)uuid{
     
}
-(void)commandSend_classOver{
    NSDictionary *data = @{};
    [self sendData:data command:ClassSocketCMD_classOver];
}

//课堂推送备课计划下的题目
-(void)commandSend_pushSubjecShowContentUrl:(NSString *)url{
    NSDictionary *data = @{@"sids":url};
    [self sendData:data command:ClassSocketCMD_pushSubjecShowContentUrl];
}

-(void)commandSend_class_pptWithControl:(NSInteger)control path:(NSString *)path{
    NSDictionary *data = @{@"control":[NSNumber numberWithInteger:control],@"html":path};
    [self sendData:data command:ClassSocketCMD_class_ppt];
}

//开启直播课
-(void)commandSend_teacherLiveClassWithTitle:(NSString *)title password:(NSString *)password coin:(NSInteger)coin{
//    NSString *account=[FZUserInfo sharedUtil].userModel.colAccount;
//    NSString *userId=[FZUserInfo sharedUtil].colUid;
//    NSString *mypassword=[FZUserInfo sharedUtil].userModel.colPasswd;
//    NSDictionary *data = @{@"account":account, @"userId":userId, @"password":mypassword,@"liveTitle":title,@"liveAntCoin":[NSNumber numberWithInteger:coin],@"livePassword":[NSString stringWithFormat:@"%@",password]};
//    [self sendData:data command:ClassSocketCMD_teacherLiveClass];
}

//锁屏
-(void)commandSend_screen_lock:(BOOL)isLock{
    NSDictionary *data = @{@"screen_lock":[NSNumber numberWithBool:isLock]};
    [self sendData:data command:ClassSocketCMD_screen_lock];
}

//考勤
-(void)commandSend_classKaoqin{
    NSDictionary *data = @{};
    [self sendData:data command:ClassSocketCMD_classKaoqin];
}

//踢人
-(void)commandSend_pushKickOffWithUserId:(NSString *)userId{
    NSDictionary *data = @{@"uid":userId};
    [self sendData:data command:ClassSocketCMD_pushKickOff];
}

#pragma mark - FZWebSocketDelegate
- (void)fzWebSocket:(FZWebSocketObject *)socketObj didReceiveMessage:(id)message{
    if (!(_connectionType == WEBSOCKET_CONNECTION_TYPE_CLASS)) {
        return;
    }
    [self dealReceivedData:message];
}

- (void)fzWebSocketDidOpen:(FZWebSocketObject *)socketObj{
    if (!(_connectionType == WEBSOCKET_CONNECTION_TYPE_CLASS)) {
        NSLog(@"打开socket不是class类型");
        return;
    }
    NSLog(@"didEstablishedWithType, forType:classSocket");
    
    if ([self.delegate respondsToSelector:@selector(classSocketConnectedSuccess)]) {
        [self.delegate classSocketConnectedSuccess];
    }
}

- (void)fzWebSocket:(FZWebSocketObject *)socketObj didFailWithError:(NSError *)error{
    
}

- (void)fzWebSocket:(FZWebSocketObject *)socketObj didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    
}

- (void)fzWebSocket:(FZWebSocketObject *)socketObj didReceivePong:(NSData *)pongPayload{
    
}

@end
