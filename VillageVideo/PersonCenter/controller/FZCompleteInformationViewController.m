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
@interface FZCompleteInformationViewController ()<UITableViewDelegate,UITableViewDataSource,FZPhoneNumberTableViewCellDelegaet>
@property(nonatomic,strong)UIImageView *imageHeadimage;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UIButton *completeBtn;
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
-(void)completeAction:(UIButton *)sender{
    
    
    FZPhoneNumberTableViewCell *cellnumber = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    FZPhoneNumberTableViewCell *numberCode = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    if([[self.dataParm allKeys] containsObject:@"schoolId"])
        
    {
         [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
        NSString *json = [FZParmTODicString convertToJsonData:self.dataParm];
        [parm setObject:json forKey:@"userDatas"];
        [FZNetworkingManager requestLittleAntMethod:@"updateLittleVideoUser" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
            if (success == YES) {
                [self.navigationController popViewControllerAnimated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter]  postNotificationName:@"FZCompleteInformationViewController" object:nil];
            }
        }];
    
    }else if([FZUserInformation shareInstance].userModel.schoolName.length > 0 ) {
      
        [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
        NSString *json = [FZParmTODicString convertToJsonData:self.dataParm];
        [parm setObject:json forKey:@"userDatas"];
        [FZNetworkingManager requestLittleAntMethod:@"updateLittleVideoUser" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
            if (success == YES) {
                [self.navigationController popViewControllerAnimated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter]  postNotificationName:@"FZCompleteInformationViewController" object:nil];
            }
        }];
    }else if (cellnumber.phumberTextFiled.text.length > 0 &&numberCode.phumberTextFiled.text.length > 0 ){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:cellnumber.phumberTextFiled.text forKey:@"phoneNumber"];
         [dic setValue:numberCode.phumberTextFiled.text forKey:@"verifyCode"];
        [FZNetworkingManager requestLittleAntMethod:@"validLittleVideoUserPhoneNumber" parameters:dic requestHandler:^(BOOL success, id  _Nullable response) {
            if (success == 1) {
                [self.dataParm setObject:cellnumber.phumberTextFiled.text forKey:@"phoneNumber"];
                [self.dataParm setObject:numberCode.phumberTextFiled.text forKey:@"verifyCode"];
                NSMutableDictionary *dicc = [[NSMutableDictionary alloc]init];
                [self.dataParm setValue:@"" forKey:@"phoneNumber"];
                [dicc setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
                NSString *json = [FZParmTODicString convertToJsonData:self.dataParm];
                [dicc setObject:json forKey:@"userDatas"];
                [FZNetworkingManager requestLittleAntMethod:@"updateLittleVideoUser" parameters:dicc requestHandler:^(BOOL success, id  _Nullable response) {
                    if (success == YES) {
                        [self.navigationController popViewControllerAnimated:YES];
                        [self dismissViewControllerAnimated:YES completion:nil];
                        [[NSNotificationCenter defaultCenter]  postNotificationName:@"FZCompleteInformationViewController" object:nil];
                    }
                }];
                
            }else{
                [MBProgressHUD showError:@"短信验证码错误" toView:self.view];
            }
            
        }];

        
    }else {
          [MBProgressHUD showError:@"请选择学校" toView:self.view];
    }
    

    if (cellnumber.phumberTextFiled.text.length > 0) {
        if (numberCode.phumberTextFiled.text.length > 0) {
       
        }
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
      self.title = @"完善资料";
//    if ([FZUserInformation shareInstance].userModel.phoneNumber.length > 0) {
//           _dataArray = @[@"所属学校",@"所属班级",@"手机号"];
//    }else{
            _dataArray = @[@"所属学校",@"所属班级",@"手机号"];
//         cell.jiebanBtnWidth.constant = 0;
//    }
// _dataArray = @[@"所属学校",@"所属班级"];
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
        if ([keyString isEqualToString:@"所属学校"]) {
            BiningTableviewViewController *vc = [[BiningTableviewViewController alloc]init];
            vc.title =keyString;
            BindingTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            vc.method = @"getSchoolInfoList";
            vc.selectBlock = ^(id model) {
                SchoolInfo *m = model;
                cell.textFiled.text =m.schoolName;
                [self.dataParm setObject:m.schoolId forKey:@"schoolId"];
            };
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([keyString isEqualToString:@"所属班级"]) {
            BiningTableviewViewController *vc = [[BiningTableviewViewController alloc]init];
             vc.title =keyString;
            BindingTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            vc.method = @"getGradeInfoList";
            vc.selectBlock = ^(id model) {
                GradeInfo *m = model;
                cell.textFiled.text =m.gradeName;
                  [self.dataParm setObject:m.gradeId forKey:@"gradeId"];
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
            
            cell.textFiled.text = [FZUserInformation shareInstance].userModel.schoolName;
        }
        if (indexPath.row == 1) {
            
            cell.textFiled.text = [FZUserInformation shareInstance].userModel.gradeName;
        }
    if (indexPath.row == 2) {
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
//    }else{
//        FZPhoneNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FZPhoneNumberTableViewCell"];
//        if (cell == nil) {
//            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"FZPhoneNumberTableViewCell" owner:nil options:nil];
//            cell = [nibs lastObject];
//        }
//        cell.delegate = self;
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        cell.textLabel.font = [UIFont systemFontOfSize:15];
//        cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
//        cell.textLabel.text = self.dataArray[indexPath.row];
//        if (indexPath.row == 2) {
//
//            cell.phumberTextFiled.text = [FZUserInformation shareInstance].userModel.phoneNumber;
//            if (cell.phumberTextFiled.text.length == 0) {
//                cell.jiebanBtnWidth.constant = 0;
//            }
//        }
//        if (indexPath.row == 3) {
//            [cell.jiebangBtn setTitle:@"发送短信验证码" forState:(UIControlStateNormal)];
//             cell.jiebanBtnWidth.constant = 150;
//            cell.phumberTextFiled.placeholder = @"请输入验证码";
//        }
//        if (indexPath.row == self.dataArray.count -1) {
//
//        }else{
//            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 54, SCREEN_WIDTH-10, 0.5)];
//            view.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
//            [cell addSubview:view];
//        }
//        return cell;
//    }
//
//    return  nil;
}
#pragma mark -  去跟拍
- (void)clickjiebanAction:(UIButton *)btn withCell:(FZPhoneNumberTableViewCell *)cell{
    NSLog(@"%s",__func__);
//    FZPhoneNumberTableViewCell *cellnumber = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:cellnumber.phumberTextFiled.text forKey:@"phoneNumber"];
//    if ([btn.currentTitle isEqualToString:@"发送短信验证码"]) {
//        [FZNetworkingManager requestLittleAntMethod:@"getVerifyCodeForLittleVideoBinded" parameters:dic requestHandler:^(BOOL success, id  _Nullable response) {
//            NSLog(@"");
//            if (success == 1) {
//                [MBProgressHUD showSuccess:@"短信验证码发送成功" toView:self.view];
//
//            }
//        }];
//
//    }
//
//    if ([btn.currentTitle isEqualToString:@"解绑"]) {
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//        [self.dataParm setValue:@"" forKey:@"phoneNumber"];
//        [dic setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
//        NSString *json = [FZParmTODicString convertToJsonData:self.dataParm];
//        [dic setObject:json forKey:@"userDatas"];
//        [FZNetworkingManager requestLittleAntMethod:@"updateLittleVideoUser" parameters:dic requestHandler:^(BOOL success, id  _Nullable response) {
//            if (success == YES) {
//                  FZPhoneNumberTableViewCell *cellnumber = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//                cellnumber.phumberTextFiled.text = nil;
//                self->_dataArray = @[@"所属学校",@"所属班级",@"手机号",@"获取验证码"];
//                [self.tableview reloadData];
//            }
//        }];
//
//
//    }
    
//    FZBindingPhnumberViewController *vc = [[FZBindingPhnumberViewController alloc]init];
//    vc.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
//    [self presentViewController:vc animated:YES completion:nil];
    
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
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.imageHeadimage.mas_bottom).mas_offset(5);
        make.size.mas_offset(CGSizeMake(200, 40));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
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
        
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(20);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-30, 200));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    _completeBtn = [[UIButton alloc]init];
    _completeBtn.backgroundColor = APP_BLUE_COLOR;
    [_completeBtn setTitle:@"完成" forState:(UIControlStateNormal)];
    self.completeBtn.layer.masksToBounds = YES;
    self.completeBtn.layer.cornerRadius = 5;
    [_completeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_completeBtn addTarget:self action:@selector(completeAction:) forControlEvents:(UIControlEventTouchDown)];
    [self.view addSubview:_completeBtn];
    [self.completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.tableview.mas_bottom).mas_offset(15 );
        make.left.mas_equalTo(self.view.mas_left).mas_offset(15);
         make.right.mas_equalTo(self.view.mas_right).mas_offset(-15);
        make.height.mas_equalTo(44);
    }];
}

@end
