//
//  FZPlayVideoTableViewCell.h
//  LittentAntShortVideo
//
//  Created by mac on 2018/8/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShortVideoModel.h"
@protocol shortVideoActionDelegaet <NSObject>
//-(void)clickCommentAction:(ShortVideoModel *)model;
//-(void)clickFlowingAction:(ShortVideoModel *)model;
//-(void)clicLlickAction:(ShortVideoModel *)model;
//-(void)clickCommentNumberAction:(ShortVideoModel *)model;
//-(void)clickShareAction:(ShortVideoModel *)model;
@end
@interface FZPlayVideoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (nonatomic, strong) ShortVideoModel *model;
@property(nonatomic,weak) id <shortVideoActionDelegaet > delegate;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *userNalme;

@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UIButton *isLickBtn;
@property (weak, nonatomic) IBOutlet UIButton *disCUSSInfoBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareInfoBtn;
@property (weak, nonatomic) IBOutlet UIButton *challage;
@property (weak, nonatomic) IBOutlet UIButton *delectVideoBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *delectBtnHigth;

@property (weak, nonatomic) IBOutlet UILabel *cintent;
@property (weak, nonatomic) IBOutlet UILabel *tripOne;
@property (weak, nonatomic) IBOutlet UILabel *tripTwo;

@property (weak, nonatomic) IBOutlet UILabel *tripThree;
@property (weak, nonatomic) IBOutlet UIView *headBackView;
@property (weak, nonatomic) IBOutlet UIImageView *tripimageview;

@end
