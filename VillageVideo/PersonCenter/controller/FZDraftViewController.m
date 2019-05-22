//
//  FZDraftViewController.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/16.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZDraftViewController.h"
#import "FZDraftTableViewCell.h"
#import "ShortVideoModel.h"
#import "UIView+ZFFrame.h"
#import "FZPublishShortViewController.h"
@interface FZDraftViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)CGFloat tableViewHigth;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSMutableArray * selectDataArray;
@property(nonatomic,strong)UIButton  * delectBtn;
@property(nonatomic,strong)UIButton  * tripNtn;

@end

@implementation FZDraftViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)requestDat{
    [self.dataArray removeAllObjects];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:@(-1) forKey:@"pageNo"];
    [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
     [parm setObject:@"0" forKey:@"status"];
    [FZNetworkingManager requestLittleAntMethod:@"getUserVideoListByStatus" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {

        NSLog(@"");
        if (success == YES) {
            [[response objectForKey:@"response"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ShortVideoModel *mdoel = [[ShortVideoModel alloc]initWithDictionary:obj error:nil];
                [self.dataArray addObject:mdoel];
             
            }];
            [self.tableView reloadData];

        }
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableViewHigth = SCREEN_HEIGHT-104;
    [self addRightBtn];
    [self.view addSubview:self.tripNtn];
     [self.tableView registerNib:[UINib nibWithNibName:@"FZDraftTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self requestDat];
    [self tableView];
    self.title = @"草稿箱";
     self.tableView.tableFooterView = [UIView new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(success) name:@"punblishSuccess" object:nil];
    
}
-(void)success{
    [self requestDat];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FZDraftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[FZDraftTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    cell.multipleSelectionBackgroundView = [UIView new];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [tableView deselectRowAtIndexPath:indexPath animated:nil];
       ShortVideoModel *model = self.dataArray[indexPath.row];
    if (tableView.isEditing == NO) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        FZPublishShortViewController *vc = [[FZPublishShortViewController alloc]init];
        vc.model = model;
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{

        [self.selectDataArray addObject:model.vid];
        [_delectBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",(unsigned long)self.selectDataArray.count] forState:(UIControlStateNormal)];
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShortVideoModel *model = self.dataArray[indexPath.row];
    [self.selectDataArray removeObject:model.vid];
    [_delectBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",(unsigned long)self.selectDataArray.count] forState:(UIControlStateNormal)];
}
#pragma 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH,self.tableViewHigth) style:(UITableViewStylePlain) ];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 100;
        _tableView .rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];
        [self.view addSubview:_tableView];

    }
    return _tableView;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(NSMutableArray *)selectDataArray{
    if (!_selectDataArray) {
        _selectDataArray = [[NSMutableArray alloc]init];
    }
    return _selectDataArray;
}
- (void)goBackAction
{
    // 在这里增加返回按钮的自定义动作
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)addRightBtn {
    
    UIButton *pulishButton=[UIButton buttonWithType:(UIButtonTypeCustom)];
    [pulishButton setTitle:@"选择" forState:(UIControlStateNormal)];
    [pulishButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    pulishButton.layer.masksToBounds=YES;
    pulishButton.layer.cornerRadius=3;
    pulishButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [pulishButton addTarget:self action:@selector(pulish:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:pulishButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)pulish:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.selectDataArray removeAllObjects];
        [self.tableView setEditing:YES];;
        [sender setTitle:@"取消" forState:(UIControlStateNormal)];
        [self.view addSubview:self.delectBtn];
         self.tableView.height =SCREEN_HEIGHT-104-40;
        if (self.selectDataArray.count == 0) {
           [_delectBtn setTitle:@"删除" forState:(UIControlStateNormal)];
        }
    }else{
         [self.tableView setEditing:NO];;
         [sender setTitle:@"选择" forState:(UIControlStateNormal)];
        [self.delectBtn removeFromSuperview];
          self.tableView.height= SCREEN_HEIGHT-104;
        if (self.selectDataArray.count == 0) {
            [_delectBtn setTitle:@"删除" forState:(UIControlStateNormal)];
        }
    }
}
-(UIButton *)delectBtn{
    if (!_delectBtn) {
        _delectBtn=[UIButton buttonWithType:(UIButtonTypeCustom)];
        [_delectBtn setTitle:@"删除" forState:(UIControlStateNormal)];
        [_delectBtn setTitleColor:APP_BLUE_COLOR forState:(UIControlStateNormal)];
        _delectBtn.backgroundColor = [UIColor whiteColor];
        _delectBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        _delectBtn.frame = CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, 40);
    
        [_delectBtn addTarget:self action:@selector(delect:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delectBtn;
}
-(UIButton *)tripNtn{
    if (!_tripNtn) {
        _tripNtn=[UIButton buttonWithType:(UIButtonTypeCustom)];
        [_tripNtn setTitle:@"草稿箱的视频只有自己可见哦" forState:(UIControlStateNormal)];
        [_tripNtn setImage:[UIImage imageNamed:@"提示"] forState:(UIControlStateNormal)];
        [_tripNtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
        [_tripNtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
        _tripNtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
       _tripNtn. contentEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
        [_tripNtn setTitleColor: [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1] forState:(UIControlStateNormal)];
        _tripNtn.backgroundColor =  [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];
        _tripNtn.titleLabel.font=[UIFont systemFontOfSize:13];
        _tripNtn.frame = CGRectMake(0,64, SCREEN_WIDTH, 40);
    }
    return _tripNtn;
}
-(void)delect:(UIButton *)sender{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:[self.selectDataArray componentsJoinedByString:@","] forKey:@"videoIds"];
    [FZNetworkingManager requestLittleAntMethod:@"deleteLittleVideoInfoByType" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        
        NSLog(@"");
        if (success == YES) {
            [self.selectDataArray removeAllObjects];
            [MBProgressHUD showSuccess:@"删除成功" toView:self.view];
            [self->_delectBtn setTitle:@"删除" forState:(UIControlStateNormal)];
            [self requestDat];
            [self.selectDataArray removeAllObjects];
            
        }
    }];
}
@end
