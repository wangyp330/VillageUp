//
//  BiningTableviewViewController.m
//  PlayShortVideo
//
//  Created by missyun on 2018/8/1.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BiningTableviewViewController.h"
#import "ShortVideoModel.h"
@interface BiningTableviewViewController ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation BiningTableviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
    self.tableView.tableFooterView = [UIView new];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BindingTableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"BindingTableViewCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    GroupModel *model  = self.dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"  %@",model.groupName];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GroupModel *model  = self.dataArray[indexPath.row];
    if (self.selectBlock) {
        self.selectBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)requestData{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:[FZUserInformation shareInstance].userModel.villageId forKey:@"villageId"];
    [FZNetworkingManager requestLittleAntMethod:@"getVillageGroupList" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        if (success == YES) {
            [self.dataArray removeAllObjects];
            [[response objectForKey:@"response"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GroupModel *model = [[GroupModel alloc]initWithDictionary:obj error:nil];
                [self.dataArray addObject:model];
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
