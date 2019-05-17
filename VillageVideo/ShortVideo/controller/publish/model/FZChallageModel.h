//
//  FZChallageModel.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "JSONModel.h"
@interface UserInfo1 :JSONModel
@property (nonatomic , copy) NSString        <Optional>      * isblock;
@property (nonatomic , copy) NSString             <Optional>   * uid;
@property (nonatomic , copy) NSString            <Optional>    * schoolId;
@property (nonatomic , copy) NSString            <Optional>    * isdelete;
@property (nonatomic , copy) NSString            <Optional>    * antUid;
@property (nonatomic , copy) NSString          <Optional>      * dataSource;
@property (nonatomic , copy) NSString           <Optional>     * vIP;
@property (nonatomic , copy) NSString           <Optional>     * avatar;
@property (nonatomic , copy) NSString           <Optional>     * userName;
@property (nonatomic , copy) NSString           <Optional>     * utype;
@property (nonatomic , copy) NSString            <Optional>    * userCity;
@property (nonatomic , copy) NSString            <Optional>    * gradeId;
@property (nonatomic , copy) NSString           <Optional>     * thirdSystemId;

@end

@interface FZChallageModel :JSONModel
@property (nonatomic , copy) NSString           <Optional>     * joinPeople;
@property (nonatomic , copy) NSString            <Optional>    * tagType;
@property (nonatomic , copy) NSString            <Optional>    * userId;
@property (nonatomic , copy) NSString            <Optional>    * isDelete;
@property (nonatomic , copy) NSString            <Optional>    * tagContent;
@property (nonatomic , copy) NSString            <Optional>    * tagTitle;
@property (nonatomic , copy) NSString             <Optional>   * tagId;
@property (nonatomic , strong) UserInfo1           <Optional>     * userInfo;

@end
