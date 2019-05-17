//
//  VideoRecordViewController.h
//  iShow
//
//  Created by 胡阳阳 on 17/3/8.
//
//

#import <UIKit/UIKit.h>

@interface VideoRecordViewController : UIViewController
@property(nonatomic,strong)NSString *viderType;//0 正常  1:跟拍
@property(nonatomic,strong)NSString *targetId;//视频ID
@property(nonatomic,strong)Tags *tagModel;//视频ID
@end
