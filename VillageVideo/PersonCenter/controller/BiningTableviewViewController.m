//
//  BiningTableviewViewController.m
//  PlayShortVideo
//
//  Created by missyun on 2018/8/1.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BiningTableviewViewController.h"
#import "ShortVideoModel.h"
@interface BiningTableviewViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextFiled;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *higth;

@end

@implementation BiningTableviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    if ([self.method isEqualToString:@"getSchoolInfoList"]) {
        _higth.constant = 60;
    }else{
       _higth.constant = 0;
    }
     self.tableView.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
    self.tableView.tableFooterView = [UIView new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.searchTextFiled];
}
//这里可以通过发送object消息获取注册时指定的UITextField对象
- (void)textFieldDidChangeValue:(NSNotification *)notification
{
    [self.dataArray removeAllObjects];
    if (self.searchTextFiled.text.length == 0) {
          [self requestData];
    }else{
        [self requestData:self.searchTextFiled.text];
    }
 
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BindingTableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"BindingTableViewCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    if ([self.method isEqualToString:@"getSchoolInfoList"]) {
        SchoolInfo *model  = self.dataArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"  %@",model.schoolName];
    }else{
        GradeInfo *model  = self.dataArray[indexPath.row];
        cell.textLabel.text =  [NSString stringWithFormat:@"  %@",model.gradeName];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if ([self.method isEqualToString:@"getSchoolInfoList"]) {
        SchoolInfo *model  = self.dataArray[indexPath.row];
        !self.selectBlock ?: self.selectBlock(model);

        [dic setObject:model.schoolId forKey:@"schoolId"];
        
    }else{
        GradeInfo *model  = self.dataArray[indexPath.row];
          !self.selectBlock ?: self.selectBlock(model);
         [dic setObject:model.gradeId forKey:@"gradeId"];
    }
//    NSString *json = [FZParmTODicString convertToJsonData:dic];
//    [parm setObject:json forKey:@"userDatas"];
//    [FZNetworkingManager requestLittleAntMethod:@"updateLittleVideoUser" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
//        if (success == YES) {
             [self.navigationController popViewControllerAnimated:YES];
//        }
//    }];

  
}
-(void)requestData:(NSString *)name{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    if (name.length > 0) {
        [parm setObject:name forKey:@"name"];
    }else{
        [parm setObject:@"" forKey:@"name"];
    }
    [FZNetworkingManager requestLittleAntMethod:@"getSchoolInfoBySchoolName" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        NSLog(@"");
        if (success == YES) {
            [self.dataArray removeAllObjects];
            [[response objectForKey:@"response"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([self.method isEqualToString:@"getSchoolInfoList"]) {
                                SchoolInfo *model = [[SchoolInfo alloc]initWithDictionary:obj error:nil];
                                [self.dataArray addObject:model];
                            }else{
                                GradeInfo *model = [[GradeInfo alloc]initWithDictionary:obj error:nil];
                                [self.dataArray addObject:model];
                            }
                        }];
                        [self.tableView reloadData];
        }
    }];
}
-(void)requestData{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:@(-1) forKey:@"pageNo"];
    [FZNetworkingManager requestLittleAntMethod:self.method parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        NSLog(@"");
        if (success == YES) {
            [self.dataArray removeAllObjects];
            [[response objectForKey:@"response"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([self.method isEqualToString:@"getSchoolInfoList"]) {
                    SchoolInfo *model = [[SchoolInfo alloc]initWithDictionary:obj error:nil];
                    [self.dataArray addObject:model];
                }else{
                    GradeInfo *model = [[GradeInfo alloc]initWithDictionary:obj error:nil];
                    [self.dataArray addObject:model];
                }
            }];
            [self.tableView reloadData];
        }
    }];
}
-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}
- (IBAction)startSearchAction:(id)sender {
}
#pragma mark 懒加载
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
@end
