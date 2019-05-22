//
//  FZNetworkingManager.m
//  LIttleAntForParent
//
//  Created by Mac on 2018/6/4.
//  Copyright © 2018年 FZ. All rights reserved.
//

#import "FZNetworkingManager.h"
#import <AFNetworking.h>
#import <UIKit+AFNetworking.h>
#import "MBProgressHUD+Add.h"
#import "FZuUrlHeader.h"
@interface FZNetworkingManager(){
    
}

@end
@implementation FZNetworkingManager{
    AFHTTPSessionManager *manager;
}

+ (FZNetworkingManager *)sharedUtil {
    
    static dispatch_once_t  onceToken;
    static FZNetworkingManager * setSharedInstance;
    
    dispatch_once(&onceToken, ^{
        setSharedInstance = [[FZNetworkingManager alloc] init];
        //setSharedInstance.downloadingTaskDic = [NSMutableDictionary new];
    });
    return setSharedInstance;
}
- (void)cancelRequest
{
    if ([manager.tasks count] > 0) {
        NSLog(@"返回时取消网络请求");
        [manager.tasks makeObjectsPerformSelector:@selector(cancel)];
        //NSLog(@"tasks = %@",manager.tasks);
    }
}
#pragma mark - 工具方法
+(NSDictionary *)dictionaryWithJsonData:(NSData *)jsonData {
    if (jsonData == nil) {
        return nil;
    }
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return dic;
}

+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return dic;
}


/*json
 * @brief 把字典转换成字符串
 * @param jsonString JSON格式的字符串
 * @return 返回字符串
 */
+(NSString*)URLEncryOrDecryString:(NSDictionary *)paramDict IsHead:(BOOL)_type
{
    
    NSArray *keyAry =  [paramDict allKeys];
    NSString *encryString = @"";
    for (NSString *key in keyAry)
    {
        NSString *keyValue = [paramDict valueForKey:key];
        encryString = [encryString stringByAppendingFormat:@"&"];
        encryString = [encryString stringByAppendingFormat:@"%@",key];
        encryString = [encryString stringByAppendingFormat:@"="];
        encryString = [encryString stringByAppendingFormat:@"%@",keyValue];
    }
    
    return encryString;
}


/*json
 * @brief 把字典转换成JSON
 * @param infoDict
 * @return 返回JSON
 */
+ (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
}
+(void)requestLittleARsearchImageFiles:(NSArray<NSData *> *)imageDataArray
                  parameters:(id)parameters
              complete:(ARCompleteHandler)handler{
    
    
                  if (nil == imageDataArray || 0 == [imageDataArray count])
                  {
                      NSLog(@"imageDataArray is nil or count is 0, return");
                      handler(NO, nil, nil);
                      return;
                  }
                  
                  if (![[FZNetWorkMgr shareInstance] isNetWorkConnected])
                  {
                      NSLog(@"network isn't connected");
                      handler(NO, nil, nil);
                      return;
                  }
                  
                  AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
                  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                  manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                  [manager.requestSerializer setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
                  
                  [manager POST:@"https://eschool.maaee.com/Excoord_PastecServer/search" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                      
                      if (1 == [imageDataArray count])
                      {
                          NSData *imageData = [imageDataArray firstObject];
                          if (imageData && imageData.length > 0)
                          {
                              [formData appendPartWithFileData:imageData name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg"];
                          }
                      }
                      else
                      {
                          for (int i = 0; i < [imageDataArray count]; i++)
                          {
                              NSData *imageData = [imageDataArray objectAtIndex:i];
                              if (imageData && imageData.length > 0)
                              {
                                  [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file%d", i] fileName:[NSString stringWithFormat:@"filename%d.jpg", i] mimeType:@"image/jpeg"];
                              }
                          }
                      }
                      
                  } success:^(NSURLSessionDataTask *operation, id responseObject) {
                      
                    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[FZNetworkingManager dictionaryWithJsonData:responseObject]];
                   
                      if (dic && [dic allKeys]  > 0)
                      {
                          handler(YES, dic, nil);
                      }
                      else
                      {
                          NSErrorDomain domain = @"返回的文件地址链接为空";
                          NSError *error = [[NSError alloc] initWithDomain:domain code:1100 userInfo:nil];
                          NSLog(@"error is %@", error.description);
                          handler(NO, nil, error);
                      }
                      
                  } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                      
                      NSLog(@"error is %@", error.description);
                      handler(NO, nil, error);
                  }];
}


