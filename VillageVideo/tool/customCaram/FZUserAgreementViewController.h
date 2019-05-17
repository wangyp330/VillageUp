//
//  FZUserAgreementViewController.h
//  Elearning
//
//  Created by missyun on 2018/10/9.
//  Copyright © 2018年 smallAnts. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^Agree)(BOOL isAgree);
@interface FZUserAgreementViewController : UIViewController
@property(nonatomic,strong)Agree agree;
@end
