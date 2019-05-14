//
//  FZBindingPhnumberViewController.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/9/17.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZBindingPhnumberViewController.h"
#import <Masonry.h>
#import <YYWebImage.h>
@interface FZBindingPhnumberViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgOneView;
@property (weak, nonatomic) IBOutlet UITextField *phnumbgerTextFiled;
@property (weak, nonatomic) IBOutlet UIView *bgTwoView;
@property (weak, nonatomic) IBOutlet UITextField *codeTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property(nonatomic,strong)UIImageView *imageHeadimage;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *phnumberLabel;
@property(nonatomic,strong)UIButton *jiebangAction;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@end

@implementation FZBindingPhnumberViewController{
    dispatch_source_t _timer ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _bgOneView.layer.borderWidth = 0.3;
    _bgOneView.layer.borderColor = APP_Gray_COLOR.CGColor;
    _bgOneView.layer.masksToBounds = YES;
    _bgOneView.layer.cornerRadius = 2;
    _bgTwoView.layer.borderWidth = 0.3;
    _bgTwoView.layer.borderColor = APP_Gray_COLOR.CGColor;
    _bgTwoView.layer.masksToBounds = YES;
    _bgTwoView.layer.cornerRadius = 2;
    
    _sendBtn.layer.borderWidth = 1;
    _sendBtn.tag = 100;
    _sendBtn.layer.borderColor =APP_BLUE_COLOR.CGColor;
    _sendBtn.layer.masksToBounds = YES;
    _sendBtn.layer.cornerRadius = 2;
    [_sendBtn setTitleColor:APP_BLUE_COLOR forState:(UIControlStateNormal)];
    
    _sureBtn.backgroundColor = APP_BLUE_COLOR;
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.layer.cornerRadius = 2;
    
    [self configUI];
    [self showUI];
    
}
-(void)showUI{
    FZUserModel *model = [FZUserInformation shareInstance].userModel;
    if (model.phoneNumber.length > 0) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.bgOneView.hidden = YES;
        self.phnumbgerTextFiled.hidden = YES;
        self.bgTwoView.hidden = YES;
        self.codeTextFiled.hidden = YES;
        self.sendBtn.hidden = YES;
        self.sureBtn.hidden = YES;
        self.lineView.hidden = YES;
        
        self.imageHeadimage.hidden = NO;
        self.nameLabel.hidden = NO;
        self.phnumberLabel.hidden = NO;
        self.jiebangAction.hidden = NO;
    }else{
          self.view.backgroundColor = APP_Gray_COLOR;
        self.bgOneView.hidden = NO;
        self.phnumbgerTextFiled.hidden = NO;
        self.bgTwoView.hidden = NO;
        self.codeTextFiled.hidden = NO;
        self.sendBtn.hidden = NO;
        self.sureBtn.hidden = NO;
        self.lineView.hidden = NO;
        
        self.imageHeadimage.hidden = YES;
        self.nameLabel.hidden = YES;
        self.phnumberLabel.hidden = YES;
        self.jiebangAction.hidden = YES;
    }
}
//发送验证码
- (IBAction)senCodeAction:(id)sender {
    
    if ([Utility isValidTelephoneNum:_phnumbgerTextFiled.text] == NO) {
            [MBProgressHUD showSuccess:@"请输入正确的手机号" toView:self.view];
            return;
    }
    
    if (_phnumbgerTextFiled.text.length > 0) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:_phnumbgerTextFiled.text forKey:@"phoneNumber"];
        [FZNetworkingManager requestLittleAntMethod:@"getVerifyCodeForLittleVideoBinded" parameters:dic requestHandler:^(BOOL success, id  _Nullable response) {
            NSLog(@"");
            if (success == 1) {
                [MBProgressHUD showSuccess:@"短信验证码发送成功" toView:self.view];
                [self startTime:60 sendAuthCodeBtn:sender];
            }else{
                 [MBProgressHUD showSuccess:[response objectForKey:@"msg"] toView:self.view];
            }
        }];
    }else{
          [MBProgressHUD showSuccess:@"请输入手机号" toView:self.view];
    }

}
//确定绑定
- (IBAction)sureAction:(id)sender {
    
    
    if (_phnumbgerTextFiled.text.length  == 0) {
        [MBProgressHUD showSuccess:@"请输入手机号" toView:self.view];
        return;
    }
    if (_codeTextFiled.text.length  == 0) {
        [MBProgressHUD showSuccess:@"请输入验证码" toView:self.view];
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *dataParm = [[NSMutableDictionary alloc]init];
    [dic setValue:_phnumbgerTextFiled.text forKey:@"phoneNumber"];
    [dic setValue:_codeTextFiled.text forKey:@"verifyCode"];
    [FZNetworkingManager requestLittleAntMethod:@"validLittleVideoUserPhoneNumber" parameters:dic requestHandler:^(BOOL success, id  _Nullable response) {
        if (success == 1) {
            [dataParm setObject:self->_phnumbgerTextFiled.text forKey:@"phoneNumber"];
            NSMutableDictionary *dicc = [[NSMutableDictionary alloc]init];
            [dicc setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
            NSString *json = [FZParmTODicString convertToJsonData:dataParm];
            [dicc setObject:json forKey:@"userDatas"];
            [FZNetworkingManager requestLittleAntMethod:@"updateLittleVideoUser" parameters:dicc requestHandler:^(BOOL success, id  _Nullable response) {
                if (success == YES) {
//                    self->_timer  = nil;
                    UIButton *brn =(UIButton *) [self.view viewWithTag:100];
                          [self startTime:1 sendAuthCodeBtn:brn];
                    [self shuaxin];
                    self.bgOneView.hidden = YES;
                    self.phnumbgerTextFiled.hidden = YES;
                    self.bgTwoView.hidden = YES;
                    self.codeTextFiled.hidden = YES;
                    self.sendBtn.hidden = YES;
                    self.sureBtn.hidden = YES;
                       self.lineView.hidden = YES;
                          self.view.backgroundColor = [UIColor whiteColor];
                    self.imageHeadimage.hidden = NO;
                    self.nameLabel.hidden = NO;
                    self.phnumberLabel.hidden = NO;
                    self.jiebangAction.hidden = NO;
                    NSString * str  =  [NSString stringWithFormat:@"已绑定手机号：%@",self->_phnumbgerTextFiled.text];
                    self.phnumberLabel.attributedText = [self changeStringColor:str];
                    self.phnumbgerTextFiled.text = @"";
                    self.codeTextFiled.text = @"";
                    [[NSNotificationCenter defaultCenter]  postNotificationName:@"FZCompleteInformationViewController" object:nil];
                }else{
                   [MBProgressHUD showSuccess:[response objectForKey:@"msg"] toView:self.view];
                }
            }];
            
        }else{
            [MBProgressHUD showError:@"短信验证码错误" toView:self.view];
        }
    }];
    
}
-(void)configUI{
    FZUserModel *model = [FZUserInformation shareInstance].userModel;
    self.imageHeadimage = [[UIImageView alloc]init];
    self.imageHeadimage.yy_imageURL = [NSURL URLWithString:model.avatar];
    self.imageHeadimage.layer.masksToBounds = YES;
    self.imageHeadimage.layer.cornerRadius = 34;
    [self.view addSubview:self.imageHeadimage];
    [self.imageHeadimage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.view).mas_offset(30);
        make.size.mas_offset(CGSizeMake(68, 68));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.text = model.userName;
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.nameLabel.font = [UIFont systemFontOfSize:17];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.imageHeadimage.mas_bottom).mas_offset(14);
        make.size.mas_offset(CGSizeMake(200, 24));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    self.phnumberLabel = [[UILabel alloc]init];
       self.phnumberLabel.font = [UIFont systemFontOfSize:14];
     self.phnumberLabel.textColor = [UIColor colorWithHexString:@"333333"];
    NSString * str  =  [NSString stringWithFormat:@"已绑定手机号：%@",model.phoneNumber];
    self.phnumberLabel.attributedText = [self changeStringColor:str];
    self.phnumberLabel.text = [NSString stringWithFormat:@"已绑定手机号：%@",model.phoneNumber];
    self.phnumberLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.phnumberLabel];
    [self.phnumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(15);
        make.size.mas_offset(CGSizeMake(250, 20));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    self.jiebangAction = [[UIButton alloc]init];
     self.jiebangAction.backgroundColor = APP_BLUE_COLOR;
    [ self.jiebangAction setTitle:@"解绑" forState:(UIControlStateNormal)];
    self.jiebangAction.layer.masksToBounds = YES;
    self.jiebangAction.layer.cornerRadius = 5;
    [self.jiebangAction setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.jiebangAction addTarget:self action:@selector(completeAction:) forControlEvents:(UIControlEventTouchDown)];
    [self.view addSubview:self.jiebangAction];
    [self.jiebangAction mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.phnumberLabel.mas_bottom).mas_offset(60 );
        make.left.mas_equalTo(self.view.mas_left).mas_offset(15);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-15);
        make.height.mas_equalTo(45);
    }];
    
    
}
-(NSMutableAttributedString *)changeStringColor:(NSString *)strring{
    NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:strring];
       FZUserModel *model = [FZUserInformation shareInstance].userModel;
    if (model.phoneNumber.length > 0) {
        [attrDescribeStr addAttribute:NSForegroundColorAttributeName
         
                                value:APP_BLUE_COLOR
         
                                range:[strring rangeOfString:model.phoneNumber]];
    }else{
        [attrDescribeStr addAttribute:NSForegroundColorAttributeName
         
                                value:APP_BLUE_COLOR
         
                                range:[strring rangeOfString:_phnumbgerTextFiled.text]];
    }

    return attrDescribeStr;
}
//解绑
-(void)completeAction:(UIButton *)sender{
    
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
         NSMutableDictionary *dataParm = [[NSMutableDictionary alloc]init];
            [dataParm setValue:@"" forKey:@"phoneNumber"];
            [dic setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
            NSString *json = [FZParmTODicString convertToJsonData:dataParm];
            [dic setObject:json forKey:@"userDatas"];
            [FZNetworkingManager requestLittleAntMethod:@"updateLittleVideoUser" parameters:dic requestHandler:^(BOOL success, id  _Nullable response) {
                if (success == YES) {
                    [self shuaxin];
                    self.bgOneView.hidden = NO;
                    self.phnumbgerTextFiled.hidden = NO;
                    self.bgTwoView.hidden = NO;
                    self.codeTextFiled.hidden = NO;
                    self.sendBtn.hidden = NO;
                    self.sureBtn.hidden = NO;
                    self.lineView.hidden = NO;
                          self.view.backgroundColor = APP_Gray_COLOR;
                    self.imageHeadimage.hidden = YES;
                    self.nameLabel.hidden = YES;
                    self.phnumberLabel.hidden = YES;
                    self.jiebangAction.hidden = YES;

                    
//                    UIButton *brn =(UIButton *) [self.view viewWithTag:100];
//                    [self startTime:1 sendAuthCodeBtn:brn];
                    
                }else{
                     [MBProgressHUD showSuccess:[response objectForKey:@"msg"] toView:self.view];
                }
            }];
}
-(void)shuaxin{
    if ([FZUserInformation shareInstance].userModel.uid .length > 0) {
        NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
        [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"uid"];
        [FZNetworkingManager requestLittleAntMethod:@"getLittleVideoUserById" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
            NSLog(@"");
            if (success == YES) {
                NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
                [userDef setObject:[response objectForKey:@"response"] forKey:@"userInfo"];
            }
        }];
    }
}

#pragma mark 倒计时
- (void)startTime:(NSInteger)time sendAuthCodeBtn:(UIButton *)sendAuthCodeBtn {
    if (time > 59 || time < 1) {
        time = 59;
    }
    __block NSInteger timeout = time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0) { //倒计时结束，关闭
            dispatch_source_cancel(self->_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示
                [sendAuthCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                // iOS 7
                [sendAuthCodeBtn setTitle:@"发送验证码" forState:UIControlStateDisabled];
                sendAuthCodeBtn.enabled = YES;
            });
        } else {
            NSInteger seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2ld", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [sendAuthCodeBtn setTitle:[NSString stringWithFormat:@"重发(%@s)",strTime] forState:UIControlStateNormal];
                // iOS 7
                [sendAuthCodeBtn setTitle:[NSString stringWithFormat:@"重发(%@s)",strTime] forState:UIControlStateDisabled];
                sendAuthCodeBtn.enabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
@end
