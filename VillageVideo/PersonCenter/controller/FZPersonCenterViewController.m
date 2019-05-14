//
//  FZPersonCenterViewController.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZPersonCenterViewController.h"
#import "OwenProductViewController.h"
#import <VTMagic.h>
#import "FZBindingViewController.h"
#import "FZScanViewController.h"
#import "UIView+ZFFrame.h"
#import "FZLookFansViewController.h"
#import "FZWebViewController.h"
#import "FZUserModel.h"
#import "FZBaseWebViewController.h"

#import <Masonry.h>
#import <WXApi.h>
#import "ShareView.h"
#import "ZFDouYinViewController.h"
#import "HVideoViewController.h"
#import "TOCropViewController.h"
#import "FZPersonalCenterViewController.h"
#define DeviceSize   [UIScreen mainScreen].bounds.size
@interface FZPersonCenterViewController ()<VTMagicViewDelegate,VTMagicViewDataSource,FZWebViewControllerDelegate>{
    NSArray *_menuList;
     HVideoViewController *ctrl;
}
@property (weak, nonatomic) IBOutlet UIView *personInformationBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *personInformationBgViewHigth;
@property(nonatomic,strong)VTMagicController *magicController;
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userIdLab;
@property (nonatomic, strong) OwenProductViewController *ProductViewController;
@property (nonatomic, strong) OwenProductViewController *collViewController;
@property (nonatomic, strong) OwenProductViewController *likeViewController;
@property (nonatomic, strong) FZBaseWebViewController *articleViewController;
@property (nonatomic, strong) FZBaseWebViewController *collectViewController;
@property (nonatomic, strong) FZBaseWebViewController *bokokViewController;
@property (nonatomic, strong) FZBaseWebViewController *tasktViewController;

@property (weak, nonatomic) IBOutlet UIButton *guanzhuBtn;
@property (nonatomic, strong) NSArray  *tripArray;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UIImageView *huiyuanImage;
@property (weak, nonatomic) IBOutlet UILabel *huiyuanTImeLabel;
@end

@implementation FZPersonCenterViewController\
{
   UIButton *backButton;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (IBAction)guanzhuAction:(id)sender {
    
    NSMutableDictionary *parmparm = [[NSMutableDictionary alloc]init];
    [parmparm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
        [parmparm setObject:self.userId forKey:@"followTargetId"];
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
            [dicc setObject:self.userId forKey:@"targetId"];
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
                        [self.guanzhuBtn setTitle:@"关注" forState:(UIControlStateNormal)];
                        [self.guanzhuBtn setImage:[UIImage imageNamed:@"＋_act"] forState:(UIControlStateNormal)];
                    }else{
                        [self.guanzhuBtn setTitle:@"已关注" forState:(UIControlStateNormal)];
                        [self.guanzhuBtn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
                    }
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"guanzhuchenggong" object:nil];
            }];
            
        }
        
    }];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    
    self.userHeadImage.layer.borderWidth = 1;
    self.userHeadImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self getDynamicUserInfo];;
