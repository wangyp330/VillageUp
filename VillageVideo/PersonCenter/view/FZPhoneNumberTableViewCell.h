//
//  FZPhoneNumberTableViewCell.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/9/17.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FZPhoneNumberTableViewCellDelegaet <NSObject>
@end
@interface FZPhoneNumberTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *phumberTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *jiebangBtn;
@property(nonatomic,weak) id <FZPhoneNumberTableViewCellDelegaet > delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jiebanBtnWidth;
@end
