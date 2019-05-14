//
//  FZSearchViewController.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/9/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZSearchViewController.h"
#import "FZFllowTableViewCell.h"
#import "FZPersonCenterViewController.h"
#import "FZPersonalCenterViewController.h"
@interface FZSearchViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *seachTextFiled;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation FZSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索用户";
     self.tableView.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
    self.tableView.tableFooterView=[UIView new];
    self.tableView.emptyDataSetSource=self;
    self.tableView.emptyDataSetDelegate=self;
    [self.tableView registerNib:[UINib nibWithNibName:@"FZFllowTableViewCell" bundle:nil] forCellReuseIdentifier:@"FZFllowTableViewCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.seachTextFiled];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shuaxin) name:@"guanzhuchenggong" object:nil];
}
//这里可以通过发送object消息获取注册时指定的UITextField对象
- (void)textFieldDidChangeValue:(NSNotification *)notification
{
    [self.dataArray removeAllObjects];
    [self reqesetData:self.seachTextFiled.text];
}
-(void)shuaxin{
    [self reqesetData:self.seachTextFiled.text];
}
-(void)reqesetData:(NSString *)etr{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    if (etr.length > 0) {
     [parm setObject:etr forKey:@"keyWord"];
    }else{
       [parm setObject:@"" forKey:@"keyWord"];
    }
    [parm setObject:@"-1" forKey:@"pageNo"];
    
    [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"uid"];
    [FZNetworkingManager requestLittleAntMethod:@"searchUserByKeyWord" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        NSLog(@"");
         [self.dataArray removeAllObjects];
        if (success == YES) {
            [[response objectForKey:@"response"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                FZUserModel *model = [[FZUserModel alloc]initWithDictionary:obj error:nil];
                [self.dataArray addObject:model];
            }];
         
        }
           [self.tableView reloadData];
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FZPersonalCenterViewController *vc = [[FZPersonalCenterViewController alloc]init];
    FZUserModel *model = self.dataArray[indexPath.row];
    FZUserModel  *mm = [FZUserInformation shareInstance].userModel;
        vc.userId = model.uid;
        if ([mm.uid isEqualToString:model.uid]) {
            vc.isSelf=YES;
        }else{
            vc.isSelf=NO;
        }
    if (vc.userId.length > 0) {
       [self.navigationController pushViewController:vc animated:YES];
    }

 
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FZFllowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FZFllowTableViewCell"];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"FZFllowTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        
    }
    FZUserModel *model = self.dataArray[indexPath.row];
    [cell.headimGE sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    cell.NAMElaabel.text =model.userName;
    cell.mmm = model;
    return cell;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
#pragma mark - 处理空页面
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title;
  
        title = @"输入用户名或者用户ID进行搜索";
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0f],
                                 NSForegroundColorAttributeName:[UIColor grayColor]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"空页"];
}
@end
