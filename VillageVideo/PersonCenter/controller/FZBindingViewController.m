//
//  FZBindingViewController.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZBindingViewController.h"
#import "BindingTableViewCell.h"
#import "BiningTableviewViewController.h"
#import "ShortVideoModel.h"
#import "FZWebViewController.h"
#import "FZBaseWebViewController.h"
#import "FZCompleteInformationViewController.h"
#import <TZImagePickerController.h>
#import "FZClearCacheTool.h"
#import "DHGuidePageHUD.h"
#import <KTVHTTPCache.h>
#import <Masonry.h>

@interface FZBindingViewController ()<UITableViewDelegate,UITableViewDataSource,FZWebViewControllerDelegate,TZImagePickerControllerDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UIButton *quitBtn;//退出登录
@end

@implementation FZBindingViewController
-(UIButton *)quitBtn{
    if (!_quitBtn) {
        _quitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 314-60, SCREEN_WIDTH, 45)];
        _quitBtn.backgroundColor = [UIColor whiteColor];
        _quitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_quitBtn setTitle:@"退出登录" forState:(UIControlStateNormal)];
        [_quitBtn setTitleColor:APP_BLUE_COLOR forState:(UIControlStateNormal)];
        [_quitBtn addTarget:self action:@selector(quitAcountAction) forControlEvents:(UIControlEventTouchDown)];
    }
    return _quitBtn;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self shuaxin];
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[[UIColor whiteColor] colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
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
#pragma mark 退出登录
-(void)quitAcountAction{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef removeObjectForKey:@"userInfo"];
    [userDef setObject:@"0" forKey:@"UserState"];
    [userDef removeObjectForKey:@"city"];
     [userDef removeObjectForKey:@"isIosCheckVersion"];
    [userDef synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUserQuitCount object:nil];
    NSString *a =[NSString stringWithFormat:@"%d",2];
    NSUSERSET(a, BOOLFORKEY);
}
-(void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设置";
    self.dataArray = [[NSMutableArray alloc]initWithObjects:@"完善资料",@"清除缓存",@"版本号", nil];
    self.view.backgroundColor = APP_Gray_COLOR;
    [self.view addSubview:self.tableview];
    // 去掉多余的cell
    self.tableview.tableFooterView = [UIView new];
    [_tableview registerNib:[UINib nibWithNibName:@"BindingTableViewCell" bundle:nil] forCellReuseIdentifier:@"BindingTableViewCell"];
    [self.view addSubview:self.quitBtn];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shuaxin) name:@"FZCompleteInformationViewController" object:nil];
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
                [self.tableview reloadData];
            }
        }];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *keyString=self.dataArray[indexPath.row];
    if ([keyString isEqualToString:@"完善资料"]){
        FZCompleteInformationViewController *vc = [[FZCompleteInformationViewController alloc]init];
        vc.title = @"完善资料";
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([keyString isEqualToString:@"审核管理"]) {
        FZBaseWebViewController *vc = [[FZBaseWebViewController alloc]init];
        vc.title = @"审核管理";
        vc.delegate = self;
        vc.hostUrl = [NSString stringWithFormat:@"%@/#/powerList?ident=%@",App_JAIOXUYE_BASE_URL,[FZUserInformation shareInstance].userModel.uid];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([keyString isEqualToString:@"清除缓存"]) {
        [SVProgressHUD showGif];
        BindingTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        
          [KTVHTTPCache cacheDeleteAllCaches];
        cell.textFiled.text = @"0.0KB   ";
        [SVProgressHUD hidGif];
    }
   
    
}
-(void)fzwebViewControllCallHandlerWithMethod:(NSString *)method data:(NSDictionary *)data{
  
    if ([method isEqualToString:@"selectImages"]) {
        //        //分享
      
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BindingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BindingTableViewCell"];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"BindingTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    if ([cell.textLabel.text isEqualToString:@"会员充值"] ||[cell.textLabel.text isEqualToString:@"完善资料"] ||[cell.textLabel.text isEqualToString:@"审核管理"]) {
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textFiled.text = @"";
         cell.textFiled.textColor =[UIColor colorWithHexString:@"666666"];
        if ([cell.textLabel.text isEqualToString:@"完善资料"] ) {
            if ([FZUserInformation shareInstance].userModel.schoolName.length > 0 && [FZUserInformation shareInstance].userModel.groupName.length > 0) {
                       cell.textFiled.text = [NSString stringWithFormat:@"%@%@",[FZUserInformation shareInstance].userModel.schoolName,[FZUserInformation shareInstance].userModel.groupName];
            }else if ([FZUserInformation shareInstance].userModel.schoolName.length > 0 && [FZUserInformation shareInstance].userModel.groupName.length == 0){
                 cell.textFiled.text = [NSString stringWithFormat:@"%@",[FZUserInformation shareInstance].userModel.schoolName];
            }else{
             cell.textFiled.text = @"";
            }

            cell.textFiled.textColor = [UIColor colorWithHexString:@"333333"];
        }

    }
    if ([cell.textLabel.text isEqualToString:@"清除缓存"]) {
        cell.textFiled.textColor =[UIColor colorWithHexString:@"666666"];
         cell.accessoryType = UITableViewCellAccessoryNone;
      NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        cell.textFiled.text = [FZClearCacheTool getCacheSizeWithFilePath:docDir];
    }
    
    if ([cell.textLabel.text isEqualToString:@"版本号"]) {
        cell.textFiled.textColor =[UIColor colorWithHexString:@"666666"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        //版本号
        NSDictionary *binfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *versionNumString = [binfoDictionary objectForKey:@"CFBundleShortVersionString"];
        cell.textFiled.text = versionNumString;
    }
    
    if (indexPath.row == self.dataArray.count -1) {
        
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 54, SCREEN_WIDTH-10, 0.5)];
        view.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
        [cell addSubview:view];
    }

    return cell;
}
- (UITableView *)tableview {
    if (_tableview == nil) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 14, SCREEN_WIDTH, 165)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.scrollEnabled = NO;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableview;
}


@end
