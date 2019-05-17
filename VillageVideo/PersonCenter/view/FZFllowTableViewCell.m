//
//  FZFllowTableViewCell.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZFllowTableViewCell.h"
#import <UIImageView+WebCache.h>
@implementation FZFllowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(FZFllowModel *)model{
    _model = model;
    
        if (self.type == 0) {
            [self.headimGE sd_setImageWithURL:[NSURL URLWithString:model.fansUser.avatar]];
            self.NAMElaabel.text =model.fansUser.userName;
        }
        else if (self.type == 1){
            [self.headimGE sd_setImageWithURL:[NSURL URLWithString:model.littleVideoUser.avatar]];
            self.NAMElaabel.text =model.littleVideoUser.userName;
            if ([model.littleVideoUser.uid isEqualToString:[FZUserInformation shareInstance].userModel.uid]) {
                self.attemntBtn.hidden = YES;
            }else{
                 self.attemntBtn.hidden = NO;
            }
        }
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
    [parm setObject:model.littleVideoUser.uid forKey:@"followTargetId"];
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
            
            if ([[dic objectForKey:@"isFollow"] integerValue] == 1) {
                //                self.attentionBtn.backgroundColor = [UIColor clearColor];
                [self.attemntBtn setTitle:@"已关注" forState:(UIControlStateNormal)];
                [self.attemntBtn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
                [self viewLayer:self.attemntBtn andcornerRadius:2 andWidth:1 andborderColor:[UIColor colorWithHexString:@"C8C8C8"]];
                  [self.attemntBtn setTitleColor:[UIColor colorWithHexString:@"C8C8C8"] forState:(UIControlStateNormal)];
            }else{
                //                self.attentionBtn.backgroundColor = APP_BLUE_COLOR;
                [self.attemntBtn setTitle:@"关注" forState:(UIControlStateNormal)];
                [self.attemntBtn setImage:[UIImage imageNamed:@"＋"] forState:(UIControlStateNormal)];
                   [self viewLayer:self.attemntBtn andcornerRadius:2 andWidth:1 andborderColor:APP_BLUE_COLOR];
                 [self.attemntBtn setTitleColor:APP_BLUE_COLOR forState:(UIControlStateNormal)];
            }
        }
        
    }];
    

}
-(void)viewLayer:(UIView *)view andcornerRadius:(CGFloat)Radius andWidth:(CGFloat)width andborderColor:(UIColor *)color{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = Radius;
    view.layer.borderWidth = width;
    view.layer.borderColor = color.CGColor ;
    view.backgroundColor = [UIColor whiteColor];
}
- (IBAction)attentAction:(id)sender {

    
    NSMutableDictionary *parmparm = [[NSMutableDictionary alloc]init];
    [parmparm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
    if (self.type == 1) {
        [parmparm setObject:_model.littleVideoUser.uid forKey:@"followTargetId"];
    }else{
        [parmparm setObject:_mmm.uid forKey:@"followTargetId"];
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
            NSDictionary *dd = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&err];
            
            
            NSMutableDictionary *dicc = [[NSMutableDictionary alloc]init];
            [dicc setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
            if (self.type == 1) {
                [dicc setObject:self->_model.littleVideoUser.uid forKey:@"targetId"];
            }else{
                [dicc setObject:self->_mmm.uid forKey:@"targetId"];
            }
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
                        [self.attemntBtn setTitle:@"关注" forState:(UIControlStateNormal)];
                        [self.attemntBtn setImage:[UIImage imageNamed:@"＋"] forState:(UIControlStateNormal)];
                        [self viewLayer:self.attemntBtn andcornerRadius:2 andWidth:1 andborderColor:APP_BLUE_COLOR];
                        [self.attemntBtn setTitleColor:APP_BLUE_COLOR forState:(UIControlStateNormal)];
                    }else{
                        [self.attemntBtn setTitle:@"已关注" forState:(UIControlStateNormal)];
                        [self.attemntBtn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
                        [self viewLayer:self.attemntBtn andcornerRadius:2 andWidth:1 andborderColor:[UIColor colorWithHexString:@"C8C8C8"]];
                         [self.attemntBtn setTitleColor:[UIColor colorWithHexString:@"C8C8C8"] forState:(UIControlStateNormal)];
                    }
                }
            
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"guanzhuchenggong" object:nil];
                
           
            }];
            
        }
        
    }];
}
-(void)setMmm:(FZUserModel *)mmm{
    _mmm = mmm;
    
    if ([mmm.uid isEqualToString:[FZUserInformation shareInstance].userModel.uid]) {
        self.attemntBtn.hidden = YES;
    }else{
        self.attemntBtn.hidden = NO;
    }
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
    [parm setObject:mmm.uid forKey:@"followTargetId"];
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
            
            if ([[dic objectForKey:@"isFollow"] integerValue] == 1) {
                //                self.attentionBtn.backgroundColor = [UIColor clearColor];
                [self.attemntBtn setTitle:@"已关注" forState:(UIControlStateNormal)];
                [self.attemntBtn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
                [self viewLayer:self.attemntBtn andcornerRadius:2 andWidth:1 andborderColor:[UIColor colorWithHexString:@"C8C8C8"]];
                [self.attemntBtn setTitleColor:[UIColor colorWithHexString:@"C8C8C8"] forState:(UIControlStateNormal)];
            }else{
                //                self.attentionBtn.backgroundColor = APP_BLUE_COLOR;
                [self.attemntBtn setTitle:@"关注" forState:(UIControlStateNormal)];
                [self.attemntBtn setImage:[UIImage imageNamed:@"＋"] forState:(UIControlStateNormal)];
                [self viewLayer:self.attemntBtn andcornerRadius:2 andWidth:1 andborderColor:APP_BLUE_COLOR];
                [self.attemntBtn setTitleColor:APP_BLUE_COLOR forState:(UIControlStateNormal)];
            }
        }
        
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
