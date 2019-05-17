//
//  FZTripViewController.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZTripViewController.h"
#import "FZChallageModel.h"
#import "FZTripView.h"
#import <Masonry.h>
#import "FZChallengTableViewCell.h"
@interface FZTripViewController ()<FZTripViewDelegate>{
}
@property (weak, nonatomic) IBOutlet UITextField *searchtextFilED;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *selectDataArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHigth;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIScrollView *topScrollView;
@property (weak, nonatomic) IBOutlet UIView *ffview;
@property (assign, nonatomic) NSInteger pageNo;
@end

@implementation FZTripViewController


- (void)addRightBtn {
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(onClickedOKbtn)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)onClickedOKbtn {
    NSLog(@"onClickedOKbtn");
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didSelectTrip:)]) {
        [self.delegate didSelectTrip:self.selectDataArray];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)didSelectClass:(FZChallageModel * )model and:(NSInteger)inter{



}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutTopScrollView];
    [self loadHadSaveTrip];

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"],
                                                                      NSFontAttributeName : [UIFont systemFontOfSize:17]}];
    self.title=@"添加标签";
    [self addRightBtn];
    self.searchtextFilED.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self.searchtextFilED setValue:[UIColor colorWithHexString:@"999999"] forKeyPath:@"_placeholderLabel.textColor"];
    self.ffview.layer.masksToBounds = YES;
    self.ffview.layer.cornerRadius = 1.5;
     self.ffview.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    //这里的object传如的是对应的textField对象,方便在事件处理函数中获取该对象进行操作。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.searchtextFilED];

    //self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight =48;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_tableView setEditing:YES animated:YES];
    self.pageNo =-1;
    [self requestrt:@""];
    [self.selectDataArray addObjectsFromArray:self.dataSource];
       [self.searchtextFilED addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        self.pageNo = 1;
//        [self.dataArray removeAllObjects];
//        [ self requestrt:self.searchtextFilED.text];
//
//    }];
//
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        self.pageNo++;
//        [ self requestrt:self.searchtextFilED.text];
//
//    }];
}
- (void)textFieldDidChange:(UITextField *)textField
{
    //    if (textField == self.serachTextFiled) {
    //        if (textField.text.length > 6) {
    //            textField.text = [textField.text substringToIndex:6];
    //        }
    //    }
    
    NSInteger kMaxLength = 6;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
                //                [ToastUtils showHud:@"超过字数限制"];
                //                [self.dataArray removeAllObjects];
                //                [self requestrt:textField.text];
            }
        }
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
            
        }
    }
    [self.dataArray removeAllObjects];
    [self requestrt:textField.text];
}
//这里可以通过发送object消息获取注册时指定的UITextField对象
- (void)textFieldDidChangeValue:(NSNotification *)notification
{
//    [self.dataArray removeAllObjects];
//    [self requestrt:self.searchtextFilED.text];
}

-(void)requestrt:(NSString *)str{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:@(self.pageNo) forKey:@"pageNo"];
    [parm setObject:str forKey:@"tagContent"];
    [parm setObject:@"1" forKey:@"tagType"];
    [SVProgressHUD showGif];
    [FZNetworkingManager requestLittleAntMethod:@"getTagsByContent" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        if (success == YES) {
            if (self.pageNo == 1) {
                 [self.dataArray removeAllObjects];
            }
            [[response objectForKey:@"response"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {

                FZChallageModel *model = [[FZChallageModel alloc]initWithDictionary:obj error:nil];
                [self.dataArray addObject:model];
            }];
            [self.tableView reloadData];

            [self.dataArray enumerateObjectsUsingBlock:^(FZChallageModel *model , NSUInteger idx, BOOL * _Nonnull stop) {

                [self.dataSource enumerateObjectsUsingBlock:^(FZChallageModel *mm, NSUInteger idxdd, BOOL * _Nonnull stop) {

                    if ([model.tagTitle isEqualToString:mm.tagTitle]) {
                        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:(UITableViewScrollPositionNone)];
                    }
                }];
            }];
//            [self.dataArray enumerateObjectsUsingBlock:^(FZChallageModel *model , NSUInteger idx, BOOL * _Nonnull stop) {
//
//                [self.selectDataArray enumerateObjectsUsingBlock:^(FZChallageModel *mm, NSUInteger idxdd, BOOL * _Nonnull stop) {
//
//                    if ([model.tagTitle isEqualToString:mm.tagTitle]) {
//                        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:(UITableViewScrollPositionNone)];
//                    }
//                }];
//            }];
        }
          [SVProgressHUD hidGif];
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];

        NSLog(@"");
    }];

}
#pragma mark - 头部标签UI
-(void)layoutTopScrollView{
    _topScrollView=[[UIScrollView alloc]init];
    _topScrollView.backgroundColor=[UIColor whiteColor];
    _topScrollView.showsVerticalScrollIndicator=NO;
    _topScrollView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:_topScrollView];
    [_topScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(0);
    }];
    self.topHigth.constant = 0;

    _topScrollView.layer.borderWidth=0.5;
    _topScrollView.layer.borderColor=[UIColor colorWithHexString:@"e5e5e5"].CGColor;
}

/**
 加载已经存在的标签
 */
