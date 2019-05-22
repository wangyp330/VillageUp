//
//  FZPersonalCenterViewController.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/9/10.
//  Copyright © 2018年 mac. All rights reserved.
//


static NSString *ident = @"cell";

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#define ZhuTiColor RGB(76,16,198)
#define ZhuTiColorAlpha(alpha) RGBA(76, 16, 198, alpha)
//#define imageHight 200
static CGFloat const headViewHeight = 240;
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
#import "FZPersonalCenterViewController.h"
#import <VTMagic.h>
#import "OwenProductViewController.h"
#import "FZBaseWebViewController.h"
#import "MainTouchTableTableView.h"
#import "WMPageController.h"
#import <Masonry.h>
#import "FZLookFansViewController.h"
#import "FZBindingViewController.h"
#import "FZScanViewController.h"
#import "UIView+ZFFrame.h"
#import "FZCollectionWebViewController.h"
@interface FZPersonalCenterViewController ()<VTMagicViewDelegate,VTMagicViewDataSource,UITableViewDelegate,UITableViewDataSource,WMPageControllerDelegate>{
        NSArray *_menuList;
        NSArray *_tripList;
}
@property (nonatomic,strong) UIImageView *headImage;
@property (nonatomic, strong) UIView *headerBackView;
@property (nonatomic, strong) UIView *mengView;
@property (nonatomic, strong) OwenProductViewController *ProductViewController;
@property (nonatomic, strong) OwenProductViewController *collViewController;
@property (nonatomic, strong) OwenProductViewController *likeViewController;
@property (nonatomic, strong) FZBaseWebViewController *articleViewController;
@property (nonatomic, strong) FZBaseWebViewController *collectViewController;
@property (nonatomic, strong) FZBaseWebViewController *bokokViewController;
@property (nonatomic, strong) FZBaseWebViewController *tasktViewController;
@property(nonatomic,strong)VTMagicController *magicController;

/*****************/
@property(nonatomic ,strong)MainTouchTableTableView * mainTableView;
@property(nonatomic,strong) UIScrollView * parentScrollView;

@property(nonatomic,strong)UIImageView *headImageView;//头部图片
@property(nonatomic,strong)UIImageView * avatarImage;//头像
@property(nonatomic,strong)UILabel *countentLabel;//名字
@property(nonatomic,strong)UILabel *IDLabel;//名字
@property(nonatomic,strong)UIImageView *vipImageView;//会员图标
@property(nonatomic,strong)UILabel *vipTimeLabel;//会员时间图标
@property(nonatomic,strong)UIButton *attendButton;//关注
@property(nonatomic,strong)UIButton *scanButton;//关注
@property(nonatomic,strong)UIButton *setButton;//关注
/*
 * canScroll= yes : mainTableView 视图可以滚动，parentScrollView 禁止滚动
 */
@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, assign) BOOL isTopIsCanNotMoveMainTableView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveParentScrollView;
/*****************/



@end

