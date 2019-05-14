//
//  FZPlayVideoTableViewCell.m
//  LittentAntShortVideo
//
//  Created by mac on 2018/8/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZPlayVideoTableViewCell.h"
#import "UIImageView+ZFCache.h"
#import "UIView+ZFFrame.h"
#import "UIImageView+ZFCache.h"
#import "ZFUtilities.h"
#import "ZFLoadingView.h"
#import <YYWebImage/YYWebImage.h>
#import "FZShortVideolikeAnimation.h"
#import "ZFPlayerGestureControl.h"
#import <Masonry.h>
#import "FZTripBtn.h"
@interface FZPlayVideoTableViewCell()<UIGestureRecognizerDelegate>{
      FZTripBtn * button;
}
@property (nonatomic, strong) ShortVideoModel *datamodel;
@property(nonatomic,strong)NSString * isLike;
@property(nonatomic,strong)NSString * isFllow;
@property(nonatomic,strong)NSString * sign;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;

@end
@implementation FZPlayVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookansAction:)];
    self.headImage.userInteractionEnabled = YES;
     tap.numberOfTapsRequired = 1;//单击

    [self.headImage addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isFollow) name:@"isFollow" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shuaxin) name:@"guanzhuchenggong" object:nil];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *aa = [def objectForKey:@"isIosCheckVersion"];
    if ([aa isEqualToString:@"1"]) {
        
        UILongPressGestureRecognizer *tapp = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(isIosCheckVersion:)];
        tapp.minimumPressDuration = 2;
        [self.contentView addGestureRecognizer:tapp];
    }else{
       
    }
    
    self.challage.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
     self.challage.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    self.challage.hidden = YES;
    self.tripThree.hidden = YES;
    self.tripTwo.hidden = YES;
    self.tripOne.hidden = YES;
    [self viewLayer:self.challage andcornerRadius:2 andWidth:0 andborderColor:[UIColor clearColor]];
    [self viewLayer:self.tripOne andcornerRadius:2 andWidth:1 andborderColor:[UIColor clearColor]];
    [self viewLayer:self.tripTwo andcornerRadius:2 andWidth:1 andborderColor:[UIColor clearColor]];
    [self viewLayer:self.tripThree andcornerRadius:2 andWidth:1 andborderColor:[UIColor clearColor]];
    self.headBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.headBackView.layer.masksToBounds = YES;
    self.headBackView.layer.cornerRadius = 20;
    self.headBackView.userInteractionEnabled = YES;
    UITapGestureRecognizer *sign=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sign:)];
    [self.headBackView addGestureRecognizer:sign];
    
    UITapGestureRecognizer *doubleRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DoubleTap:)];
    
    doubleRecognizer.numberOfTapsRequired = 2;//双击
    doubleRecognizer.delegate = self;
    [self.contentView addGestureRecognizer:doubleRecognizer];
    
    
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 200, 200, 200)];
//    label.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:label];
//    [self.contentView bringSubviewToFront:label];
    
    
   
    
}
-(void)shuaxin{
        [self setModel:self.model];
}
-(void)layoutSubviews{
    [super layoutSubviews];

}
-(void)sign:(UITapGestureRecognizer*)recognizer{
    //处理空事件
}
-(void)DoubleTap:(UITapGestureRecognizer*)recognizer

