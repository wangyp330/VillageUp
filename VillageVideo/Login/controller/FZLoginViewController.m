//
//  FZLoginViewController.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZLoginViewController.h"
#import "FZBindingViewController.h"
#import "NotificationCenter.h"
#import "DHGuidePageHUD.h"
#import <WXApi.h>
#import "FZBaseWebViewController.h"
@interface FZLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *acountTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *otherLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *wexinLoginBtn;
@property (weak, nonatomic) IBOutlet UIView *viewObe;
@property (weak, nonatomic) IBOutlet UIView *viewB;
@property (weak, nonatomic) IBOutlet UILabel *weChatLabel;

@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak ,nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation FZLoginViewController
{
    NSTimer *codeTimer;
    NSInteger timeCount;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.acountTextFiled.hidden = YES;
//    self.passWordTextFiled.hidden = YES;
//    self.otherLoginBtn.hidden = YES;
    
    self.navigationController.navigationBar.hidden = YES;
    
    if ([WXApi isWXAppInstalled]) {
        
    }
    else {
        self.wexinLoginBtn.hidden = YES;
        self.weChatLabel.hidden = YES;
    }

}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechatDidLoginNotification" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.viewB.userInteractionEnabled = YES;
    self.viewObe.userInteractionEnabled = YES;
    // 设置APP引导页
    if ([NSUSERGET(BOOLFORKEY) isEqualToString:@"1"]) {
  
        // 静态引导页
        [self setStaticGuidePage];
        
        // 动态引导页
        // [self setDynamicGuidePage];
        
        // 视频引导页
        // [self setVideoGuidePage];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatDidLoginNotification:) name:@"wechatDidLoginNotification" object:nil];
//    NSMutableDictionary *dic = [NSMutableDictionary new];
//    [FZNetworkingManager requestLittleAntMethod:@"getIOSLittleVideoVserion" parameters:dic requestHandler:^(BOOL success, id  _Nullable response) {
//        NSLog(@"");
//        if ([[response objectForKey:@"isIosCheckVersion"] integerValue] == 1) {
//            self.acountTextFiled.hidden = NO;
//            self.passWordTextFiled.hidden = NO;
//            self.otherLoginBtn.hidden = NO;
//        }else{
//            self.acountTextFiled.hidden = YES;
//            self.passWordTextFiled.hidden = YES;
//            self.otherLoginBtn.hidden = YES;
//        }
//    }];
}
-(void)wechatDidLoginNotification:(NSNotification *)no{
    [self getWechatAccessTokenWithCode:[no.userInfo objectForKey:@"code"]];
}
- (void)getWechatAccessTokenWithCode:(NSString *)code
{
    NSString *url =[NSString stringWithFormat:
                    @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",
                    @"wxb18c28a3313f183e",@"94e3c642d928a6aa0e2a137a0babd7b4",code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"%@",dic);
                NSString *accessToken = dic[@"access_token"];
                NSString *openId = dic[@"openid"];
                
                [self getWechatUserInfoWithAccessToken:accessToken openId:openId];
            }
        });
    });
}
- (void)getWechatUserInfoWithAccessToken:(NSString *)accessToken openId:(NSString *)openId
{
    NSString *url =[NSString stringWithFormat:
                    @"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"%@",dic);
                
                NSString *openId = [dic objectForKey:@"unionid"];
                NSString *memNickName = [dic objectForKey:@"nickname"];
                NSString *avator = [dic objectForKey:@"headimgurl"];
                NSString *iddd = [dic objectForKey:@"openid"];
                //登录
                //
                [self loginWithWeChatOpenId:openId memNickName:memNickName avator:avator dataSource:@"WECHAT" openId:iddd];
            }
        });
        
    });
}
//第三方登录
-(void)loginWithWeChatOpenId:(NSString *)openID memNickName:(NSString *)memNickName avator:(NSString *)avator dataSource:(NSString *)dataSource openId:(NSString *)openId{
    /*
     ittleVideoUser thirdLogin(String userName, String avator,
     String thirdSystemId, String dataSource)
     */
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:memNickName forKey:@"userName"];
    [parm setObject:avator forKey:@"avator"];
    [parm setObject:openID forKey:@"thirdSystemId"];
    [parm setObject:dataSource forKey:@"dataSource"];
    [parm setObject:openId forKey:@"openId"];
    
    [FZNetworkingManager requestLittleAntMethod:@"thirdLogin" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        NSString *msg=[response objectForKey:@"msg"];
        if (success) {
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            [userDef setObject:[response objectForKey:@"response"] forKey:@"userInfo"];
            [userDef setObject:[NSString stringWithFormat:@"%@",[response objectForKey:@"isIosCheckVersion"]] forKey:@"isIosCheckVersion"];
            [userDef setObject:@"1" forKey:@"UserState"];
            [userDef synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUserLoginCount object:nil];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
    
}

-(IBAction)timeButtonClick:(UIButton *)button{
    
    if (_acountTextFiled.text.length > 10) {
        [self openTimer];
        button.userInteractionEnabled=NO;
    }else{
        [MBProgressHUD showSuccess:@"请输入正确的手机号" toView:self.view];
    }
    
    
}

-(void)openTimer{
    timeCount = 60;
    if (!codeTimer) {
        codeTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:codeTimer forMode:NSDefaultRunLoopMode];
    }
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:self.acountTextFiled.text forKey:@"phoneNumber"];
    [FZNetworkingManager requestLittleAntMethod:@"getLittleVillageLoginVerifyCode" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        NSString *msg=[response objectForKey:@"msg"];
        if (success) {
            [self->codeTimer fire];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
    
}

-(void)timerFired{
    _timeLab.text=[NSString stringWithFormat:@"%lds",timeCount];
    _timeLab.textColor=[UIColor lightGrayColor];
     timeCount -- ;
    if (timeCount == 0) {
        [codeTimer invalidate];
        _timeButton.userInteractionEnabled=YES;
        _timeLab.text=[NSString stringWithFormat:@"获取验证码"];
        _timeLab.textColor=[UIColor blackColor];
    }
}

#pragma mark - 设置APP静态图片引导页
- (void)setStaticGuidePage {
    NSArray *imageNameArray = @[@"引导页1",@"引导页2",@"引导页3",@"引导页4"];
    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:[UIScreen mainScreen].bounds imageNameArray:imageNameArray buttonIsHidden:NO];
    guidePage.slideInto = YES;
    [self.view addSubview:guidePage];
    [self.view bringSubviewToFront:guidePage];
}
- (IBAction)loginAction:(id)sender {
//    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
//    [parm setObject:self.acountTextFiled.text forKey:@"colAccount"];
//    [parm setObject:self.passWordTextFiled.text forKey:@"colPasswd"];
//    [FZNetworkingManager requestLittleAntMethod:@"LittleAntLogin" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
//        NSString *msg=[response objectForKey:@"msg"];
//        if (success) {
//            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//            [userDef setObject:[response objectForKey:@"response"] forKey:@"userInfo"];
//            [userDef setObject:[NSString stringWithFormat:@"%@",[response objectForKey:@"isIosCheckVersion"]] forKey:@"isIosCheckVersion"];
//            [userDef setObject:@"1" forKey:@"UserState"];
//            [userDef synchronize];
//            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUserLoginCount object:nil];
//        }else{
//            [MBProgressHUD showError:msg toView:self.view];
//        }
//    }];
    [self phoneNumberLogin];
}
- (IBAction)wxLoginAction:(id)sender {
    
    if ([WXApi isWXAppInstalled]) {
        
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"App";
        [WXApi sendReq:req];
    }
    else {
        [self setupAlertController];
    }
}

