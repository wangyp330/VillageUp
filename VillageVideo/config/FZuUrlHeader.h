//
//  FZuUrlHeader.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#define FZuUrlHeader_h

#define isOnLineAPI 0

#if isOnLineAPI ==1
/***********************远程接口*****************************/
//主域名
#define BASE_IP [NDSUD objectForKey:@"base_IP"]

#define App_BASE_URL  [NSString stringWithFormat:@"http://%@",BASE_IP]

//教学
#define JX_IP [NDSUD objectForKey:@"jx_IP"]

#define App_JAIOXUYE_BASE_URL [NSString stringWithFormat:@"http://%@",JX_IP]

//数据交互接口基地址
#define WEB_SERVICE_BASE_URL [NSString stringWithFormat:@"%@:6012/Excoord_LittleVideoApiServer/webservice",App_BASE_URL]
//文件上传
#define UPLOAD_FILE_BASE_URL @"http://60.205.86.217:8890/Excoord_Upload_Server/file/upload"


#else
/******************************本地接口**************************/

//
#define LittleAnt_IP @"47.93.156.90"

//主域名
#define App_BASE_URL @"http://47.93.156.90"

#define App_JAIOXUYE_BASE_URL @"http://47.93.156.90:7094"

#define PhoneWebIP @"http://47.93.156.90:7094"

//数据交互接口基地址
#define WEB_SERVICE_BASE_URL App_BASE_URL":6013/Excoord_VillageVideoApiServer/webservice"
//文件上传
#define UPLOAD_FILE_BASE_URL @"http://60.205.86.217:8890/Excoord_Upload_Server/file/upload"


#endif