-(void)loadHadSaveTrip{
    if (self.dataSource.count > 0) {
        self.topHigth.constant = 59;
    }else{
        self.topHigth.constant = 0;
    }
    if (self.dataSource.count > 0) {
        [_topScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).offset(64);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.mas_equalTo(58);
        }];
    }else{
        [_topScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).offset(64);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.mas_equalTo(0);
        }];
    }
    for (UIView *viwe in self.topScrollView.subviews) {
        [viwe removeFromSuperview];
    }
    NSString *keyStr;
    CGFloat space=15;
    CGFloat startX=space;
    for (NSInteger i=0; i<self.dataSource.count; i++) {
        FZChallageModel *model =self.dataSource[i];
        keyStr=model.tagTitle;
        FZTripView *trip=[[FZTripView alloc]initWithTitle:keyStr tag:i];
        trip.delegate=self;
        [self.topScrollView addSubview:trip];
        //        CGFloat width=(keyStr.length*22);
        CGSize size = [keyStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]}];
        CGFloat width =size.width+30;
        CGFloat height=35;
        [trip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width, height));
            make.centerY.equalTo(self.topScrollView);
            make.left.mas_equalTo(startX + ((space*i)));
        }];
        startX += width;
    }
    _topScrollView.contentSize=CGSizeMake(startX+(space*self.dataSource.count), 0);
    
}

-(void)reloadTrips{

        if (self.selectDataArray.count > 0) {
            self.topHigth.constant = 59;
        }else{
           self.topHigth.constant = 0;
        }
        if (self.selectDataArray.count > 0) {
            [_topScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view.mas_top).offset(64);
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
                make.height.mas_equalTo(58);
            }];
        }else{
            [_topScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view.mas_top).offset(64);
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
                make.height.mas_equalTo(0);
            }];
        }
    for (UIView *viwe in self.topScrollView.subviews) {
        [viwe removeFromSuperview];
    }
    NSString *keyStr;
    CGFloat space=15;
    CGFloat startX=space;
    for (NSInteger i=0; i<self.selectDataArray.count; i++) {
         FZChallageModel *model =self.selectDataArray[i];
        keyStr=model.tagTitle;
        FZTripView *trip=[[FZTripView alloc]initWithTitle:keyStr tag:i];
        trip.delegate=self;
        [self.topScrollView addSubview:trip];
//        CGFloat width=(keyStr.length*22);
        CGSize size = [keyStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]}];
        CGFloat width =size.width+30;
        CGFloat height=35;
        [trip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width, height));
            make.centerY.equalTo(self.topScrollView);
            make.left.mas_equalTo(startX + ((space*i)));
        }];
        startX += width;
    }
    _topScrollView.contentSize=CGSizeMake(startX+(space*self.selectDataArray.count), 0);
    
//    [self.tableView reloadData];
}

#pragma mark - tripView delegate
-(void)tripViewDidTip:(NSString *)tripTitle tag:(NSInteger)tag{


    [self.dataArray enumerateObjectsUsingBlock:^(FZChallageModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([tripTitle isEqualToString:obj.tagTitle]) {
            [self tableView:self.tableView didDeselectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] ];
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]  animated:YES];
            *stop = YES;
        }
    }];

}

#pragma mark - tableView delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FZChallageModel *model = self.dataArray[indexPath.row];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.selected = YES;
    NSMutableArray *titles=[[NSMutableArray alloc]init];
    for (FZChallageModel *mm in self.selectDataArray) {
        [titles addObject:mm.tagTitle];
    }
    if (![titles containsObject:model.tagTitle]) {
        [self.selectDataArray addObject:model];
        [self reloadTrips];
    }


}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    FZChallageModel *model = self.dataArray[indexPath.row];
    
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    BOOL isHax = NO;
    NSInteger index = 0;
    for (FZChallageModel *mm in self.selectDataArray) {
        if ([model.tagTitle isEqualToString:mm.tagTitle]) {
            isHax = YES;
            break;
        }
        index++;
    }
    if (isHax) {
        [self.selectDataArray removeObjectAtIndex:index];
        [self reloadTrips];
    }


}
- ( NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectDataArray.count == 3) {
        [MBProgressHUD showSuccess:@"标签最多选择3个" toView:self.view];
        return  nil;
    }
    return indexPath;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ident=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ident];
        cell.contentView.backgroundColor = [UIColor clearColor];
        UIView *backGroundView = [[UIView alloc]init];
        backGroundView.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = backGroundView;
    }
    cell.selected = NO;
//      cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArray.count > 0) {
        FZChallageModel *model = self.dataArray[indexPath.row];
        cell.multipleSelectionBackgroundView = [UIView new];
        cell.textLabel.text=model.tagTitle;
        cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        for (FZChallageModel *mm in self.dataSource ) {
            if ([mm.tagTitle isEqualToString:model.tagTitle]) {
                cell.selected = YES;
                break;
            }
        }
    }
    if (indexPath.row != self.dataArray.count-1) {
        UIView *lineView=[[UIView alloc]init];
        lineView.backgroundColor=[UIColor colorWithHexString:@"e5e5e5"];
        [cell addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(cell.mas_right).offset(-10);
            make.bottom.mas_equalTo(cell.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
    }
    return cell;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
#pragma mark - 懒加载
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray =[[NSMutableArray alloc]init];

    }
    return _dataArray;
}
-(NSMutableArray *)selectDataArray{
    if (!_selectDataArray) {
        _selectDataArray =[[NSMutableArray alloc]init];

    }
    return _selectDataArray;
}

@end