- (void)setupAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:actionConfirm];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (IBAction)userKonow:(id)sender {
    
    FZBaseWebViewController *vc = [[FZBaseWebViewController alloc]init];
        vc.title = @"用户须知";
    vc.hostUrl = @"http://jiaoxue.maaee.com:8091/#/littleAntPolicy";
    vc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    [self.navigationController pushViewController:vc animated:YES];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:na animated:YES completion:nil];
}


#pragma mark --- 手机号登录
-(void)phoneNumberLogin{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:self.acountTextFiled.text forKey:@"phoneNumber"];
    [parm setObject:self.passWordTextFiled.text forKey:@"verifyMessage"];
    [FZNetworkingManager requestLittleAntMethod:@"phoneNumberLittleVillageLogin" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        NSString *msg=[response objectForKey:@"msg"];
        if (success) {
            NSDictionary *userInfoDic=[response objectForKey:@"response"];
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            [userDef setObject:userInfoDic forKey:@"userInfo"];
            [userDef setObject:[NSString stringWithFormat:@"%@",[response objectForKey:@"isIosCheckVersion"]] forKey:@"isIosCheckVersion"];
            [userDef setObject:@"1" forKey:@"UserState"];
            [userDef synchronize];
            
            NSString *isDel=[NSString stringWithFormat:@"%@",[userDef objectForKey:@"isdelete"]];
            [userDef setObject:isDel forKey:@"isdelete"];
            if ([[FZUserInformation shareInstance].userModel.isdelete isEqualToString:@"0"]) {
                //完善信息
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUserLoginCount object:nil];
                
            }
        }else{
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

#pragma mark - 注册
-(IBAction)regeist:(UIButton *)sender{
    
}


@end
