//
//  ShortVideoModel.h
//  PlayShortVideo
//
//  Created by missyun on 2018/7/31.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "JSONModel.h"

@interface UserLikeInfo :JSONModel
@property (nonatomic , copy) NSString             <Optional>  * targetType;
@property (nonatomic , copy) NSString             <Optional>  * likeTime;
@property (nonatomic , copy) NSString             <Optional>  * likeId;
@property (nonatomic , copy) NSString             <Optional>  * targetId;
@property (nonatomic , copy) NSString             <Optional>  * userId;

@end

@interface SchoolInfo :JSONModel
@property (nonatomic , copy) NSString            <Optional>   * isDelete;
@property (nonatomic , copy) NSString           <Optional>    * schoolName;
@property (nonatomic , copy) NSString            <Optional>   * schoolContent;
@property (nonatomic , copy) NSString            <Optional>   * schoolId;

@end

@interface UserInfo :JSONModel
@property (nonatomic , copy) NSString            <Optional>   * isblock;
@property (nonatomic , copy) NSString            <Optional>   * isdelete;
@property (nonatomic , copy) NSString             <Optional>  * schoolId;
@property (nonatomic , copy) NSString             <Optional>  * uid;
@property (nonatomic , copy) NSString            <Optional>   * antUid;
@property (nonatomic , copy) NSString             <Optional>  * dataSource;
@property (nonatomic , copy) NSString           <Optional>    * avatar;
@property (nonatomic , copy) NSString            <Optional>   * password;
@property (nonatomic , copy) NSString            <Optional>   * userName;
@property (nonatomic , copy) NSString            <Optional>   * rechargeEndtime;
@property (nonatomic , copy) NSString            <Optional>   * userCity;
@property (nonatomic , copy) NSString            <Optional>   * schoolName;
@property (nonatomic , copy) NSString           <Optional>    * utype;
@property (nonatomic , copy) NSString            <Optional>   * account;
@property (nonatomic , copy) NSString            <Optional>   * gradeId;
@property (nonatomic , copy) NSString            <Optional>   * level;
@property (nonatomic , copy) NSString            <Optional>   * vIP;
@end

@interface GradeInfo :JSONModel
@property (nonatomic , copy) NSString           <Optional>    * gradeId;
@property (nonatomic , copy) NSString           <Optional>    * gradeName;

@end
@interface Tags :JSONModel
@property (nonatomic , copy) NSString          <Optional>      * tagType;
@property (nonatomic , copy) NSString           <Optional>     * userId;
@property (nonatomic , copy) NSString             <Optional>   * isDelete;
@property (nonatomic , copy) NSString             <Optional>   * tagContent;
@property (nonatomic , copy) NSString             <Optional>   * tagTitle;
@property (nonatomic , copy) NSString            <Optional>    * tagId;
@property (nonatomic , strong) UserInfo           <Optional>     * userInfo;

@end


@interface AuditInfo : JSONModel

@property (nonatomic , copy) NSString          <Optional>      * auditId;
@property (nonatomic , copy) NSString           <Optional>     * auditMark;
@property (nonatomic , copy) NSString             <Optional>   * auditingTime;
@property (nonatomic , copy) NSString             <Optional>   * auditorId;
@property (nonatomic , copy) NSString             <Optional>   * auditorUserName;
@property (nonatomic , copy) NSString            <Optional>    * isPass;
@property (nonatomic , strong) NSString           <Optional>     * isRecommend;
@property (nonatomic , copy) NSString             <Optional>   * istop;
@property (nonatomic , copy) NSString            <Optional>    * targetId;
@property (nonatomic , strong) NSString           <Optional>     * targetType;
@end

@interface ShortVideoModel :JSONModel
@property (nonatomic , copy) NSString            <Optional>   * videoType;
@property (nonatomic , copy) NSString            <Optional>   * challengeId;
@property (nonatomic , copy) NSString             <Optional>  * status;
@property (nonatomic , strong) UserLikeInfo       <Optional>        * userLikeInfo;
@property (nonatomic , copy) NSString             <Optional>  * schoolId;
@property (nonatomic , copy) NSString             <Optional>  * auditId;
@property (nonatomic , copy) NSString            <Optional>   * vid;
@property (nonatomic , strong) SchoolInfo          <Optional>     * schoolInfo;
@property (nonatomic , copy) NSArray<Tags *>          <Optional>     * tags;
@property (nonatomic , copy) NSString             <Optional>  * isLocalSave;
@property (nonatomic , strong) UserInfo            <Optional>   * userInfo;
@property (nonatomic , copy) NSString             <Optional>  * currentUserIsLike;
@property (nonatomic , copy) NSString             <Optional>  * videoContent;
@property (nonatomic , strong) GradeInfo          <Optional>     * gradeInfo;
@property (nonatomic , copy) NSString             <Optional>  * readCount;
@property (nonatomic , copy) NSString            <Optional>   * gradeId;
@property (nonatomic , copy) NSString            <Optional>   * coverPath;
@property (nonatomic , copy) NSString            <Optional>   * fatherId;
@property (nonatomic , copy) NSString            <Optional>   * commentCount;
@property (nonatomic , copy) NSString            <Optional>   * videoPath;
@property (nonatomic , copy) NSString            <Optional>   * recommendUserId;
@property (nonatomic , copy) NSString            <Optional>   * isRecommend;
@property (nonatomic , copy) NSString            <Optional>   * createTime;
@property (nonatomic , copy) NSString            <Optional>   * likeCount;
@property (nonatomic , copy) NSString           <Optional>    * isDelete;
@property (nonatomic , copy) NSString           <Optional>    * firstUrl;
@property (nonatomic , copy) NSString          <Optional>     * visibilityType;
@property (nonatomic , copy) NSString         <Optional>     * userId;
@property (nonatomic , copy) NSString          <Optional>     * height;
@property (nonatomic , copy) NSString         <Optional>     * width;
@property (nonatomic , copy) AuditInfo         <Optional>     * auditInfo;
@end


@interface GroupModel :JSONModel
@property (nonatomic , copy) NSString          <Optional>      * groupName;
@property (nonatomic , copy) NSString           <Optional>     * id;
@property (nonatomic , copy) NSString           <Optional>     * valid;
@end
