//
//  FZLookFansViewController.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZLookFansViewController.h"
#import "FZFllowModel.h"
#import <UIImageView+WebCache.h>
#import "FZFllowTableViewCell.h"
#import "FZPersonalCenterViewController.h"
#import "FZSearchViewController.h"
@interface FZLookFansViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation FZLookFansViewController
- (void)addRightBtn {
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(onClickedOKbtn)];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancleButton.frame = CGRectMake(0, 0, 40, 40);
    [cancleButton setImage:[UIImage imageNamed:@"搜索"] forState:(UIControlStateNormal)];
    [cancleButton addTarget:self action:@selector(cancleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancleButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
-(void)cancleButtonClicked{
    FZSearchViewController *na = [[FZSearchViewController alloc]init];
    [self.navigationController pushViewController:na animated:YES];
}
-(void)shuaxin{
    [self.dataArray removeAllObjects];
    if (self.type == 0) {
        [self getUserFans];
    }
    else if (self.type == 1){
        [self getUserFollowsByUserId];//关注
  
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shuaxin) name:@"guanzhuchenggong" object:nil];
    NSLog(@"%ld",self.type);
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
    if (self.type == 0) {
        [self getUserFans];
    }
    else if (self.type == 1){
         [self getUserFollowsByUserId];//关注
        [self addRightBtn];
    }

    self.tableView.tableFooterView=[UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZFllowTableViewCell" bundle:nil] forCellReuseIdentifier:@"FZFllowTableViewCell"];
    self.tableView.emptyDataSetSource=self;
    self.tableView.emptyDataSetDelegate=self;
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
       FZFllowModel *model = self.dataArray[indexPath.row];
    FZUserModel  *mm = [FZUserInformation shareInstance].userModel;
//    vc.isSelf=YES;
//    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:vc];
    if (self.type == 0) {
          vc.userId = model.fansUser.uid;
        if ([mm.uid isEqualToString:model.fansUser.uid]) {
             vc.isSelf=YES;
        }else{
            vc.isSelf=NO;
        }
    }
    else if (self.type == 1){
          vc.userId = model.littleVideoUser.uid;
        if ([mm.uid isEqualToString:model.littleVideoUser.uid]) {
            vc.isSelf=YES;
        }else{
            vc.isSelf=NO;
        }
    }
    if ( vc.userId.length > 0) {
        [self.navigationController pushViewController:vc animated:YES];
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FZFllowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FZFllowTableViewCell"];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"FZFllowTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        
    }
    FZFllowModel *model = self.dataArray[indexPath.row];
    if (self.type == 0) {
        cell.attemntBtn.hidden = YES;
    }
    else {
        cell.attemntBtn.hidden = NO;
    }
     cell.type = self.type;
    cell.model = model;

    return cell;
}
-(void)getUserFollowsByUserId{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    if (self.userId && self.userId.length > 0) {
        
        [parm setObject:self.userId forKey:@"userId"];
    }else{
        [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
    }
     [parm setObject:@"-1"forKey:@"targetType"];
     [parm setObject:@"-1"forKey:@"pageNo"];
    [FZNetworkingManager requestLittleAntMethod:@"getUserFollowsByUserId" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        
        if (success == YES) {
            [[response objectForKey:@"response"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
                FZFllowModel *model = [[FZFllowModel alloc]initWithDictionary:obj error:nil];
                [self.dataArray addObject:model];
                
            }];
            [self.tableView reloadData];
        }
        NSLog(@"");
    }];
}
-(void)getUserFans{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    if (self.userId && self.userId.length > 0) {
        
        [parm setObject:self.userId forKey:@"userId"];
    }else{
        [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
    }
    [parm setObject:@"0"forKey:@"targetType"];
    [parm setObject:@"-1"forKey:@"pageNo"];
    [FZNetworkingManager requestLittleAntMethod:@"getUserFans" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        
        if (success == YES) {
            [[response objectForKey:@"response"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                FZFllowModel *model = [[FZFllowModel alloc]initWithDictionary:obj error:nil];
                [self.dataArray addObject:model];
                
            }];
            [self.tableView reloadData];
        }
        NSLog(@"");
    }];
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
    if (_type==1) {
        //关注
        title = @"你还没有关注任何人，快去逛逛吧~";
    }else if (_type ==3){
        //审核
        title = @"暂时无数据";
    }else{
        //粉丝
        title = @"你还没有粉丝，赶紧邀请小伙伴来关注你吧~";
    }
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