@implementation FZPersonalCenterViewController
{
    UIButton *backButton;
    FZUserModel *cUserModel;
}
@synthesize mainTableView;
#pragma mark - 自定义backbutto
-(void)cusBackBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
//初始化数据
-(void)initData{
    
    if (self.userId && self.userId.length > 0) {
        self.userId = self.userId;
        backButton.hidden = NO;
        
        _magicController.magicView.height = Main_Screen_Height;
    }else{
        self.userId  = [FZUserInformation shareInstance].userModel.uid;
        backButton.hidden = YES;
        _magicController.magicView.height = Main_Screen_Height-46;
    }

    //[self reequetPersonInformation:self.userId];
    [self getDynamicUserInfo:self.userId];
}
-(void)getDynamicUserInfo:(NSString *)userID{
    
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *aa = [def objectForKey:@"isIosCheckVersion"];
    if ([aa isEqualToString:@"1"]) {
        self.vipImageView.hidden = YES;
        self.vipTimeLabel.hidden = YES;
    }else{
        self.vipImageView.hidden = NO;
        self.vipTimeLabel.hidden = NO;
    }
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
        [parm setObject:userID forKey:@"userId"];
    [FZNetworkingManager requestLittleAntMethod:@"getDynamicUserInfo" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        
        if (success == YES) {
            UIButton *btn0 = (UIButton *)[self.view viewWithTag:200];
            UIButton *btn1 = (UIButton *)[self.view viewWithTag:201];
            UIButton *btn2 = (UIButton *)[self.view viewWithTag:202];
            UIButton *btn3 = (UIButton *)[self.view viewWithTag:203];
            [btn1 setTitle:[NSString stringWithFormat:@"粉丝\n%@",[[response objectForKey:@"response"] objectForKey:@"fansCount"]] forState:UIControlStateNormal];
            [btn0 setTitle:[NSString stringWithFormat:@"关注\n%@",[[response objectForKey:@"response"] objectForKey:@"followCount"]] forState:UIControlStateNormal];
            [btn2 setTitle:[NSString stringWithFormat:@"喜欢\n%@",[[response objectForKey:@"response"] objectForKey:@"likeCount"]] forState:UIControlStateNormal];
            [btn3 setTitle:[NSString stringWithFormat:@"收藏\n%@",[[response objectForKey:@"response"] objectForKey:@"collectionCount"]] forState:UIControlStateNormal];
        }
    }];
    
    NSMutableDictionary *parm1 = [[NSMutableDictionary alloc]init];
    [parm1 setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
    [parm1 setObject:userID forKey:@"followTargetId"];
    [parm1 setObject:@"0" forKey:@"followType"];
    
    NSString *JsonParameter1 = [FZParmTODicString convertToJsonData:parm1];
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]init];
    [dic1 setObject:JsonParameter1 forKey:@"JsonParameter"];
    [FZNetworkingManager requestLittleAntMethod:@"getUserLikeLog" parameters:dic1 requestHandler:^(BOOL success, id  _Nullable response) {
        NSLog(@"haha");
        if (success == YES) {
            NSData *jsonData =[ [response objectForKey:@"response"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            
            if ([[dic objectForKey:@"isFollow"] integerValue] == 1) {
                //                self.attentionBtn.backgroundColor = [UIColor clearColor];
                [self.attendButton setTitle:@"已关注" forState:(UIControlStateNormal)];
                [self.attendButton setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
            }else{
                //                self.attentionBtn.backgroundColor = APP_BLUE_COLOR;
                [self.attendButton setTitle:@"关注" forState:(UIControlStateNormal)];
                [self.attendButton setImage:[UIImage imageNamed:@"＋_act"] forState:(UIControlStateNormal)];
            }
        }
        
    }];
    
}
-(void)attendButtonActionOnClick{
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
                        [self.attendButton setTitle:@"关注" forState:(UIControlStateNormal)];
                        [self.attendButton setImage:[UIImage imageNamed:@"＋_act"] forState:(UIControlStateNormal)];
                    }else{
                        [self.attendButton setTitle:@"已关注" forState:(UIControlStateNormal)];
                        [self.attendButton setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
                    }
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"guanzhuchenggong" object:nil];
            }];
            
        }
        
    }];
    
    

    
}
-(void)buttonOnClick:(UIButton *)sender{
    if (!self.userId) {
        self.userId=[FZUserInformation shareInstance].userModel.uid;
    }
    if (sender.tag == 200) {
        FZLookFansViewController *vc = [[FZLookFansViewController alloc]init];
        vc.userId = self.userId;
        vc.type = 1;
        vc.title = @"关注";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 201){
        //粉丝
        FZLookFansViewController *vc = [[FZLookFansViewController alloc]init];
        vc.userId = self.userId;
        vc.type = 0;
        vc.title = @"粉丝";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 202){
        OwenProductViewController *vc = [[OwenProductViewController alloc]init];
        vc.number = 46;
        vc.method = @"getMyLikeVideos";
        vc.userId = self.userId;
        vc.view.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
         vc.title = @"喜欢的";
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (sender.tag == 203){
        FZBaseWebViewController *vc = [[FZBaseWebViewController alloc]init];
        vc.hostUrl=[NSString stringWithFormat:@"%@/#/myCollection?userId=%@&villageId=%@&groupId=%@",PhoneWebIP,self.userId,cUserModel.villageId,cUserModel.groupId];
        vc.title = @"收藏的";
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)reequetPersonInformation:(NSString *)userID{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:userID forKey:@"uid"];
    [FZNetworkingManager requestLittleAntMethod:@"getLittleVideoUserById" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        NSLog(@"");
        if (success == YES) {
            NSString *iud = [FZUserInformation shareInstance].userModel.uid;
            if ([self.userId isEqualToString:iud]) {
                NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
                [userDef setObject:[response objectForKey:@"response"] forKey:@"userInfo"];
            }
            FZUserModel *model = [[FZUserModel alloc]initWithDictionary:[response objectForKey:@"response"] error:nil];
            [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"defaultHeader"]];
            self.countentLabel.text = model.userName;
            self.IDLabel.text = [NSString stringWithFormat:@"ID:%@",model.uid];
            self->cUserModel=model;
        }
    }];
}
//请求视频数据
- (void)viewDidLoad {
    [super viewDidLoad];

     _menuList = @[@"作品",@"村貌"];
    _tripList = @[@"关注",@"粉丝",@"喜欢",@"收藏"];
      [self configCustomSlider];
    
    [self.view addSubview:self.mainTableView];
    
    [self.mainTableView addSubview:self.headImageView];
    [self confiUI];
    [self initData];
    //支持下刷新。关闭弹簧效果
    self.mainTableView.bounces =  NO;
    //
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.canScroll = YES;
    [_magicController.magicView reloadData];

    if ([self.userId isEqualToString:[FZUserInformation shareInstance].userModel.uid]) {
        self.attendButton.hidden = YES;
        
    }else{
        self.attendButton.hidden = NO;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataInfo) name:@"updataUserInfo" object:nil];

}

