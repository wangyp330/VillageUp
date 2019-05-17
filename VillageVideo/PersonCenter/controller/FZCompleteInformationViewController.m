//
//  FZCompleteInformationViewController.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/16.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZCompleteInformationViewController.h"
#import <Masonry.h>
#import <YYWebImage.h>
#import "BindingTableViewCell.h"
#import "BiningTableviewViewController.h"
#import "ShortVideoModel.h"
#import "FZParmTODicString.h"
#import "FZPhoneNumberTableViewCell.h"
#import "FZBindingPhnumberViewController.h"
#import "FZImagePicker.h"
@interface FZCompleteInformationViewController ()<UITableViewDelegate,UITableViewDataSource,FZPhoneNumberTableViewCellDelegaet>
@property(nonatomic,strong)UIImageView *imageHeadimage;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)NSMutableDictionary *dataParm;
@end

@implementation FZCompleteInformationViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableview reloadData];
}
-(NSMutableDictionary *)dataParm{
    if (!_dataParm) {
        _dataParm = [[NSMutableDictionary alloc]init];
    }
    return _dataParm;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完善资料";
    _dataArray = @[@"用户头像",@"用户名称",@"所属村子",@"所属小组",@"手机号"];
    self.view.backgroundColor = APP_Gray_COLOR;
    [self configUI];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSString *keyString=self.dataArray[indexPath.row];
        if ([keyString isEqualToString:@"所属村子"]) {
        
        }
        if ([keyString isEqualToString:@"所属小组"]) {
            BiningTableviewViewController *vc = [[BiningTableviewViewController alloc]init];
            vc.title =@"组列表";
            vc.selectBlock = ^(id model) {
                GroupModel *gModel=model;
                NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                [dic setObject:gModel.id forKey:@"groupId"];
                [self alertUserInfoWithData:dic];
            };
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    if ([keyString isEqualToString:@"手机号"]){
        FZBindingPhnumberViewController *vc = [[FZBindingPhnumberViewController alloc]init];
        vc.title = @"绑定手机号";
        vc.view.backgroundColor = APP_Gray_COLOR;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([keyString isEqualToString:@"用户头像"]) {
        [self alterUserAvatar];
    }
    
    if ([keyString isEqualToString:@"用户名称"]) {
        [self alterUserName];
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0 || indexPath.row == 1) {
        BindingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BindingTableViewCell"];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"BindingTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
        cell.textLabel.text = self.dataArray[indexPath.row];
        if (indexPath.row == 0) {
            NSString *urls=[FZUserInformation shareInstance].userModel.avatar;
            UIImageView *headerImg=[[UIImageView alloc]init];
            [headerImg sd_setImageWithURL:[NSURL URLWithString:urls] placeholderImage:[UIImage imageNamed:@"defaultHeader"]];
            [cell addSubview:headerImg];
            headerImg.frame=CGRectMake(SCREEN_WIDTH-110, 5, 40, 40);
            headerImg.layer.masksToBounds=YES;
            headerImg.layer.cornerRadius=20;
        }
        if (indexPath.row == 1) {
            cell.textFiled.text=[FZUserInformation shareInstance].userModel.userName;
        }
        if (indexPath.row == 2) {
            UILabel *lab=[[UILabel alloc]init];
            lab.textColor=cell.textFiled.textColor;
            lab.font=cell.textFiled.font;
            [cell addSubview:lab];
            lab.frame=CGRectMake(200, 0, SCREEN_WIDTH-270, 55);
            lab.textAlignment=NSTextAlignmentRight;
            lab.text=[FZUserInformation shareInstance].userModel.villageName;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    if (indexPath.row == 3) {
        cell.textFiled.text = [FZUserInformation shareInstance].userModel.groupName;
    }
    if (indexPath.row == 4) {
        if ([FZUserInformation shareInstance].userModel.phoneNumber.length > 0) {
            cell.textFiled.text = [FZUserInformation shareInstance].userModel.phoneNumber;
        }else{
            cell.textFiled.placeholder = @"点击绑定手机号";
        }
    }
        if (indexPath.row == self.dataArray.count -1) {
            
        }else{
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 54, SCREEN_WIDTH-10, 0.5)];
            view.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
            [cell addSubview:view];
        }
        return cell;
}
#pragma mark -  去跟拍
- (void)clickjiebanAction:(UIButton *)btn withCell:(FZPhoneNumberTableViewCell *)cell{
    NSLog(@"%s",__func__);
    
}

-(void)configUI{
    _tableview = [[UITableView alloc] init];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.scrollEnabled = NO;
    _tableview.backgroundColor = APP_Gray_COLOR;
    _tableview.scrollEnabled = NO;
    _tableview.tableFooterView = [UIView new];
     _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(20);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-30, 300));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
}

#pragma mark - 修改头像
-(void)alterUserAvatar{
    FZImagePicker *picker=[[FZImagePicker alloc]initWithMaxCount:1];
    [picker setSelectedImages:^(NSArray *images) {
        NSData *imgdata = UIImageJPEGRepresentation(images.firstObject, 0.5);
        [[FZNetworkingManager sharedUtil] uploadImageFiles:[NSArray arrayWithObjects:imgdata, nil] complete:^(BOOL success, NSString *fileURLString, NSError *error) {
            NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
            [dic setObject:fileURLString forKey:@"avatar"];
            [self alertUserInfoWithData:dic];
        }];
    }];
    [picker showInController:self];
}

-(void)alterUserName{
    UIAlertController *alertC=[UIAlertController alertControllerWithTitle:@"修改名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=[FZUserInformation shareInstance].userModel.userName;
    }];
    UITextField *userNameTextF=[[UITextField alloc]init];
    userNameTextF=alertC.textFields[0];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (userNameTextF.text.length > 0) {
            NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
            [dic setObject:userNameTextF.text forKey:@"userName"];
            [self alertUserInfoWithData:dic];
        }
    }];
    [alertC addAction:cancelAction];
    [alertC addAction:okAction];
    [self presentViewController:alertC animated:YES completion:nil];
}


-(void)alertUserInfoWithData:(NSDictionary *)data{
    NSMutableDictionary *parm=[[NSMutableDictionary alloc]init];
    [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
    NSString *json = [FZParmTODicString convertToJsonData:data];
    [parm setObject:json forKey:@"userDatas"];
    [FZNetworkingManager requestLittleAntMethod:@"updateLittleVideoUser" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        if (success == YES) {
            [[NSNotificationCenter defaultCenter]  postNotificationName:@"FZCompleteInformationViewController" object:nil];
            [MBProgressHUD showSuccess:@"修改成功" toView:self.view];
            [self upDataInfo];
        }else{
            
        }
    }];
}


-(void)upDataInfo{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"uid"];
    [FZNetworkingManager requestLittleAntMethod:@"getLittleVideoUserById" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        NSLog(@"");
        if (success == YES) {
            NSDictionary *userInfoDic=[response objectForKey:@"response"];
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            [userDef setObject:userInfoDic forKey:@"userInfo"];
            [userDef synchronize];
            [self.tableview reloadData];
        }
    }];
}

@end
