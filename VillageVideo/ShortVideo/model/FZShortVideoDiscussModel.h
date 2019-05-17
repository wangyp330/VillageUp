//
//  FZShortVideoDiscussModel.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "JSONModel.h"

@interface DiscussUser :JSONModel
@property (nonatomic , copy) NSString        <Optional>      * isblock;
@property (nonatomic , copy) NSString         <Optional>      * isdelete;
@property (nonatomic , copy) NSString          <Optional>     * schoolId;
@property (nonatomic , copy) NSString          <Optional>     * uid;
@property (nonatomic , copy) NSString          <Optional>     * antUid;
@property (nonatomic , copy) NSString          <Optional>     * dataSource;
@property (nonatomic , copy) NSString          <Optional>     * avatar;
@property (nonatomic , copy) NSString          <Optional>     * password;
@property (nonatomic , copy) NSString          <Optional>     * userName;
@property (nonatomic , copy) NSString           <Optional>    * rechargeEndtime;
@property (nonatomic , copy) NSString           <Optional>    * utype;
@property (nonatomic , copy) NSString           <Optional>    * schoolName;
@property (nonatomic , copy) NSString           <Optional>    * account;
@property (nonatomic , copy) NSString           <Optional>    * gradeId;

@end

@interface FZShortVideoDiscussModel :JSONModel
@property (nonatomic , copy) NSString           <Optional>    * uid;
@property (nonatomic , strong) DiscussUser      <Optional>         * discussUser;
@property (nonatomic , copy) NSString            <Optional>   * targetId;
@property (nonatomic , copy) NSString           <Optional>    * isDelete;
@property (nonatomic , copy) NSString           <Optional>    * targetType;
@property (nonatomic , copy) NSString             <Optional>  * discussContent;
@property (nonatomic , copy) NSString             <Optional>  * likeCount;
@property (nonatomic , copy) NSString           <Optional>    * disId;
@property (nonatomic , copy) NSString            <Optional>   * createTime;

@end

