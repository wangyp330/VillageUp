//
//  FZMessageSocketMgr.m
//  FZBaseLib
//
//  Created by Mac on 2018/7/6.
//  Copyright © 2018年 FZ. All rights reserved.
//

#import "FZMessageSocketMgr.h"
#import "FZMessageSocketConstants.h"
#import <UIKit/UIKit.h>
#import "FZMessageSocketErrorOrWarn.h"
#import "FZArsycPlayVideoModel.h"
@interface FZMessageSocketMgr ()<FZWebSocketDelegate>


@end

@implementation FZMessageSocketMgr
{
    WEBSOCKET_CONNECTION_TYPE _connectionType;
    NSDictionary *_receivedData;
}

+ (FZMessageSocketMgr *)shareInstance
{
    static FZMessageSocketMgr *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}




#pragma mark - 公开方法

-(void)open{
    _connectionType=WEBSOCKET_CONNECTION_TYPE_MESSAGE;
    [self whetherLoginOpenSocket];
}

//连接 messageSocket
-(void)openMessageSocket{
    if ([[FZWebSocketMgr shareInstance] isConnectedWithType:_connectionType])
    {
        NSLog(@"message socket is connected, return");
        return;
    }
    [[FZWebSocketMgr shareInstance] addSocketByType:_connectionType delegate:self];
}

-(void)closeMessageSocket{
    [[FZWebSocketMgr shareInstance] closeWebSocketConnectionWithType:_connectionType];
}




#pragma mark - 私有方法

- (void)whetherLoginOpenSocket{
//    if (ISLogin){
//        NSLog(@"open message socket");
        [self openMessageSocket];
//    }else{
//        NSLog(@"App is't login, close message socket");
//        [self closeMessageSocket];
//    }
}

//发送command & data
- (void)sendData:(NSDictionary *)data command:(NSString *)command{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *comondData = @{@"command":command,@"data":data};
        [[FZWebSocketMgr shareInstance] sendRequestWithData:comondData WithType:WEBSOCKET_CONNECTION_TYPE_MESSAGE];
    });
}