-(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    if (!self.userId) {
        self.userId=[FZUserInformation shareInstance].userModel.uid;
    }

    if (self.userId.length > 0) {
        [self getDynamicUserInfo:self.userId];
        [self reequetPersonInformation:self.userId];
    }
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark --tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Main_Screen_Height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
      [self addChildViewController:self.magicController];
    [cell.contentView addSubview:_magicController.view];
    return cell;
}
-(UIView *)setPageViewControllers
{
    WMPageController *pageController = [self p_defaultController];
    pageController.title = @"Line";
    pageController.menuViewStyle = WMMenuViewStyleLine;
    pageController.titleSizeSelected = 15;
    
    [self addChildViewController:pageController];
    [pageController didMoveToParentViewController:self];
    return pageController.view;
}

- (WMPageController *)p_defaultController {
    
    NSArray *viewControllers = @[self.ProductViewController,self.articleViewController,self.bokokViewController,self.tasktViewController];
    
    NSArray *titles = @[@"first",@"second",@"third",@"third"];
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    [pageVC setViewFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    pageVC.delegate = self;
    pageVC.menuItemWidth = 85;
    pageVC.menuHeight = 44;
    pageVC.postNotification = YES;
    pageVC.bounces = YES;
    return pageVC;
}
#pragma mark -- setter/getter
-(UIImageView *)headImageView
{
    if (_headImageView == nil)
    {
        _headImageView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"背景"]];
        _headImageView.frame=CGRectMake(0, -headViewHeight ,Main_Screen_Width,headViewHeight);
        _headImageView.backgroundColor = APP_BLUE_COLOR;
        _headImageView.userInteractionEnabled = YES;
        
        _avatarImage = [[UIImageView alloc] init];
        [_headImageView addSubview:_avatarImage];
        _avatarImage.userInteractionEnabled = YES;
        _avatarImage.layer.masksToBounds = YES;
        _avatarImage.layer.cornerRadius = 40;
        _avatarImage.layer.borderWidth = 1;
        _avatarImage.layer.borderColor =[[UIColor colorWithRed:255/255. green:253/255. blue:253/255. alpha:1.] CGColor];
        _avatarImage.image = [UIImage imageNamed:@"defaultHeader"];

        
        
        _countentLabel = [[UILabel alloc] init];
        _countentLabel.font = [UIFont systemFontOfSize:14];
        _countentLabel.textColor = [UIColor colorWithRed:255/255. green:255/255. blue:255/255. alpha:1.];
        _countentLabel.textAlignment = NSTextAlignmentCenter;
        _countentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_countentLabel setAdjustsFontSizeToFitWidth:YES];
        _countentLabel.numberOfLines = 0;
        _countentLabel.text = @"我的名字叫Anna";
        [_headImageView addSubview:_countentLabel];
        
        _attendButton = [[UIButton alloc]init];
        _attendButton.backgroundColor = [UIColor redColor];
        _attendButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _attendButton.layer.masksToBounds = YES;
        _attendButton.layer.cornerRadius = 2;
        [_attendButton addTarget:self action:@selector(attendButtonActionOnClick) forControlEvents:(UIControlEventTouchDown)];
        [_headImageView addSubview:_attendButton];
        [self.attendButton setImageEdgeInsets:UIEdgeInsetsMake(0, 1, 0, 0)];
        [self.attendButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -1)];
        self.attendButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        
        
        
        _IDLabel = [[UILabel alloc] init];
        _IDLabel.font = [UIFont systemFontOfSize:12.];
        _IDLabel.textColor = [UIColor colorWithRed:255/255. green:255/255. blue:255/255. alpha:1.];
        _IDLabel.textAlignment = NSTextAlignmentCenter;
        _IDLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_IDLabel setAdjustsFontSizeToFitWidth:YES];
        _IDLabel.numberOfLines = 0;
        _IDLabel.text = @"ID:33";
        [_headImageView addSubview:_IDLabel];
        
        _setButton = [[UIButton alloc]init];
        [_setButton setBackgroundImage:[UIImage imageNamed:@"setting_icon"] forState:(UIControlStateNormal)];
        [_setButton addTarget:self action:@selector(setActionOnClick) forControlEvents:(UIControlEventTouchDown)];
        [_headImageView addSubview:_setButton];
        
        _scanButton = [[UIButton alloc]init];
        [_scanButton setBackgroundImage:[UIImage imageNamed:@"scan_icon"] forState:(UIControlStateNormal)];
        [_scanButton addTarget:self action:@selector(scanButtonActionOnClick) forControlEvents:(UIControlEventTouchDown)];
        [_headImageView addSubview:_scanButton];
        
        
        backButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(cusBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.headImageView addSubview:backButton];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImageView.mas_top).mas_offset(30);
            make.size.mas_offset(CGSizeMake(30, 30));
            make.left.mas_equalTo(10);
        }];
        
    }
    return _headImageView;
}
-(void)setActionOnClick{
    FZBindingViewController *vc = [[FZBindingViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)scanButtonActionOnClick{
        FZScanViewController *vc = [[FZScanViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
}

-(void)confiUI{
    
    [_avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImageView.mas_top).mas_offset(30);
        make.size.mas_offset(CGSizeMake(80, 80));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    [_vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.avatarImage.mas_bottom).mas_offset(5);
        make.size.mas_offset(CGSizeMake(30, 30));
        make.right.mas_equalTo(self.avatarImage);
    }];
    [_vipTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.vipImageView.mas_right).mas_offset(-10);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.vipImageView.mas_centerY);
    }];
    
    [_countentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarImage.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [_attendButton mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.mas_equalTo(self.countentLabel.mas_right).mas_offset(10);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.countentLabel.mas_centerY);
    }];
    
    [_IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.countentLabel.mas_bottom).mas_offset(0);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [_setButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImageView.mas_top).mas_offset(30);
        make.size.mas_offset(CGSizeMake(30, 30));
        make.right.mas_equalTo(self.headImageView.mas_right).mas_offset(-10);;
    }];
    _scanButton.hidden=YES;
    
    if (![self.userId isEqualToString:[FZUserInformation shareInstance].userModel.uid]) {
        _setButton.hidden=YES;
    }
    if (!self.userId) {
        _setButton.hidden=NO;
    }
    
    [_scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImageView.mas_top).mas_offset(30);
        make.size.mas_offset(CGSizeMake(30, 30));
        make.right.mas_equalTo(self.setButton.mas_left).mas_offset(-10);;
    }];
    
    
    
    
    //首先添加4个视图
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 0; i < _tripList.count; i ++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font=[UIFont systemFontOfSize:16];
        button.titleLabel.textAlignment=NSTextAlignmentCenter;
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button.tag = 200+i;
        [button setTitle:[NSString stringWithFormat:@"%@\n%@",_tripList[i],@"5"] forState:(UIControlStateNormal)];
        [self.headImageView addSubview:button];
        [button addTarget:self action:@selector(buttonOnClick:) forControlEvents:(UIControlEventTouchDown)];
        [array addObject:button]; //保存添加的控件
    }
    
    //水平方向控件间隔固定等间隔
  [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:50 leadSpacing:60 tailSpacing:60];    // 设置array的垂直方向的约束
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.IDLabel.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(50);
    }];
}

