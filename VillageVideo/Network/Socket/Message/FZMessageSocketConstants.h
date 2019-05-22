//
//  FZMessageSocketConstants.h
//  FZBaseLib
//
//  Created by Mac on 2018/7/6.
//  Copyright © 2018年 FZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZMessageSocketConstants : NSObject

extern NSString * const MessageSocketCMD_message;  //消息

extern NSString * const MessageSocketCMD_messagerConnect;//

extern NSString * const MessageSocketCMD_messageList;  //消息列表
extern NSString * const MessageSocketCMD_messageRecievedResponse;  //消息收到回应服务器
extern NSString * const MessageSocketCMD_dissolutionChatGroup;  //解散群

extern NSString * const MessageSocketCMD_biu_message; //叮消息

extern NSString * const MessageSocketCMD_retractMessage; //消息撤回

extern NSString * const MessageSocketCMD_message_read; //已读未读

extern NSString * const MessageSocketCMD_COMMAND_DELETE_RECORD_MESSAGE;//删除某条消息

extern NSString * const MessageSocketCMD_robot_tip;//机器人提示

extern NSString * const MessageSocketCMD_notify_class_opend;//开课

extern NSString * const MessageSocketCMD_client_open_link;//收到服务器要求客户端打开链接 版本更新

extern NSString * const MessageSocketCMD_chatgroup_update;//组织架构群主发生变化，通知去刷新云盘的数据

extern NSString * const MessageSocketCMD_clientLogout;//用户退出

extern NSString * const MessageSocketCMD_clear_messages;//清空消息列表
extern NSString * const MessageSocketCMD_arsync_play;//同屏播放
@end