+(void)requestLittleAntMethod:(NSString *)method parameters:(id)parameters requestHandler:(requestHandler)handler;
{
    NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
    [headerDic setObject:@"ios" forKey:@"machineType"];
    NSDictionary *binfoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *versionNumString = [[binfoDictionary objectForKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""];
    [headerDic setObject:versionNumString forKey:@"version"];

    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [parameters setObject:[NSString stringWithFormat:@"%@",method] forKey:@"method"];
    //method = WEB_SERVICE_BASE_URL;
    NSLog(@"\n FZ网络请求参数列表:%@\n\n 接口名: %@\n\n",parameters,WEB_SERVICE_BASE_URL);
    
    NSMutableDictionary *paredic = [[NSMutableDictionary alloc] init];
    
    [paredic setObject:[FZNetworkingManager convertToJSONData:parameters] forKey:@"params"];
    // 1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.申明返回的结果是二进制类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 3.如果报接受类型不一致请替换一致text/html  或者 text/plain
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    [manager.requestSerializer setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    // 4.请求超时，时间设置
    manager.requestSerializer.timeoutInterval = 30;
    
    for (NSString *key in headerDic) {
        [manager.requestSerializer setValue:[headerDic objectForKey:key] forHTTPHeaderField:key];
    }
    
    // 5.选择请求方式POST
    [manager POST:WEB_SERVICE_BASE_URL parameters:paredic progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         
         NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[FZNetworkingManager dictionaryWithJsonData:responseObject]];
         NSLog(@"\n post请求成功:%@\n\n",dic);
         BOOL success = [[dic objectForKey:@"success"] boolValue];
         if (success)
         {
             handler(YES,dic);
         }
         else
         {
             handler(NO,dic);
         }
     }
          failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"\n post请求失败:%@\n\n",error);
         
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         [MBProgressHUD showError:@"网络请求失败" toView:[[UIApplication sharedApplication].windows lastObject]];
         NSMutableDictionary *handDic=[[NSMutableDictionary alloc]init];
         [handDic setObject:@"网络请求失败" forKey:@"msg"];
         [handDic setObject:error forKey:@"response"];
         handler(NO,handDic);
     }];
}
#pragma mark - 下载
- (void)downloadFileWithUrl:(NSString *)aUrl
           withSaveFilePath:(NSString *)aSaveFilePath
       callbackToMainThread:(BOOL)isNeedCallbackToMainThread
                   complete:(DownloadCompleteHandler)handler
{
    if (nil == aUrl || 0 == [aUrl length])
    {
        NSLog(@"aUrl is nil or length is 0, return");
        handler(NO, nil, nil);
        return;
    }
    
    if (nil == aSaveFilePath || 0 == [aSaveFilePath length])
    {
        NSLog(@"aSavePath is nil or length is 0, return");
        handler(NO, nil, nil);
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:aSaveFilePath])
    {
        NSLog(@"Download file is existed, aSaveFilePath:%@", aSaveFilePath);
        handler(YES, aSaveFilePath, nil);
        return;
    }
    
    if (![[FZNetWorkMgr shareInstance] isNetWorkConnected])
    {
        NSLog(@"network isn't connected");
        handler(NO, nil, nil);
        return;
    }
    
    NSString *savePath = [aSaveFilePath stringByDeletingLastPathComponent];
    if (![fileManager fileExistsAtPath:savePath])
    {
        NSLog(@"createDirectoryAtPath: %@", savePath);
        [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSURL *url = [[NSURL alloc] initWithString:aUrl];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    AFHTTPSessionManager *operation = [AFHTTPSessionManager manager];
    NSURLSessionDownloadTask *downloadTask = [operation downloadTaskWithRequest:urlRequest progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        return [NSURL fileURLWithPath:aSaveFilePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (!error)
        {
            NSLog(@"responseObject is %@", response);
            handler(YES, response, nil);
        }
        else
        {
            NSLog(@"error is %@", error.description);
            handler(NO, nil, error);
        }
    }];
    [downloadTask resume];
}

#pragma mark - 上传
- (void)uploadImageFiles:(NSArray<NSData *> *)imageDataArray complete:(UploadCompleteHandler)handler
{
    if (nil == imageDataArray || 0 == [imageDataArray count])
    {
        NSLog(@"imageDataArray is nil or count is 0, return");
        handler(NO, nil, nil);
        return;
    }
    
    if (![[FZNetWorkMgr shareInstance] isNetWorkConnected])
    {
        NSLog(@"network isn't connected");
        handler(NO, nil, nil);
        return;
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:UPLOAD_FILE_BASE_URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if (1 == [imageDataArray count])
        {
            NSData *imageData = [imageDataArray firstObject];
            if (imageData && imageData.length > 0)
            {
                [formData appendPartWithFileData:imageData name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg"];
            }
        }
        else
        {
            for (int i = 0; i < [imageDataArray count]; i++)
            {
                NSData *imageData = [imageDataArray objectAtIndex:i];
                if (imageData && imageData.length > 0)
                {
                    [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file%d", i] fileName:[NSString stringWithFormat:@"filename%d.jpg", i] mimeType:@"image/jpeg"];
                }
            }
        }
        
    } success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"responseString is %@",responseString);
        if (responseString && [responseString length] > 0)
        {
            handler(YES, responseString, nil);
        }
        else
        {
            NSErrorDomain domain = @"返回的文件地址链接为空";
            NSError *error = [[NSError alloc] initWithDomain:domain code:1100 userInfo:nil];
            NSLog(@"error is %@", error.description);
            handler(NO, nil, error);
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        NSLog(@"error is %@", error.description);
        handler(NO, nil, error);
    }];
}

- (void)uploadVoiceFile:(NSData *)voiceData withVoiceType:(VOICE_TYPE)voiceType complete:(UploadCompleteHandler)handler
{
    if (nil == voiceData)
    {
        NSLog(@"amrVoiceData is nil, return");
        handler(NO, nil, nil);
        return;
    }
    
    if (voiceType < VOICE_TYPE_AMR || voiceType > VOICE_TYPE_WAV)
    {
        NSLog(@"voiceType is illegal, return");
        handler(NO, nil, nil);
        return;
    }
    
    if (![[FZNetWorkMgr shareInstance] isNetWorkConnected])
    {
        NSLog(@"network isn't connected");
        handler(NO, nil, nil);
        return;
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    [manager POST:UPLOAD_FILE_BASE_URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData){
        
        NSString *fileName = @"filename";
        switch (voiceType)
        {
            case VOICE_TYPE_AMR:
            {
                fileName = [fileName stringByAppendingString:@".amr"];
            }
                break;
            case VOICE_TYPE_WAV:
            {
                fileName = [fileName stringByAppendingString:@".wav"];
            }
                break;
            default:
                break;
        }
        [formData appendPartWithFileData:voiceData name:@"file" fileName:fileName mimeType:@"multipart/form-data"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"responseString is %@",responseString);
        if (responseString && [responseString length] > 0)
        {
            handler(YES, responseString, nil);
        }
        else
        {
            NSErrorDomain domain = @"返回的文件地址链接为空";
            NSError *error = [[NSError alloc] initWithDomain:domain code:1100 userInfo:nil];
            NSLog(@"error is %@", error.description);
            handler(NO, nil, error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error is %@", error.description);
        handler(NO, nil, error);
    }];
}
- (void)uploadDatFile:(NSData *)Data withVType:(NSString *)Type complete:(UploadCompleteHandler)handler{
    
    if (nil == Data)
    {
        NSLog(@"amrVoiceData is nil, return");
        handler(NO, nil, nil);
        return;
    }
    
    if (![[FZNetWorkMgr shareInstance] isNetWorkConnected])
    {
        NSLog(@"network isn't connected");
        handler(NO, nil, nil);
        return;
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    [manager POST:UPLOAD_FILE_BASE_URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData){
        
        NSString *fileName = @"filename";
      
                fileName = [fileName stringByAppendingString:Type];
      
        [formData appendPartWithFileData:Data name:@"file" fileName:fileName mimeType:@"multipart/form-data"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"responseString is %@",responseString);
        if (responseString && [responseString length] > 0)
        {
            handler(YES, responseString, nil);
        }
        else
        {
            NSErrorDomain domain = @"返回的文件地址链接为空";
            NSError *error = [[NSError alloc] initWithDomain:domain code:1100 userInfo:nil];
            NSLog(@"error is %@", error.description);
            handler(NO, nil, error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error is %@", error.description);
        handler(NO, nil, error);
    }];
    
    
}
- (void)uploadFile:(NSData *)fileData fileName:(NSString *)fileName withFileType:(NSString*)fileType complete:(UploadCompleteHandler)handler{
    if (nil == fileData)
    {
        NSLog(@"amrVoiceData is nil, return");
        handler(NO, nil, nil);
        return;
    }
    
    if (![[FZNetWorkMgr shareInstance] isNetWorkConnected])
    {
        NSLog(@"network isn't connected");
        handler(NO, nil, nil);
        return;
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    [manager POST:UPLOAD_FILE_BASE_URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData){
        [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:@"multipart/form-data"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"responseString is %@",responseString);
        if (responseString && [responseString length] > 0)
        {
            handler(YES, responseString, nil);
        }
        else
        {
            NSErrorDomain domain = @"返回的文件地址链接为空";
            NSError *error = [[NSError alloc] initWithDomain:domain code:1100 userInfo:nil];
            NSLog(@"error is %@", error.description);
            handler(NO, nil, error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error is %@", error.description);
        handler(NO, nil, error);
    }];
}
+(void)requestLittleAntARMethod:(NSString *)method
                     parameters:(id)parameters
                 requestHandler:(requestHandler)handler{
    
    
    
    NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
    [headerDic setObject:@"ios" forKey:@"machineType"];
    NSDictionary *binfoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *versionNumString = [[binfoDictionary objectForKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""];
    [headerDic setObject:versionNumString forKey:@"version"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [parameters setObject:[NSString stringWithFormat:@"%@",method] forKey:@"method"];

    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [parameters setObject:[NSString stringWithFormat:@"%@",method] forKey:@"method"];
    //method = WEB_SERVICE_BASE_URL;
    NSLog(@"\n FZ网络请求参数列表:%@\n\n 接口名: %@\n\n",parameters,WEB_SERVICE_BASE_URL);
    
    NSMutableDictionary *paredic = [[NSMutableDictionary alloc] init];
    
    [paredic setObject:[FZNetworkingManager convertToJSONData:parameters] forKey:@"params"];
    // 1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.申明返回的结果是二进制类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 3.如果报接受类型不一致请替换一致text/html  或者 text/plain
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    [manager.requestSerializer setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    // 4.请求超时，时间设置
    manager.requestSerializer.timeoutInterval = 30;
    
    for (NSString *key in headerDic) {
        [manager.requestSerializer setValue:[headerDic objectForKey:key] forHTTPHeaderField:key];
    }
    
    // 5.选择请求方式POST
    [manager POST:@"https://www.maaee.com/Excoord_For_Education/webservice" parameters:paredic progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         
         NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[FZNetworkingManager dictionaryWithJsonData:responseObject]];
         NSLog(@"\n post请求成功:%@\n\n",dic);
         BOOL success = [[dic objectForKey:@"success"] boolValue];
         if (success)
         {
             handler(YES,dic);
         }
         else
         {
             handler(NO,dic);
         }
     }
          failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"\n post请求失败:%@\n\n",error);
         
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         [MBProgressHUD showError:@"网络请求失败" toView:[[UIApplication sharedApplication].windows lastObject]];
         NSMutableDictionary *handDic=[[NSMutableDictionary alloc]init];
         [handDic setObject:@"网络请求失败" forKey:@"msg"];
         [handDic setObject:error forKey:@"response"];
         handler(NO,handDic);
     }];
}
@end