//登录消息socket
-(void)loginMessageSocket{
//    NSString *machine = [FZCommonTools readUUIDFromKeychain];
//    NSString *userId = [FZUserInfo sharedUtil].colUid;
//    NSString *password = [FZUserInfo sharedUtil].userModel.colPasswd;
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *versionNumString = [[infoDictionary objectForKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""];
//    NSNumber *versionNum = [NSNumber numberWithInt:[versionNumString intValue]];
//    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
//
//    NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
//    [data setObject:machine forKey:@"machine"];
//    [data setObject:@"ios" forKey:@"machineType"];
//    [data setObject:[NSNumber numberWithInt:userId.intValue] forKey:@"userId"];
//    [data setObject:[NSNumber numberWithBool:NO] forKey:@"reconnect"];
//    [data setObject:password forKey:@"password"];
//    [data setObject:versionNum forKey:@"version"];
//    if (deviceToken && [deviceToken length] > 0)
//    {
//        [data setObject:deviceToken forKey:@"deviceToken"];
//    }
//    NSString *command = @"messagerConnect";
//    [self sendData:data command:command];
}

//处理收到数据中的 infoResult 中的data
-(void)dealReceivedInfoResultData:(NSDictionary *)data{
    
    if ([data objectForKey:@"infoResult"])
    {
        NSDictionary *infoResultData = [data objectForKey:@"infoResult"];
        NSString *command = [NSString stringWithFormat:@"%@",[infoResultData objectForKey:@"command"]];
        NSDictionary *data = [infoResultData objectForKey:@"data"];
        _receivedData = data;
        if ([command isEqualToString:@"arsyc_play_inited"])
        {
            FZArsycPlayVideoModel *model = [[FZArsycPlayVideoModel alloc]initWithDictionary:data error:nil];
                if ([self.delegate respondsToSelector:@selector(receivedSuccessMessage:)]) {
                    [self.delegate receivedSuccessMessage:model];
                }
        }
    }
//
//
//        if ([command isEqualToString:MessageSocketCMD_message])
//        {
//            NSMutableDictionary *messagedic = [NSMutableDictionary dictionaryWithDictionary:[data objectForKey:@"message"]];
//            FZChatMessageModel *messageModel=[[FZMessageInteractor shareInstance] dicTochatMessageModel:messagedic];
//
//            //第一时间回应服务器客户端已收到消息
//            [self dealCommand_messageRecievedResponsWithMessageArray:[NSArray arrayWithObjects:messageModel, nil]];
//
//            //对消息处理 消息中包好不同的command
//            [self dealMessage:messageModel];
//        }
//        else if ([command isEqualToString:MessageSocketCMD_messageList])
//        {
//            NSMutableArray *messages=[[NSMutableArray alloc]init];
//            NSArray *responseMessages=[[NSArray alloc]init];
//            responseMessages=[data objectForKey:@"messages"];
//            for (NSDictionary *keyDic in responseMessages) {
//                FZChatMessageModel *model=[[FZMessageInteractor shareInstance] dicTochatMessageModel:keyDic];
//                [messages addObject:model];
//            }
//            [self dealCommand_messageRecievedResponsWithMessageArray:messages];
//            [self dealMessageListMessages:messages];
//        }
//        else if ([command isEqualToString:MessageSocketCMD_messagerConnect])
//        {
//            //            [self dealMessages:data];
//            //            FZLocationManager *locationMgr=[FZLocationManager new];
//            //            [locationMgr startLocation];
//
//        }else if ([command isEqualToString:MessageSocketCMD_notify_class_opend])
//        {
//            //开课啦
//
//        }
//        else if ([command isEqualToString:MessageSocketCMD_client_open_link])
//        {
//            //收到服务器要求客户端打开链接
//
//        }else if ([command isEqualToString:MessageSocketCMD_chatgroup_update])//组织架构群主发生变化，通知去刷新云盘的数据
//        {
//            //            dispatch_async(dispatch_get_main_queue(), ^{
//            //                [[NSNotificationCenter defaultCenter] postNotificationName:@"notify_chatgroup_update" object:nil userInfo:nil];
//            //            });
//
//        }
//        else if ([command isEqualToString:MessageSocketCMD_clientLogout])//logout用户
//        {
//            //            [NDSUD setObject:@"0" forKey:RobotAnswerCount];
//            //            dispatch_async(dispatch_get_main_queue(), ^{
//            //                [[FZLoginMgr shareInstance] logout:^(BOOL success, NSString *msg) {
//            //                }];
//            //            });
//        }
//        else if ([command isEqualToString:MessageSocketCMD_clear_messages])
//        {
//            //清空消息列表
//
//        }
//    }
//    else if ([data objectForKey:@"errorResult"])
//    {
//        //处理 error
//        NSDictionary *errorResult = [data objectForKey:@"errorResult"];
//        if (errorResult)
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSString *errorMsg = [[errorResult objectForKey:@"message"] copy];
//                NSLog(@"error message:%@", errorMsg);
//                FZMessageSocketErrorOrWarn *error=[[FZMessageSocketErrorOrWarn alloc]init];
//                [error errorWithErrorInfo:[errorResult objectForKey:@"errorInfo"]];
//            });
//        }
//
//    }else if ([data objectForKey:@"warnResult"]){
//        NSDictionary *warningResult = [data objectForKey:@"warnResult"];
//        if (warningResult)
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSString *warnMsg = [[warningResult objectForKey:@"message"] copy];
//                NSLog(@"warn message:%@", warnMsg);
//                //[FZInfoAlertHelper showWarnAlertWithInfo:warnMsg];
//            });
//        }
//    }
}

-(void)dealMessageListMessages:(NSArray <FZChatMessageModel *> *)messages{
//    FZChatMessageModel *keyObj=[[FZChatMessageModel alloc]init];
//    for (NSInteger i=0; i<messages.count; i++) {
//        keyObj=[messages objectAtIndex:i];
//        [self dealMessage:keyObj];
//    }
}

//处理message中的command
-(void)dealMessage:(FZChatMessageModel*)model{
//    NSString *command=[NSString stringWithFormat:@"%@",model.command];
//    if ([command isEqualToString:MessageSocketCMD_messageRecievedResponse]) {
//          //回应服务器已收到消息
//
//    }else if ([command isEqualToString:MessageSocketCMD_message]){
//          //收到一条消息
//        [self dealCommand_message:model];
//
//    }else if ([command isEqualToString:MessageSocketCMD_biu_message]){
//
//        //[self dealCommand_BuiMessageWithDic:messagedic];
//
//    }else if ([command isEqualToString:MessageSocketCMD_retractMessage]){
//        //撤回消息
//
//    }else if ([command isEqualToString:MessageSocketCMD_message_read]){
//        //处理read
//        [self dealCommand_messageRead:model];
//    }else if ([command isEqualToString:@"user_punished"]){
//        //惩罚处理
////        if ([messagedic objectForKey:@"content"]) {
////            NSDictionary *contentDic=[messagedic objectForKey:@"content"];
////            [self user_punished:contentDic];
////        }
//    }else if ([command isEqualToString:@"COMMAND_DELETE_RECENT_MESSAGE"]){
////        //删除最近消息列表项
////        if (messagedic) {
////            [self removeUserRecentMessageByMessageDic:messagedic];
////        }
//    }else if ([command isEqualToString:MessageSocketCMD_COMMAND_DELETE_RECORD_MESSAGE]){
//        //删除某条消息
//
//    }else if ([command isEqualToString:MessageSocketCMD_robot_tip]){
//        //机器人提示
////        NSString *json=[NSString stringWithFormat:@"%@",[messagedic objectForKey:@"content"]];
////        if (json.length>5) {
////            [self dealRobotTipJson:json];
////        }
//    }
    
}





#pragma mark - 发送的commad

//回应服务器收到消息
-(void)sendCommad_messageRecievedResponsWithuuids:(NSMutableArray *)uuids{
    NSDictionary *data = @{@"uuids":uuids};
    [self sendData:data command:MessageSocketCMD_messageRecievedResponse];
}

#pragma mark - command 逻辑处理

//处理收到的消息
-(void)dealCommand_message:(FZChatMessageModel *)model{
//    //1-单聊，3-课堂聊天, 4-群聊
//    NSString *totype = [NSString stringWithFormat:@"%@",model.toType];
//    if ([totype isEqualToString:@"1"] || [totype isEqualToString:@"4"] ){
//
//        NSLog(@"收到的消息ttt%@",model.content);
//        [[FZMessageMgr shareInstance] db_saveChatMessageModel:model];
//        [[FZMessageListInteractor shareInstance] db_saveSessionWithChatMessageModel:model];
//    }
//    else if([totype isEqualToString:@"3"]){
//
//    }
//    if ([self.delegate respondsToSelector:@selector(receivedMessage:)]) {
//        [self.delegate receivedMessage:model];
//    }
}

//回应处理收到消息
-(void)dealCommand_messageRecievedResponsWithMessageArray:(NSArray <FZChatMessageModel *> *)messages{
//    NSMutableArray *messageUUIDs=[[NSMutableArray alloc]init];
//    for (FZChatMessageModel *keyObj in messages) {
//        NSString *uuid = [NSString stringWithFormat:@"%@",keyObj.uuid];
//        [messageUUIDs addObject:uuid];
//    }
//    [self sendCommad_messageRecievedResponsWithuuids:messageUUIDs];
}

//处理解散群消息
-(void)dealCommand_messageRead:(FZChatMessageModel *)model{
//    NSDictionary *jsonDic=[FZCommonTools dicByJson:model.content];
}


-(void)dealCommand_BuiMessageWithDic:(NSDictionary *)dic{
//    NSString *toId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"toId"]];
//
//    NSString *jsonStr;
//    if ([[FZUserInfo sharedUtil].colUid isEqualToString:toId]) {
//        jsonStr=[NSString stringWithFormat:@"%@",[messagedic objectForKey:@"content"]];
//    }
//
//    if (jsonStr.length > 0) {
//        NSError *err;
//        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary *jsondic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
//       if(err){
//        NSLog(@"json解析失败：%@",err);
//        return ;
//       }else{
//        FZBiuModel *model=[[FZBiuModel alloc]initWithDictionary:jsondic error:nil];
//        if ([model.user.colUid isEqualToString:[[FZUserInfoMgr shareInstance] userUid]]) {
//            //自己发的不处理
//            NSLog(@"我发的");
//
//        }else{
//            NSLog(@"我收到的");
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"sound_ding" ofType:@"wav"];
//            if (path) {
//                //注册声音到系统
//                AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &Ding_sound_id);
//                AudioServicesPlaySystemSound(Ding_sound_id);
//            }
//
//
//            if (model.messageUUID) {
//                [self dealBiuMessageWithBiuModel:model];
//            }
//
//            UIWindow *window=[UIApplication sharedApplication].keyWindow;
//            biuPushView= [FZPushBiuView shareInstance];
//            biuPushView.frame = CGRectMake(12,-UIDEVICE_SCREEN_WIDTH-20,UIDEVICE_SCREEN_WIDTH-24, BIU_PUSH_VIEW_HEIGHT);
//            [window addSubview:biuPushView];
//            biuPushView.model=model;
//            [FZPushBiuView show];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_FZMessageMgr_Ding_badge object:nil];
//        }
//     }
//    }
}




