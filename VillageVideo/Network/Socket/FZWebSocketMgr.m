//
//  FZSocketMgr.m
//  FZBaseLib
//
//  Created by Mac on 2018/7/5.
//  Copyright © 2018年 FZ. All rights reserved.
//

#import "FZWebSocketMgr.h"

static NSString *const heartBeatPing = @"ping_0123456789_abcdefg";
static NSString *const heartBeatPong = @"pong_0123456789_abcdefg";

@interface FZWebSocketMgr () <SRWebSocketDelegate>


@end

@implementation FZWebSocketMgr
{
    NSTimer *heartBeatTimer;
    NSUInteger heartCount;
    NSUInteger reConnectTime; //3分钟
}

static FZWebSocketMgr *instance = nil;
+ (FZWebSocketMgr *)shareInstance
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[FZWebSocketMgr alloc]init];
    });
    return instance;
}


//+ (instancetype)allocWithZone:(struct _NSZone *)zone
//{
//    return [self shareInstance];
//}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
//        [FZNetMgr shareInstance];
//        [self netStateMgrBlocks];
    }
    return self;
}


//网络变化block
-(void)netStateMgrBlocks{
//    [FZNetMgr shareInstance].netStateChange = ^(BOOL isCanUserd) {
//        [self changeSocketState:NO];
//        if (isCanUserd) {
            [self reconnectSocket];
//        }
//    };
}

#pragma mark - socket相关
-(void)addSocketByType:(WEBSOCKET_CONNECTION_TYPE)type delegate:(id)delegate{
    self.delegate=delegate;
    [self addDelegate:delegate withType:type];
    FZWebSocketObject *socketObj=[self findSocketByType:type];
    socketObj.connectionType=type;
    socketObj.webSocket.delegate=nil;
    [socketObj.webSocket close];
//    if (type == WEBSOCKET_CONNECTION_TYPE_MESSAGE) {
//        socketObj.connectionURL=@"wss://www.maaee.com:7891/Excoord_SimpleWsServer/simple";
//    }else if (type == WEBSOCKET_CONNECTION_TYPE_CLASS){
         socketObj.connectionURL=@"wss://www.maaee.com:7891/Excoord_SimpleWsServer/simple";
//    }
    socketObj.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:socketObj.connectionURL]]];
    socketObj.isConnected=NO;
    socketObj.webSocket.delegate = self;
    [self addOrReplaceSocketObject:socketObj];
    [socketObj.webSocket open];
}

-(void)reconnectSocket{
    FZWebSocketObject *keyObj=[[FZWebSocketObject alloc]init];
    for (NSInteger i=0; i<self.totalConnections.count; i++) {
        keyObj=[self.totalConnections objectAtIndex:i];
        if (!keyObj.isConnected) {
            keyObj.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:keyObj.connectionURL]]];
            keyObj.isConnected=NO;
            keyObj.webSocket.delegate = self;
            [keyObj.webSocket open];
        }
    }
}

- (void)closeWebSocketConnectionWithType:(WEBSOCKET_CONNECTION_TYPE)connectionType
{
    FZWebSocketObject *obj = [self findSocketByType:connectionType];
    [self deleteSocketObj:obj];
}

//发送字典类型数据
- (void)sendRequestWithData:(NSDictionary *)data WithType:(WEBSOCKET_CONNECTION_TYPE)connectionType{
    BOOL isConnected =[self isConnectedWithType:connectionType];
    if (!isConnected) {
        NSString *typeName;
        if (connectionType == WEBSOCKET_CONNECTION_TYPE_CLASS) {
            typeName=@"课堂";
        }
        if (connectionType == WEBSOCKET_CONNECTION_TYPE_MESSAGE) {
            typeName=@"消息";
        }
        NSLog(@"%@Socket未链接....",typeName);
        return;
    }
    NSError *error;
    NSData *jsonSendData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonSendString =[[NSString alloc] initWithData:jsonSendData encoding:NSUTF8StringEncoding];
    jsonSendData = nil;
    FZWebSocketObject *obj= [self findSocketByType:connectionType];
    [obj.webSocket send:jsonSendString];
    NSLog(@"%@--SocketSend:%@",obj.connectionURL,jsonSendString);
}

//发送id 类型数据
-(void)send:(id)sender connectType:(WEBSOCKET_CONNECTION_TYPE)type{
    FZWebSocketObject *obj = [self findSocketByType:type];
    [obj.webSocket send:sender];
}

- (BOOL)isConnectedWithType:(WEBSOCKET_CONNECTION_TYPE)type
{
    FZWebSocketObject *obj = [self findSocketByType:type];
    return obj.isConnected;
}


