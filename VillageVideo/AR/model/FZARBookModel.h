//
//  FZARBookModel.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "JSONModel.h"

@interface TagList :JSONModel

@end

@interface Book :JSONModel
@property (nonatomic , copy) NSString      <Optional>        * status;
@property (nonatomic , copy) NSString      <Optional>         * id;
@property (nonatomic , copy) NSString        <Optional>       * createTime;
@property (nonatomic , copy) NSString        <Optional>       * type;

@end

@interface FZARBookModel :JSONModel
@property (nonatomic , copy) NSArray<TagList *>              * tagList;
@property (nonatomic , copy) NSString        <Optional>       * id;
@property (nonatomic , copy) NSString        <Optional>       * pic;
@property (nonatomic , strong) Book         <Optional>      * book;
@property (nonatomic , copy) NSString       <Optional>        * page;
@property (nonatomic , copy) NSString       <Optional>        * video;
@property (nonatomic , copy) NSString        <Optional>       * index;

@end

