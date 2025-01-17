//
//  UserModel.h
//  PlayShortVideo
//
//  Created by missyun on 2018/7/31.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "JSONModel.h"

@interface FZUserModel : JSONModel
@property (nonatomic , copy) NSString       <Optional>       * isblock;
@property (nonatomic , copy) NSString         <Optional>        * isdelete;//1信息未完善 0信息已完善
@property (nonatomic , copy) NSString          <Optional>       * schoolId;
@property (nonatomic , copy) NSString          <Optional>       * uid;
@property (nonatomic , copy) NSString           <Optional>      * antUid;
@property (nonatomic , copy) NSString            <Optional>     * dataSource;
@property (nonatomic , copy) NSString             <Optional>    * vIP;
@property (nonatomic , copy) NSString             <Optional>    * avatar;
@property (nonatomic , copy) NSString            <Optional>     * password;
@property (nonatomic , copy) NSString             <Optional>    * level;
@property (nonatomic , copy) NSString             <Optional>    * rechargeEndtime;
@property (nonatomic , copy) NSString             <Optional>    * userCity;
@property (nonatomic , copy) NSString             <Optional>    * schoolName;
@property (nonatomic , copy) NSString             <Optional>    * userName;
@property (nonatomic , copy) NSString             <Optional>    * account;
@property (nonatomic , copy) NSString              <Optional>   * gradeId;
@property (nonatomic , copy) NSString              <Optional>   * utype;
@property (nonatomic , copy) NSString <Optional>   *phoneNumber;
@property (nonatomic , copy) NSString <Optional>   *villageId;
@property (nonatomic , copy) NSString <Optional> *villageName;
@property (nonatomic , copy) NSString <Optional>   *groupId;
@property (nonatomic , copy) NSString <Optional>   *groupName;
@end