//    self.navigationController.navigationBar.hidden = YES;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *aa = [def objectForKey:@"isIosCheckVersion"];
    if ([aa isEqualToString:@"1"]) {
        self.huiyuanImage.hidden = YES;
        self.huiyuanTImeLabel.hidden = YES;
    }else{
        self.huiyuanImage.hidden = NO;
        self.huiyuanTImeLabel.hidden = NO;
    }

    CGFloat wodth =     [self getWidthWithText:@"已关注" height:21 font:11];
    [self.guanzhuBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 1, 0, 0)];
    [self.guanzhuBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -1)];
    self.guanzhuBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    
    [ self.guanzhuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(wodth+20));
    }];
    if ([self.userId isEqualToString:[FZUserInformation shareInstance].userModel.uid]) {
        self.guanzhuBtn.hidden = YES;
    }else{
           self.guanzhuBtn.hidden = NO;
    }
    if (self.userId && self.userId.length > 0) {
        
        NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
        
        [parm setObject:self.userId forKey:@"uid"];
        [FZNetworkingManager requestLittleAntMethod:@"getLittleVideoUserById" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
            if (success == YES) {
                FZUserModel *model = [[FZUserModel alloc]initWithDictionary:[response objectForKey:@"response"] error:nil];
                NSTimeInterval interval    =[model.rechargeEndtime doubleValue] / 1000.0;
                NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSString *dateString       = [formatter stringFromDate: date];
                [self dateTimeDifferenceWithStartTime:dateString];
                
                [self.userHeadImage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"defaultHeader"]];
                self.userName.text = model.userName;
                self.userIdLab.text=[NSString stringWithFormat:@"ID:%@",model.uid];
                if ([model.vIP isEqualToString:@"1"]) {
                    self.huiyuanImage.image = [UIImage imageNamed:@"会员"];
                    self.huiyuanTImeLabel.text = [NSString stringWithFormat:@"%@会员还有%ld天到期  ",@"哈了",labs([self dateTimeDifferenceWithStartTime:dateString])];
                }else{
                    self.huiyuanImage.image = [UIImage imageNamed:@"会员_act"];
                    self.huiyuanTImeLabel.text = [NSString stringWithFormat:@"%@当前未开通VIP会员  ",@"哈了"];
                }
            }
            
        }];

    }else{
        self.userId=[FZUserInformation shareInstance].userModel.uid;
         NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
        [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"uid"];
        [FZNetworkingManager requestLittleAntMethod:@"getLittleVideoUserById" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
            NSLog(@"");
            if (success == YES) {
                NSString *iud = [FZUserInformation shareInstance].userModel.uid;
                if ([self.userId isEqualToString:iud]) {
                    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
                    [userDef setObject:[response objectForKey:@"response"] forKey:@"userInfo"];
                }
                FZUserModel *model = [[FZUserModel alloc]initWithDictionary:[response objectForKey:@"response"] error:nil];
                NSTimeInterval interval    =[model.rechargeEndtime doubleValue] / 1000.0;
                NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSString *dateString       = [formatter stringFromDate: date];
                [self dateTimeDifferenceWithStartTime:dateString];
                [self.userHeadImage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"defaultHeader"]];
                self.userName.text = model.userName;
                if ([model.vIP isEqualToString:@"1"]) {
                    self.huiyuanImage.image = [UIImage imageNamed:@"会员"];
                    self.huiyuanTImeLabel.text = [NSString stringWithFormat:@"%@会员还有%ld天到期  ",@"哈了",labs([self dateTimeDifferenceWithStartTime:dateString])];
                }else{
                    self.huiyuanImage.image = [UIImage imageNamed:@"会员_act"];
                    self.huiyuanTImeLabel.text = [NSString stringWithFormat:@"%@当前未开通VIP会员  ",@"哈了"];
                }
            }

        }];
    }
    self.navigationController.navigationBar.hidden = YES;
    
//    if ([[FZUserInformation shareInstance].userModel.utype isEqualToString:@"TEAC"]) {
//        //老师
//        _scanBtn.hidden=NO;
//
//    }else if ([[FZUserInformation shareInstance].userModel.utype isEqualToString:@"STUD"]){
//        //学生
//        _scanBtn.hidden=YES;
//    }
    
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
//    if (!_isSelf) {
//        //自己
//        _settingBtn.hidden=NO;
//        _scanBtn.hidden=NO;
////        backButton.hidden=YES;
//        
//    }else{
//        _settingBtn.hidden=YES;
//        _scanBtn.hidden=YES;
////        backButton.hidden=NO;
//    }
    
