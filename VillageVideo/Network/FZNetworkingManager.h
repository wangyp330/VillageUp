//
//  FZNetworkingManager.h
//  LIttleAntForParent
//
//  Created by Mac on 2018/6/4.
//  Copyright © 2018年 FZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZNetWorkMgr.h"

typedef NS_ENUM(NSInteger, VOICE_TYPE)
{
    VOICE_TYPE_AMR = 0x10,
    VOICE_TYPE_WAV
};

typedef void (^requestHandler)(BOOL success, id _Nullable response);
typedef void (^UploadCompleteHandler)(BOOL success, NSString *fileURLString, NSError *error);
typedef void (^ARCompleteHandler)(BOOL success, NSDictionary *parm, NSError *error);
typedef void (^DownloadCompleteHandler)(BOOL success, id response, NSError *error);

@interface FZNetworkingManager : NSObject



+ (FZNetworkingManager *)sharedUtil;

+(NSDictionary *)dictionaryWithJsonData:(NSData *)jsonData;

+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+(NSString*)URLEncryOrDecryString:(NSDictionary *)paramDict IsHead:(BOOL)_type;

+ (NSString*)convertToJSONData:(id)infoDict;



+(void)requestLittleAntMethod:(NSString *)method
                   parameters:(id)parameters
               requestHandler:(requestHandler)handler;

+(void)requestLittleARsearchImageFiles:(NSArray<NSData *> *)imageDataArray
                            parameters:(id)parameters
                              complete:(ARCompleteHandler)handler;


+(void)requestLittleAntARMethod:(NSString *)method
                   parameters:(id)parameters
               requestHandler:(requestHandler)handler;

#pragma mark - 下载
- (void)downloadFileWithUrl:(NSString *)aUrl
           withSaveFilePath:(NSString *)aSaveFilePath
       callbackToMainThread:(BOOL)isNeedCallbackToMainThread
                   complete:(DownloadCompleteHandler)handler;

#pragma mark - 上传
- (void)uploadImageFiles:(NSArray<NSData *> *)imageDataArray complete:(UploadCompleteHandler)handler;

- (void)uploadVoiceFile:(NSData *)voiceData withVoiceType:(VOICE_TYPE)voiceType complete:(UploadCompleteHandler)handler;

- (void)uploadDatFile:(NSData *)Data withVType:(NSString *)Type complete:(UploadCompleteHandler)handler;

- (void)uploadFile:(NSData *)fileData fileName:(NSString *)fileName withFileType:(NSString*)fileType complete:(UploadCompleteHandler)handler;
@end
