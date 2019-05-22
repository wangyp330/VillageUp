//
//  FZFansModel.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "JSONModel.h"

@interface LittleVideoUser :JSONModel
@property (nonatomic , copy) NSString             <Optional>    * isblock;
@property (nonatomic , copy) NSString             <Optional>    * isdelete;
@property (nonatomic , copy) NSString             <Optional>    * schoolId;
@property (nonatomic , copy) NSString             <Optional>    * uid;
@property (nonatomic , copy) NSString             <Optional>    * antUid;
@property (nonatomic , copy) NSString             <Optional>    * dataSource;
@property (nonatomic , copy) NSString             <Optional>    * vIP;
@property (nonatomic , copy) NSString             <Optional>    * gradeName;
@property (nonatomic , copy) NSString             <Optional>    * avatar;
@property (nonatomic , copy) NSString             <Optional>    * level;
@property (nonatomic , copy) NSString             <Optional>    * password;
@property (nonatomic , copy) NSString             <Optional>    * userCity;
@property (nonatomic , copy) NSString             <Optional>    * schoolName;
@property (nonatomic , copy) NSString            <Optional>     * userName;
@property (nonatomic , copy) NSString            <Optional>     * account;
@property (nonatomic , copy) NSString            <Optional>     * gradeId;
@property (nonatomic , copy) NSString            <Optional>     * utype;

@end

@interface FansUser :JSONModel
@property (nonatomic , copy) NSString             <Optional>    * isblock;
@property (nonatomic , copy) NSString             <Optional>    * isdelete;
@property (nonatomic , copy) NSString              <Optional>   * schoolId;
@property (nonatomic , copy) NSString              <Optional>   * uid;
@property (nonatomic , copy) NSString              <Optional>   * antUid;
@property (nonatomic , copy) NSString              <Optional>   * dataSource;
@property (nonatomic , copy) NSString              <Optional>   * vIP;
@property (nonatomic , copy) NSString             <Optional>    * avatar;
@property (nonatomic , copy) NSString              <Optional>   * password;
@property (nonatomic , copy) NSString              <Optional>   * userName;
@property (nonatomic , copy) NSString             <Optional>    * utype;
@property (nonatomic , copy) NSString             <Optional>    * userCity;
@property (nonatomic , copy) NSString             <Optional>    * schoolName;
@property (nonatomic , copy) NSString             <Optional>    * account;
@property (nonatomic , copy) NSString             <Optional>    * gradeId;

@end

@interface FZFllowModel :JSONModel
@property (nonatomic , copy) NSString             <Optional>    * userId;
@property (nonatomic , copy) NSString             <Optional>    * targetId;
@property (nonatomic , strong) LittleVideoUser     <Optional>            * littleVideoUser;
@property (nonatomic , copy) NSString             <Optional>    * followTime;
@property (nonatomic , copy) NSString             <Optional>    * targetType;
@property (nonatomic , strong) FansUser           <Optional>      * fansUser;
@property (nonatomic , copy) NSString          <Optional>    * followId;

@end