//    if ([self.userId isEqualToString:[FZUserInformation shareInstance].userModel.uid]) {
//        _settingBtn.hidden=NO;
//        _scanBtn.hidden=NO;
//    }
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
    [parm setObject:self.userId forKey:@"followTargetId"];
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
                [self.guanzhuBtn setTitle:@"已关注" forState:(UIControlStateNormal)];
                   [self.guanzhuBtn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
            }else{
                //                self.attentionBtn.backgroundColor = APP_BLUE_COLOR;
                [self.guanzhuBtn setTitle:@"关注" forState:(UIControlStateNormal)];
                [self.guanzhuBtn setImage:[UIImage imageNamed:@"＋_act"] forState:(UIControlStateNormal)];
            }
            
            
        }
        
    }];
    
    
    
    
    
}
- (void)goBackAction
{
    // 在这里增加返回按钮的自定义动作
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)getDynamicUserInfo{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    if (self.userId && self.userId.length > 0) {
        [parm setObject:self.userId forKey:@"userId"];
    }else{
        [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
    }
    [FZNetworkingManager requestLittleAntMethod:@"getDynamicUserInfo" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
       
        if (success == YES) {
            UIButton *btn0 = (UIButton *)[self.view viewWithTag:200];
            UIButton *btn1 = (UIButton *)[self.view viewWithTag:201];
            UIButton *btn2 = (UIButton *)[self.view viewWithTag:202];
            [btn0 setTitle:[NSString stringWithFormat:@"粉丝\n%@",[[response objectForKey:@"response"] objectForKey:@"fansCount"]] forState:UIControlStateNormal];
            [btn1 setTitle:[NSString stringWithFormat:@"关注\n%@",[[response objectForKey:@"response"] objectForKey:@"followCount"]] forState:UIControlStateNormal];
            [btn2 setTitle:[NSString stringWithFormat:@"审核\n%@",[[response objectForKey:@"response"] objectForKey:@"auditCount"]] forState:UIControlStateNormal];
        }
    }];
    
}
-(void)creatLabel{
   
    if ([[FZUserInformation shareInstance].userModel.utype isEqualToString:@"TEAC"]) {
        //老师
         _tripArray = @[@"粉丝",@"关注"];
    }else{
         _tripArray = @[@"粉丝",@"关注"];
    }
    CGFloat btn_width= 90;
    CGFloat space =50;
    CGFloat btn_space=(SCREEN_WIDTH-(btn_width * _tripArray.count)-(space*2))/(_tripArray.count-1);
    for (NSInteger i=0; i<_tripArray.count; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(space+(i*(btn_width+btn_space)), 190, btn_width, 40);
        button.titleLabel.font=[UIFont systemFontOfSize:17];
        button.titleLabel.textAlignment=NSTextAlignmentCenter;
         button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.view addSubview:button];
        button.tag=200+i;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)actionButtonClick:(UIButton *)button{
   
    if (button.tag == 200) {
        //粉丝
        FZLookFansViewController *vc = [[FZLookFansViewController alloc]init];
        vc.userId = self.userId;
        vc.type = 0;
        vc.title = @"我的粉丝";
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 201) {
        //关注
        FZLookFansViewController *vc = [[FZLookFansViewController alloc]init];
        vc.userId = self.userId;
        vc.type = 1;
        vc.title = @"我的关注";
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 202) {
        //审核
        FZBaseWebViewController *vc = [[FZBaseWebViewController alloc]init];
        vc.title = @"审核列表";
        vc.hostUrl =[NSString stringWithFormat:@"%@/#/lookThrough?auditorId%@",App_JAIOXUYE_BASE_URL,[FZUserInformation shareInstance].userModel.uid];;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)shuaxin{
    [self viewWillAppear:YES];
}
- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                     context:nil];
    return rect.size.width;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    [self creatLabel];
    [self configCustomSlider];
//    if ([[FZUserInformation shareInstance].userModel.utype isEqualToString:@"TEAC"]) {
//        //老师
          _menuList = @[@"视频",@"文章",@"喜欢",@"收藏",@"错题本",@"主题任务"];