#pragma mark - 私有方法

//添加socket对象
-(void)addOrReplaceSocketObject:(FZWebSocketObject *)obj{
    BOOL isReplace=NO;
    NSInteger replaceIndex=0;
    FZWebSocketObject *keyObj=[[FZWebSocketObject alloc]init];
    for (NSInteger i=0; i<self.totalConnections.count; i++) {
        keyObj=[self.totalConnections objectAtIndex:i];
        if (keyObj.connectionType == obj.connectionType) {
            isReplace=YES;
            replaceIndex=i;
            break;
        }
    }
    if (isReplace) {
        [self.totalConnections replaceObjectAtIndex:replaceIndex withObject:obj];
    }else{
        [self.totalConnections addObject:obj];
    }
}

-(void)deleteSocketObj:(FZWebSocketObject *)obj{
    BOOL isDelete=NO;
    NSInteger delIndex=0;
    FZWebSocketObject *keyObj=[[FZWebSocketObject alloc]init];
    for (NSInteger i=0; i<self.totalConnections.count; i++) {
        keyObj=[self.totalConnections objectAtIndex:i];
        if (keyObj.connectionType == obj.connectionType) {
            isDelete=YES;
            delIndex=i;
            break;
        }
    }
    if (isDelete) {
        [self.totalConnections removeObjectAtIndex:delIndex];
    }
}

//根据type获取当前socket 对象
-(FZWebSocketObject *)findSocketByType:(WEBSOCKET_CONNECTION_TYPE)type{
    FZWebSocketObject *socketObj=[[FZWebSocketObject alloc]init];
    FZWebSocketObject *keyObj=[[FZWebSocketObject alloc]init];
    for (NSInteger i=0; i<self.totalConnections.count; i++) {
        keyObj=[self.totalConnections objectAtIndex:i];
        if (keyObj.connectionType == type) {
            socketObj=keyObj;
            break;
        }
    }
    return socketObj;
}


//根据SRWebSocket对象查找FZWebSocketObject
-(FZWebSocketObject *)findSocketBySocket:(SRWebSocket *)srWebSocket{
    FZWebSocketObject *findedWebSocketObj = [[FZWebSocketObject alloc]init];
    for (FZWebSocketObject *keyObj in self.totalConnections)
    {
        if ([keyObj.webSocket isEqual:srWebSocket])
        {
            findedWebSocketObj = keyObj;
            break;
        }
    }
    return findedWebSocketObj;
}

//修改所有socket的状态为关闭
-(void)changeSocketState:(BOOL)state{
    FZWebSocketObject *keyObj=[[FZWebSocketObject alloc]init];
    for (NSInteger i=0; i<self.totalConnections.count; i++) {
        keyObj=[self.totalConnections objectAtIndex:i];
        keyObj.isConnected=state;
        [self.totalConnections replaceObjectAtIndex:i withObject:keyObj];
    }
}

-(void)replaceSocketObjWithObj:(FZWebSocketObject *)obj{
    FZWebSocketObject *keyObj=[[FZWebSocketObject alloc]init];
    for (NSInteger i=0; i<self.totalConnections.count; i++) {
        keyObj=[self.totalConnections objectAtIndex:i];
        if (keyObj.connectionType == obj.connectionType) {
            [self.totalConnections replaceObjectAtIndex:i withObject:obj];
        }
        
    }
}

- (void)addDelegate:(id<FZWebSocketDelegate>)delegate withType:(WEBSOCKET_CONNECTION_TYPE)connectionType{
    if (nil == delegate)
    {
        NSLog(@"delegate is nil, return");
        return;
    }
    id<FZWebSocketDelegate> findDelegate = [self findDelegateWithType:connectionType];
    if (nil == findDelegate)
    {
        NSString *key = [NSString stringWithFormat:@"%ld", (long)connectionType];
        NSDictionary *dict = @{key:delegate};
        [self.delegates addObject:dict];
    }
}

- (id<FZWebSocketDelegate>)findDelegateWithType:(WEBSOCKET_CONNECTION_TYPE)connectionType
{
    id<FZWebSocketDelegate> delegateTmp = nil;
    for (NSDictionary *dict in self.delegates)
    {
        NSString *queryKey = [NSString stringWithFormat:@"%ld", (long)connectionType];
        if ([[dict allKeys] containsObject:queryKey])
        {
            delegateTmp = [dict objectForKey:queryKey];
        }
    }
    return delegateTmp;
}

