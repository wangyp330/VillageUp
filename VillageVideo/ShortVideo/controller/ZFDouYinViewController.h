//
//  ZFDouYinViewController.h
//  ZFPlayer_Example
//
//  Created by 紫枫 on 2018/6/4.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ShareType) {
    ShareTypeWechatSession,
    ShareTypeWechatTimeLine,
    ShareTypeQQ,
    ShareTypeQZone,
    ShareTypeSina,
    shareDelect
};
@interface ZFDouYinViewController : UIViewController
@property(nonatomic,strong)NSMutableArray *dataArray;
- (void)playTheIndex:(NSInteger)index;
@property(nonatomic,assign)NSInteger pageNumber;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSString *method;
@end