#pragma mark - FZWebSocketDelegate
- (void)fzWebSocket:(FZWebSocketObject *)socketObj didReceiveMessage:(id)message{
    if (!(_connectionType == WEBSOCKET_CONNECTION_TYPE_MESSAGE)) {
        return;
    }
    [self dealReceivedInfoResultData:message]; //处理收到的消息
}

- (void)fzWebSocketDidOpen:(FZWebSocketObject *)socketObj{
    if (!(_connectionType == WEBSOCKET_CONNECTION_TYPE_MESSAGE)) {
        NSLog(@"打开socket不是message类型");
        return;
    }
    NSLog(@"didEstablishedWithType, forType:message");
    [self loginMessageSocket];
}

- (void)fzWebSocket:(FZWebSocketObject *)socketObj didFailWithError:(NSError *)error{
    
}

- (void)fzWebSocket:(FZWebSocketObject *)socketObj didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    
}

- (void)fzWebSocket:(FZWebSocketObject *)socketObj didReceivePong:(NSData *)pongPayload{
    
}


#pragma mark - 发送command & data

//发送消息
- (void)sendMessage:(NSMutableDictionary*)messagedic{
    NSDictionary *data = @{@"command":messagedic};
    NSString *method = @"arsyc_play_inited";
    [self sendData:data command:method];
}
//发送消息
- (void)sendMessage:(NSMutableDictionary*)messagedic andmetho:(NSString *)methond{
    [self sendData:messagedic command:methond];
}
//消息已读未读
-(void)commandSendMessageReadWithUUID:(NSString *)uuid{
    
}
@end