-(MainTouchTableTableView *)mainTableView
{
    if (mainTableView == nil)
    {
        mainTableView= [[MainTouchTableTableView alloc]initWithFrame:CGRectMake(0,0,Main_Screen_Width,Main_Screen_Height)];
        mainTableView.delegate=self;
        mainTableView.dataSource=self;
        mainTableView.showsVerticalScrollIndicator = NO;
        mainTableView.contentInset = UIEdgeInsetsMake(headViewHeight,0, 0, 0);
        mainTableView.backgroundColor = [UIColor clearColor];
    }
    return mainTableView;
}

//
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
        _magicController.magicView.layoutStyle = VTLayoutStyleDivide;
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.navigationHeight = 46.f;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-46 );
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
    if ([menuInfo isEqualToString:@"作品"]) {
        return self.ProductViewController;
    }else {
        //村貌
        self.articleViewController.hostUrl=[NSString stringWithFormat:@"%@/#/myArticleList?userId=%@&villageId=%@&groupId=%@",PhoneWebIP,[FZUserInformation shareInstance].userModel.uid,[FZUserInformation shareInstance].userModel.villageId,[FZUserInformation shareInstance].userModel.groupId];
        return self.articleViewController;
    }
}
#pragma mark 懒加载
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
//        _ProductViewController.DDelegate = self;
    }
    return _ProductViewController;
}