//    }else{
//        _menuList = @[@"视频",@"我喜欢的",@"收藏"];
//    }
    if (self.userId && self.userId.length > 0) {
        self.settingBtn.hidden=YES;
        self.scanBtn.hidden=YES;
        [self configBackButton];
    }else{
        backButton.hidden=YES;
        self.settingBtn.hidden=NO;
        self.scanBtn.hidden=NO;
        self.userId=[FZUserInformation shareInstance].userModel.uid;
    }
    [_magicController.magicView reloadData];

}


#pragma mark - 自定义backbutton
-(void)configBackButton{
    backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(cusBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.personInformationBgView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.mas_equalTo(9);
        make.left.mas_equalTo(10);
    }];
}

-(void)cusBackBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)dateTimeDifferenceWithStartTime:(NSString *)startTime

{
    
    NSDate *now = [NSDate date];
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *startDate =[formatter dateFromString:startTime];
    
    
    
    NSString *nowstr = [formatter stringFromDate:now];
    
    NSDate *nowDate = [formatter dateFromString:nowstr];
    
    
    
    NSTimeInterval start = [startDate timeIntervalSince1970]*1;
    
    NSTimeInterval end = [nowDate timeIntervalSince1970]*1;
    
    NSTimeInterval value = end - start;
    
    
    
    int second = (int)value %60;//秒
    
    int minute = (int)value /60%60;
    
    int house = (int)value / (24 * 3600)%3600;
    
    int day = (int)value / (24 * 3600);
    
    NSString *str;
    
    NSInteger time;//剩余时间为多少分钟
    
    if (day != 0) {
        
        str = [NSString stringWithFormat:@"耗时%d天%d小时%d分%d秒",day,house,minute,second];
        
        time = day;
        
    }else {
        time = 1;
    }
    
    return time;
    
}
- (void)configCustomSlider {
    UIImageView *sliderView = [[UIImageView alloc] init];
    [sliderView setImage:[UIImage imageNamed:@"矩形框"]];
    sliderView.contentMode = UIViewContentModeScaleAspectFit;
    [self.magicController.magicView setSliderView:sliderView];
    self.magicController.magicView.sliderHeight = 2.5f;
    self.magicController.magicView.sliderOffset = -2;
}
- (CGFloat)magicView:(VTMagicView *)magicView itemWidthAtIndex:(NSUInteger)itemIndex{
    
    return KScreenScaleRatioWidth(100);
}
- (VTMagicController *)magicController
{
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderColor = [UIColor whiteColor];
        _magicController.magicView.layoutStyle = VTLayoutStyleDefault;
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.navigationHeight = 46.f;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
//        
//        if (!_isSelf) {
//            //自己
//            _magicController.magicView.frame = CGRectMake(0, self.personInformationBgViewHigth.constant+self.higth, DeviceSize.width, DeviceSize.height- self.personInformationBgViewHigth.constant-49);
//        }else{
            _magicController.magicView.frame = CGRectMake(0, self.personInformationBgViewHigth.constant+self.higth, DeviceSize.width, DeviceSize.height- self.personInformationBgViewHigth.constant);
//        }
    }
    return _magicController;
}
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    return _menuList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [menuItem setTitleColor:APP_BLUE_COLOR forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    NSString  *menuInfo = _menuList[pageIndex];
    if ([menuInfo isEqualToString:@"视频"]) {
        return self.ProductViewController;
    }else if([menuInfo isEqualToString:@"文章"]){
        self.articleViewController.hostUrl=[NSString stringWithFormat:@"%@/#/myArticleList?userId=%@",App_JAIOXUYE_BASE_URL,self.userId];
        return self.articleViewController;
    } else if([menuInfo isEqualToString:@"收藏"]){
        self.collectViewController.hostUrl=[NSString stringWithFormat:@"%@/#/myCollection?userId=%@",App_JAIOXUYE_BASE_URL,self.userId];
        return self.collectViewController;
    } else if([menuInfo isEqualToString:@"错题本"]){
        self.bokokViewController.hostUrl=[NSString stringWithFormat:@"%@/#/myThemeTask?userId=%@&targetId=%@",App_JAIOXUYE_BASE_URL,self.userId,@"0"];
        return self.bokokViewController;
    }
    else if([menuInfo isEqualToString:@"主题任务"]){
        self.tasktViewController.hostUrl=[NSString stringWithFormat:@"%@/#/myThemeTask?userId=%@&targetId=%@",App_JAIOXUYE_BASE_URL,self.userId,@"1"];
        return self.tasktViewController;
    }
    else{
        return self.likeViewController;
    }
}
#pragma maek 设置
- (IBAction)userSetimgAction:(id)sender {
    
    FZBindingViewController *vc = [[FZBindingViewController alloc]init];
    vc.title=@"设置";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *aa = [def objectForKey:@"isIosCheckVersion"];
    if ([aa isEqualToString:@"1"]) {
    vc.dataArray = @[@"完善资料"];
    }else{
    vc.dataArray = @[@"完善资料",@"审核管理",@"会员充值",@"清除缓存"];
    }

    vc.type = 2;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma maek 扫一扫
- (IBAction)scanAction:(id)sender {
    
//    FZScanViewController *vc = [[FZScanViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    
    /**
     小视频
     */
    FZPersonalCenterViewController *vcc = [[FZPersonalCenterViewController alloc]init];
    [self.navigationController pushViewController:vcc animated:YES];
    
 

}

- (OwenProductViewController *) ProductViewController{
    if (!_ProductViewController) {
        _ProductViewController = [[OwenProductViewController alloc] init];
//           _ProductViewController.method = @"getUserCreateVideoList";
        if (self.isSelf) {
            _ProductViewController.method = @"getUserCreateVideoList";
            //是自己
            _ProductViewController.isContainsDraft = @"true";
        }else{
             _ProductViewController.method = @"getOtherUserCreateVideoList";
        }
        if ([self.userId isEqualToString:[FZUserInformation shareInstance].userModel.uid]) {
              _ProductViewController.method = @"getUserCreateVideoList";
            //是自己
            _ProductViewController.isContainsDraft = @"true";
        }else{
            _ProductViewController.method = @"getOtherUserCreateVideoList";
        }
    
        _ProductViewController.userId = self.userId;
        if ([self.userId isEqualToString:[FZUserInformation shareInstance].userModel.uid]) {
           
        }else{
//             _ProductViewController.isContainsDraft = @"false";
        }
    }
    return _ProductViewController;
}

- (OwenProductViewController *) collViewController{
    if (!_collViewController) {
        _collViewController = [[OwenProductViewController alloc] init];
        _collViewController.method = @"getAllLittleVideoList";
          _collViewController.userId = self.userId;
    }
    return _collViewController;
}
- (OwenProductViewController *) likeViewController{
    if (!_likeViewController) {
        _likeViewController = [[OwenProductViewController alloc] init];
        _likeViewController.method = @"getMyLikeVideos";
        _likeViewController.userId = self.userId;
    }
    return _likeViewController;
}
- (FZBaseWebViewController *) articleViewController{
    if (!_articleViewController) {
        _articleViewController = [[FZBaseWebViewController alloc] init];
        
    }
    return _articleViewController;
}
- (FZBaseWebViewController *)collectViewController {
    if (!_collectViewController) {
        _collectViewController = [[FZBaseWebViewController alloc] init];
//        _collectViewController.delegate = self;
    }
    return _collectViewController;
    
}
- (FZBaseWebViewController *)bokokViewController {
    if (!_bokokViewController) {
        _bokokViewController = [[FZBaseWebViewController alloc] init];
        //        _collectViewController.delegate = self;
    }
    return _bokokViewController;
    
}
- (FZBaseWebViewController *)tasktViewController {
    if (!_tasktViewController) {
        _tasktViewController = [[FZBaseWebViewController alloc] init];
        //        _collectViewController.delegate = self;
    }
    return _tasktViewController;
    
}
@end
