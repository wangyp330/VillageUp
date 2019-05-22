//
//  FZAlertView.m
//  FZBaseLib
//
//  Created by Mac on 2018/7/9.
//  Copyright © 2018年 FZ. All rights reserved.
//

#import "FZAlertView.h"
#import "UIView+Frame.h"


const static CGFloat topSpace   = 35;

@interface FZAlertView ()

@property(nonatomic,strong)CustomIOSAlertView *alertView;
@end

@implementation FZAlertView
{

}

-(instancetype)initWithButtonTitles:(NSArray *)titles title:(NSString *)title message:(NSString *)message{
    self=[super init];
    if (self) {
        [self configAlertWithTitles:titles title:title message:message];
    }
    return self;
}

-(instancetype)initWithFiledAlert{
    self=[super init];
    if (self) {
        
    }
    return self;
}




-(void)configAlertWithTitles:(NSArray *)titles title:(NSString *)title message:(NSString *)message{
    
    UIView *conView=[self customViewWithTitle:title message:message];
    self.alertView.containerView=conView;
    
    __block FZAlertView *weakAlert=self;
    [self.alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        weakAlert.fzAlertViewButtonTouchedBlock(weakAlert, buttonIndex);
    }];
    //[_alertView setContainerView:[self createMessageView:string]];
    [self.alertView setButtonTitles:titles];
    [_alertView setUseMotionEffects:YES];
}

#pragma mark - 公开方法
-(void)show{
    [_alertView show];
}
-(void)close{
    [_alertView close];
}


#pragma mark - 私有方法
-(UIView *)customViewWithTitle:(NSString *)title message:(NSString *)message{
    
    CGFloat v_width=SCREEN_WIDTH-80;
    CGFloat start_y=topSpace;
    CGFloat v_height=25;
    CGFloat lab_width = v_width-80;
    
    UIView *view=[[UIView alloc]init];
    view.layer.masksToBounds=YES;
    view.layer.cornerRadius= 7;
    view.backgroundColor=[UIColor whiteColor];
    
    CGFloat iconImg_width = 25;
    UIImageView *iconImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"alert_worning"]];
    iconImg.frame=CGRectMake(0,0, iconImg_width, iconImg_width);
    
    
    UILabel *titleLab;
    if (title.length > 0) {
        titleLab =[[UILabel alloc]init];
        titleLab.textColor=[UIColor blackColor];
        titleLab.textAlignment=NSTextAlignmentLeft;
        [titleLab setFont:[UIFont boldSystemFontOfSize:16]];
        titleLab.width=lab_width;
        titleLab.lineBreakMode=NSLineBreakByCharWrapping;
        //titleLab.backgroundColor=[UIColor redColor];
        titleLab.numberOfLines=0;
        titleLab.text=title;
        [titleLab sizeToFit];
        titleLab.frame=CGRectMake(10,start_y, titleLab.width, titleLab.height);
        titleLab.centerX=v_width/2 + 15;
        v_height = titleLab.MaxY;
        start_y=titleLab.MaxY+8;
    }
    
    UILabel *messageLab;
    if (message.length > 0) {
        messageLab=[[UILabel alloc]init];
        messageLab.textColor=[UIColor blackColor];
        messageLab.textAlignment=NSTextAlignmentLeft;
        [messageLab setFont:[UIFont systemFontOfSize:15]];
        //messageLab.backgroundColor=[UIColor yellowColor];
        messageLab.numberOfLines=0;
        messageLab.lineBreakMode=NSLineBreakByCharWrapping;
        messageLab.text=message;
        if (title) {
            messageLab.width=v_width-50;
            [messageLab sizeToFit];
            messageLab.frame=CGRectMake(10,start_y, messageLab.width, messageLab.height);
            messageLab.centerX=v_width/2;
        }else{
            messageLab.width=lab_width;
            [messageLab sizeToFit];
            messageLab.frame=CGRectMake(10,start_y, messageLab.width, messageLab.height);
            messageLab.centerX=v_width/2 + 15;
        }
        v_height=messageLab.MaxY;
    }
    v_height+=topSpace;
    
    
    view.frame=CGRectMake(0, 0, v_width, v_height);
    if (title) {
        [view addSubview:titleLab];
    }
    if (message) {
        [view addSubview:messageLab];
    }
    
    
    ///iconImg 位置
    if (title) {
        iconImg.frame=CGRectMake(titleLab.x-iconImg_width-8, 0, iconImg_width, iconImg_width);
        iconImg.centerY=titleLab.centerY;
    }else{
        if (messageLab.height > 50) {
            //超出三行message
            iconImg.frame=CGRectMake(messageLab.x-iconImg_width-8, messageLab.y+3, iconImg_width, iconImg_width);
        }else{
            iconImg.frame=CGRectMake(messageLab.x-iconImg_width-8, 0, iconImg_width, iconImg_width);
            iconImg.centerY=messageLab.centerY;
        }
    }
    
    
    [view addSubview:iconImg];
    return view;
}


#pragma mark - customAlertDelegate
- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (self.delegate) {
//        [self.delegate fzAlertViewButtonTouched:self clickedButtonAtIndex:buttonIndex];
//    }
}

#pragma mark - 懒加载
-(CustomIOSAlertView *)alertView{
    if (!_alertView) {
        _alertView=[[CustomIOSAlertView alloc]init];
        _alertView.delegate=self;
    }
    return _alertView;
}
@end