- (OwenProductViewController *) collViewController{
    if (!_collViewController) {
        _collViewController = [[OwenProductViewController alloc] init];
//            _collViewController.DDelegate = self;
    }
    return _collViewController;
}
- (OwenProductViewController *) likeViewController{
    if (!_likeViewController) {
        _likeViewController = [[OwenProductViewController alloc] init];
//           _likeViewController.DDelegate = self;
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
//          _collectViewController.DDelegate = self;
    }
    return _collectViewController;

}
- (FZBaseWebViewController *)bokokViewController {
    if (!_bokokViewController) {
        _bokokViewController = [[FZBaseWebViewController alloc] init];
//        _bokokViewController.DDelegate = self;
    }
    return _bokokViewController;

}
- (FZBaseWebViewController *)tasktViewController {
    if (!_tasktViewController) {
        _tasktViewController = [[FZBaseWebViewController alloc] init];
//        _tasktViewController.DDelegate = self;
    }
    return _tasktViewController;

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


-(void)userInfoById:(NSString *)userId{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"uid"];
    [FZNetworkingManager requestLittleAntMethod:@"getLittleVideoUserById" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        NSLog(@"");
        if (success == YES) {
            NSDictionary *userInfoDic=[response objectForKey:@"response"];
            self->cUserModel=[[FZUserModel alloc]initWithDictionary:userInfoDic error:nil];
        }else{
            
        }
    }];
}
@end