{

     [[FZShortVideolikeAnimation shareInstance] createAnimationWithTap:recognizer];
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
    [parm setObject:_model.vid forKey:@"targetId"];
    [parm setObject:@"1" forKey:@"targetType"];
    if (_model.userInfo.uid.length > 0) {
        [parm setObject:_model.userInfo.uid forKey:@"followTargetId"];
    }
    [parm setObject:@"0" forKey:@"followType"];

    NSString *JsonParameter = [FZParmTODicString convertToJsonData:parm];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:JsonParameter forKey:@"JsonParameter"];
    [FZNetworkingManager requestLittleAntMethod:@"getUserLikeLog" parameters:dic requestHandler:^(BOOL success, id  _Nullable response) {
        NSLog(@"haha");
        if (success == YES) {
            NSData *jsonData =[ [response objectForKey:@"response"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            if ([[dic objectForKey:@"currentUserIsLike"] integerValue] == 1) {
                //点过了
            }else{
                  [self lickBtnAction:self.isLickBtn];
            }
        }

    }];
    

    
}
-(void)viewLayer:(UIView *)view andcornerRadius:(CGFloat)Radius andWidth:(CGFloat)width andborderColor:(UIColor *)color{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = Radius;
    view.layer.borderWidth = width;
    view.layer.borderColor = color.CGColor ;
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
}
-(void)isIosCheckVersion:(UILongPressGestureRecognizer *)tap{
    NSLog(@"hah");
    SuppressPerformSelectorLeakWarning(
                                       if ([_delegate respondsToSelector:@selector(isIosCheckVersion:withCell:)])
                                       {
                                           [_delegate performSelector:@selector(isIosCheckVersion:withCell:) withObject:tap withObject:self];
                                       });
}
-(void)lookansAction:(UITapGestureRecognizer *)tap{
    NSLog(@"hah");
    SuppressPerformSelectorLeakWarning(
                                       if ([_delegate respondsToSelector:@selector(lookansAction:withCell:)])
                                       {
                                           [_delegate performSelector:@selector(lookansAction:withCell:) withObject:tap withObject:self];
                                       });
}
-(void)isFollow{
    [self setModel:self.model];
}
-(void)setModel:(ShortVideoModel *)model{
    self.isLike = model.currentUserIsLike;
//    self.isLike = model
    _model = model;
    self.challage.hidden = YES;
    
    if ([model.width integerValue] > [model.height integerValue]) {
         self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }else {
        self.coverImageView.contentMode = UIViewContentModeScaleToFill;
        self.coverImageView.autoresizesSubviews = YES;
        
        self.coverImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
         [self.coverImageView yy_setImageWithURL:[NSURL URLWithString:model.firstUrl] placeholder:[UIImage imageNamed:@"背景底图"]];
    self.contentView.backgroundColor = [UIColor blackColor];
    self.userNalme.text = model.userInfo.userName;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.userInfo.avatar] placeholderImage:[UIImage imageNamed:@"defaultHeader"]];
    self.cintent.text = model.videoContent;

    NSMutableArray *arr = [NSMutableArray new];
    for (NSDictionary *dic in model.tags) {
       Tags *tag = [[Tags alloc]initWithDictionary:dic error:nil];
        if ([tag.tagType isEqualToString:@"2"]) {
             self.challage.hidden = NO;
            [self.challage setAttributedTitle: [FZChangeTextColor changeString:[NSString  stringWithFormat:@"#%@",tag.tagTitle]] forState:(UIControlStateNormal)];
            NSString *str =[NSString  stringWithFormat:@"#%@",tag.tagTitle];
           CGFloat wodth =     [self getWidthWithText:str height:21 font:11];
            self.width.constant = wodth+10;
           
            self.challage.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.challage setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            
            [ self.challage mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(self.headBackView);
                make.height.mas_equalTo(@(21));
                make.bottom.mas_equalTo(self.headBackView.mas_top).mas_offset(-15-21-15);
                make.width.mas_equalTo(@(wodth+20));
            }];
        }else {
            
            [arr addObject:tag];
        }
        
    }
    if (arr.count == 0 ) {
        [ self.challage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.headBackView.mas_top).mas_offset(-15);
        }];
    }
    for (Tags *tag in arr) {
    
    }
    /*
     CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18.0f]}];
     */
    FZTripBtn *btn = [self viewWithTag:200];
    [btn removeFromSuperview];
    btn = nil;
    FZTripBtn *btnb = [self viewWithTag:201];
    [btnb removeFromSuperview];
    FZTripBtn *btnff = [self viewWithTag:202];
    [btnff removeFromSuperview];
    for (int i = 0; i < arr.count; i ++ ) {
         NSInteger index = i % 3;
        Tags *tag = arr[i];
      
     
        CGSize sizeone;
        CGSize sizetwo;
        CGSize sizethree;
        if (i == 0) {
            Tags *tagg = arr[0];
        sizeone = [tagg.tagTitle sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11.0f]}];
          button = [[FZTripBtn alloc] initWithFrame:CGRectMake(index * (sizeone.width+20 + 2) + 15, self.headBackView.mj_y-10-21, sizeone.width+20, 21)];
            button.tag = 200 + i;
            if (0 == i) {
                [button setImage:[UIImage imageNamed:@"黄标签"] forState:(UIControlStateNormal)];
            }
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 0)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            button.titleLabel.font = [UIFont systemFontOfSize:11];
            button.titleLabel.textColor = [UIColor whiteColor];
            [button setTitle:tag.tagTitle forState:(UIControlStateNormal)];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 2;
            [self.contentView addSubview:button];
            [self.contentView bringSubviewToFront:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.left.mas_equalTo(@(index * (sizeone.width+20 + 2) + 15));
                make.height.mas_equalTo(@(21));
                make.bottom.mas_equalTo(self.headBackView.mas_top).mas_offset(-15);
                make.width.mas_equalTo(@(sizeone.width+25));
                
            }];
        }else if (i == 1){
             Tags *tagg = arr[1];
          sizetwo = [tagg.tagTitle sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11.0f]}];
          button = [[FZTripBtn alloc] initWithFrame:CGRectMake((sizeone.width+30 + 2) + 15, self.headBackView.mj_y-10-21, sizetwo.width+20, 21)];
            button.tag = 200 + i;
            if (0 == i) {
                [button setImage:[UIImage imageNamed:@"黄标签"] forState:(UIControlStateNormal)];

            }
            button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            button.titleLabel.font = [UIFont systemFontOfSize:11];
            button.titleLabel.textColor = [UIColor whiteColor];
            [button setTitle:tag.tagTitle forState:(UIControlStateNormal)];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 2;
            [self.contentView addSubview:button];
            [self.contentView bringSubviewToFront:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(@(index * (sizeone.width+25 + 2) + 15));
                make.height.mas_equalTo(@(21));
                make.bottom.mas_equalTo(self.headBackView.mas_top).mas_offset(-15);
                make.width.mas_equalTo(@(sizetwo.width+20));
                
            }];
        }else{
            Tags *tagg = arr[2];
            sizethree = [tagg.tagTitle sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11.0f]}];
            button = [[FZTripBtn alloc] initWithFrame:CGRectMake( sizetwo.width +20 +2 +(sizeone.width+25+2) + 15, self.headBackView.mj_y-10-21, sizethree.width+20, 21)];
            button.tag = 200 + i;
            if (0 == i) {
                [button setImage:[UIImage imageNamed:@"黄标签"] forState:(UIControlStateNormal)];
        
            }
            button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            button.titleLabel.font = [UIFont systemFontOfSize:11];
            
            button.titleLabel.textColor = [UIColor whiteColor];
            [button setTitle:tag.tagTitle forState:(UIControlStateNormal)];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 2;
            [self.contentView addSubview:button];
            [self.contentView bringSubviewToFront:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(@( sizetwo.width +20 +2 +(sizeone.width+25+2) + 15));
                make.height.mas_equalTo(@(21));
                make.bottom.mas_equalTo(self.headBackView.mas_top).mas_offset(-15);
                make.width.mas_equalTo(@(sizethree.width+20));
                
            }];
        }
    }


    //是否关注
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
    [parm setObject:model.vid forKey:@"targetId"];
    [parm setObject:@"1" forKey:@"targetType"];
    if (model.userInfo.uid.length > 0) {
        [parm setObject:model.userInfo.uid forKey:@"followTargetId"];
    }
    [parm setObject:@"0" forKey:@"followType"];

    NSString *JsonParameter = [FZParmTODicString convertToJsonData:parm];
     NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:JsonParameter forKey:@"JsonParameter"];
    [FZNetworkingManager requestLittleAntMethod:@"getUserLikeLog" parameters:dic requestHandler:^(BOOL success, id  _Nullable response) {
         NSLog(@"haha");
        if (success == YES) {
            NSData *jsonData =[ [response objectForKey:@"response"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            if ([[dic objectForKey:@"currentUserIsLike"] integerValue] == 1) {
                [self.isLickBtn setImage:[UIImage imageNamed:@"已点赞"] forState:(UIControlStateNormal)];
                [self.isLickBtn setTitle:[dic objectForKey:@"likeCount"] forState:(UIControlStateNormal)];
                self.isLike  = [NSString stringWithFormat:@"%@",[dic objectForKey:@"currentUserIsLike"]];
            }else{
                [self.isLickBtn setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
                [self.isLickBtn setTitle:[dic objectForKey:@"likeCount"] forState:(UIControlStateNormal)];
                self.isLike  = [NSString stringWithFormat:@"%@",[dic objectForKey:@"currentUserIsLike"]];
            }
            [self.disCUSSInfoBtn setTitle:[dic objectForKey:@"disCount"] forState:(UIControlStateNormal)];
            
            if ([[dic objectForKey:@"isFollow"] integerValue] == 1) {
//                self.attentionBtn.backgroundColor = [UIColor clearColor];
                   [self.attentionBtn setBackgroundImage:[UIImage imageNamed:@"已关注"] forState:(UIControlStateNormal)];

            }else{
//                self.attentionBtn.backgroundColor = APP_BLUE_COLOR;
                [self.attentionBtn setBackgroundImage:[UIImage imageNamed:@"加关注"] forState:(UIControlStateNormal)];
            }
            
            
        }
        
    }];
    
    if ([model.userInfo.uid isEqualToString:[FZUserInformation shareInstance].userModel.uid]) {
        self.attentionBtn.hidden = YES;
        self.delectBtnHigth.constant = 0;
    }else{
        self.attentionBtn.hidden = NO;
        self.delectBtnHigth.constant = 0;
    }
    
}
//评论大按钮
- (IBAction)commentAction:(id)sender {
    SuppressPerformSelectorLeakWarning(
                                       if ([_delegate respondsToSelector:@selector(clickCommentAction:withCell:)])
                                       {
                                           [_delegate performSelector:@selector(clickCommentAction:withCell:) withObject:sender withObject:self];
                                       });

}
//跟拍
- (IBAction)followingPalyAction:(id)sender {
    SuppressPerformSelectorLeakWarning(
                                       if ([_delegate respondsToSelector:@selector(clickFlowingAction:withCell:)])
                                       {
                                           [_delegate performSelector:@selector(clickFlowingAction:withCell:) withObject:sender withObject:self];
                                       });
}
//点赞
- (IBAction)lickBtnAction:(id)sender {

    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:_model.vid forKey:@"videoId"];
    [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
         [parm setObject:self.isLike  forKey:@"changeType"];
    [FZNetworkingManager requestLittleAntMethod:@"changeVideoLikeCount" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        NSLog(@"haha");
        if (success == YES) {

            NSMutableDictionary *parmparm = [[NSMutableDictionary alloc]init];
            [parmparm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
            [parmparm setObject:self->_model.vid forKey:@"targetId"];
            [parmparm setObject:@"1" forKey:@"targetType"];
            if (self->_model.userInfo.uid.length > 0) {
               [parmparm setObject:self->_model.userInfo.uid forKey:@"followTargetId"];
            }
            [parmparm setObject:@"0" forKey:@"followType"];
            
            NSString *JsonParameter = [FZParmTODicString convertToJsonData:parmparm];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:JsonParameter forKey:@"JsonParameter"];
            [FZNetworkingManager requestLittleAntMethod:@"getUserLikeLog" parameters:dic requestHandler:^(BOOL success, id  _Nullable response) {
                NSLog(@"haha");
                if (success == YES) {
                    NSData *jsonData =[ [response objectForKey:@"response"] dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *err;
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:&err];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationDianZsnShortVideo object:nil];
                    
                    if ([[dic objectForKey:@"currentUserIsLike"] integerValue] == 1) {
                        [self.isLickBtn setImage:[UIImage imageNamed:@"已点赞"] forState:(UIControlStateNormal)];
                        [self.isLickBtn setTitle:[dic objectForKey:@"likeCount"] forState:(UIControlStateNormal)];
                        self.isLike  = [NSString stringWithFormat:@"%@",[dic objectForKey:@"currentUserIsLike"]];
                        [self.isLickBtn setTitleColor:[UIColor colorWithHexString:@"FC5D51"] forState:UIControlStateNormal];
                    }else{
                        [self.isLickBtn setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
                        [self.isLickBtn setTitle:[dic objectForKey:@"likeCount"] forState:(UIControlStateNormal)];
                        self.isLike  = [NSString stringWithFormat:@"%@",[dic objectForKey:@"currentUserIsLike"]];
                        [self.isLickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }
                    
                    
                    
                    
                }
                
            }];
        }
    }];
}
//评论数量
- (IBAction)commretNumberAction:(id)sender {

    SuppressPerformSelectorLeakWarning(
                                       if ([_delegate respondsToSelector:@selector(clickCommentNumberAction:withCell:)])
                                       {
                                           [_delegate performSelector:@selector(clickCommentNumberAction:withCell:) withObject:sender withObject:self];
                                       });
}
//分享
- (IBAction)shareAction:(id)sender {

    SuppressPerformSelectorLeakWarning(
                                       if ([_delegate respondsToSelector:@selector(clickShareAction:withCell:)])
                                       {
                                           [_delegate performSelector:@selector(clickShareAction:withCell:) withObject:sender withObject:self];
                                       });

}
- (IBAction)delectAction:(id)sender {
    SuppressPerformSelectorLeakWarning(
                                       if ([_delegate respondsToSelector:@selector(delectBtnAction:withCell:)])
                                       {
                                           [_delegate performSelector:@selector(delectBtnAction:withCell:) withObject:sender withObject:self];
                                       });

    
}

- (IBAction)chagllAction:(id)sender {
    
    SuppressPerformSelectorLeakWarning(
                                       if ([_delegate respondsToSelector:@selector(chagllActionAction:withCell:)])
                                       {
                                           [_delegate performSelector:@selector(chagllActionAction:withCell:) withObject:sender withObject:self];
                                       });
    
}

//关注
- (IBAction)attentionAtion:(id)sender {
    
//    SuppressPerformSelectorLeakWarning(
//                                       if ([_delegate respondsToSelector:@selector(attentionAtio:withCell:)])
//                                       {
//                                           [_delegate performSelector:@selector(attentionAtio:withCell:) withObject:sender withObject:self];
//                                       });
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    [dic setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
//     [dic setObject:_model.userInfo.uid forKey:@"targetId"];
//     [dic setObject:@"0" forKey:@"targetType"];
//    NSString *json = [FZParmTODicString convertToJsonData:dic];
//
//    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
//    [parm setObject:@"0" forKey:@"changeType"];
//    [parm setObject:json forKey:@"userFollowInfoJson"];
//
//    [FZNetworkingManager requestLittleAntMethod:@"changeUserFollowInfo" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
//
//        if (success == YES) {
//
//        }
//    }];
    
    
    NSMutableDictionary *parmparm = [[NSMutableDictionary alloc]init];
    [parmparm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
    [parmparm setObject:self->_model.vid forKey:@"targetId"];
    [parmparm setObject:@"1" forKey:@"targetType"];
    if (self->_model.userInfo.uid.length > 0) {
        [parmparm setObject:self->_model.userInfo.uid forKey:@"followTargetId"];
    }    [parmparm setObject:@"0" forKey:@"followType"];
    
    NSString *JsonParameter = [FZParmTODicString convertToJsonData:parmparm];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:JsonParameter forKey:@"JsonParameter"];
    [FZNetworkingManager requestLittleAntMethod:@"getUserLikeLog" parameters:dic requestHandler:^(BOOL success, id  _Nullable response) {
        NSLog(@"haha");
        if (success == YES) {
            NSData *jsonData =[ [response objectForKey:@"response"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dd = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            
            
                NSMutableDictionary *dicc = [[NSMutableDictionary alloc]init];
                [dicc setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
                [dicc setObject:self->_model.userInfo.uid forKey:@"targetId"];
                 [dicc setObject:@"0" forKey:@"targetType"];
                NSString *json = [FZParmTODicString convertToJsonData:dicc];
                NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
                [parm setObject:json forKey:@"userFollowInfoJson"];
            
            if ([[dd objectForKey:@"isFollow"] integerValue] == 1) {
                 [parm setObject:@"1" forKey:@"changeType"];
            }else{
                 [parm setObject:@"0" forKey:@"changeType"];
            }
            [FZNetworkingManager requestLittleAntMethod:@"changeUserFollowInfo" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        
                if (success == YES) {
                    if ([[dd objectForKey:@"isFollow"] integerValue] == 1) {
                        [self.attentionBtn setBackgroundImage:[UIImage imageNamed:@"加关注"] forState:(UIControlStateNormal)];
                    }else{
                           [self.attentionBtn setBackgroundImage:[UIImage imageNamed:@"已关注"] forState:(UIControlStateNormal)];
                    }
                }
            }];
            
        }
        
    }];
    
    
}
//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                     context:nil];
    return rect.size.width;
    
}

@end