#pragma mark - 心跳包
-(void)starHeart{
    [self addTimerForHearBeat];
}

-(void)addTimerForHearBeat{
    heartBeatTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(heatBeatMethod) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:heartBeatTimer forMode:NSRunLoopCommonModes];
}

-(void)heatBeatMethod{
    heartCount++;
    if (heartCount==60) {
        heartCount=0;
        FZWebSocketObject *keyObj=[[FZWebSocketObject alloc]init];
        for (NSInteger i=0; i<self.totalConnections.count; i++) {
            keyObj=[self.totalConnections objectAtIndex:i];
            [keyObj.webSocket send:heartBeatPing];
            NSLog(@"ping Servers");
        }
    }
    
    FZWebSocketObject *keyObj=[[FZWebSocketObject alloc]init];
    for (NSInteger i=0; i<self.totalConnections.count; i++) {
        keyObj=[self.totalConnections objectAtIndex:i];
        keyObj.heartCount++;
        [self replaceSocketObjWithObj:keyObj];
        
        if (keyObj.heartCount > (3*60)) {
            keyObj.isConnected=NO;
            keyObj.heartCount=0;
            [self replaceSocketObjWithObj:keyObj];
            [self reconnectSocket];
        }
        
    }
}


#pragma mark - SRWEBSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    
    FZWebSocketObject * obj =[self findSocketBySocket:webSocket];
    
    if (!obj.isConnected) {
        obj.isConnected=YES;
        [self replaceSocketObjWithObj:obj];
    }
    
    if ([message isKindOfClass:[NSString class]]) {
        if ([message isEqualToString:heartBeatPing]) {
            //收到ping
            NSLog(@"%@--收到ping",obj.connectionURL);
            [obj.webSocket send:heartBeatPong];
            obj.heartCount=0;
            [self replaceSocketObjWithObj:obj];
        }else if ([message isEqualToString:heartBeatPong]){
            //收到pong
            NSLog(@"%@--收到Pong",obj.connectionURL);
        }
    }
    
    NSError *error = nil;
    NSDictionary *receivedDic = [NSJSONSerialization  JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding]  options:NSJSONReadingMutableLeaves  error:&error];
    NSLog(@"%@--socketReceived is:%@",webSocket.url,receivedDic);
    if (nil == receivedDic)
    {
       
        return;
    }
    self.delegate = [self findDelegateWithType:obj.connectionType];
    if ([self.delegate respondsToSelector:@selector(fzWebSocket:didReceiveMessage:)]) {
        [self.delegate fzWebSocket:obj didReceiveMessage:receivedDic];
    }
}


- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    FZWebSocketObject * obj =[self findSocketBySocket:webSocket];
    obj.isConnected=YES;
    [self replaceSocketObjWithObj:obj];
    self.delegate = [self findDelegateWithType:obj.connectionType];
    if ([self.delegate respondsToSelector:@selector(fzWebSocketDidOpen:)]) {
        [self.delegate fzWebSocketDidOpen:obj];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    FZWebSocketObject * obj =[self findSocketBySocket:webSocket];
    obj.isConnected=NO;
    [self replaceSocketObjWithObj:obj];
    self.delegate = [self findDelegateWithType:obj.connectionType];
    if ([self.delegate respondsToSelector:@selector(fzWebSocket:didFailWithError:)]) {
        [self.delegate fzWebSocket:obj didFailWithError:error];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    FZWebSocketObject * obj =[self findSocketBySocket:webSocket];
    obj.isConnected=NO;
    [self deleteSocketObj:obj];
    
    self.delegate = [self findDelegateWithType:obj.connectionType];
    if ([self.delegate respondsToSelector:@selector(fzWebSocket:didCloseWithCode:reason:wasClean:)]) {
        [self.delegate fzWebSocket:obj didCloseWithCode:code reason:reason wasClean:wasClean];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    FZWebSocketObject * obj =[self findSocketBySocket:webSocket];
    NSLog(@"didReceivePong, forType:%ld", (long)obj.connectionType);
    
    self.delegate = [self findDelegateWithType:obj.connectionType];
    if ([self.delegate respondsToSelector:@selector(fzWebSocket:didReceivePong:)]) {
        [self.delegate fzWebSocket:obj didReceivePong:pongPayload];
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)totalConnections
{
    if (!_totalConnections)
    {
        _totalConnections = [[NSMutableArray alloc] init];
    }
    return _totalConnections;
}

-(NSMutableArray *)delegates{
    if (!_delegates) {
        _delegates=[[NSMutableArray alloc]init];
    }
    return _delegates;
}

@end
