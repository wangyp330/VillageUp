//
//  FZChallengAndTripViewController.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZChallengAndTripViewController.h"
#import "FZChallengTableViewCell.h"
#import "FZChallageModel.h"
#import "FZStartViewController.h"
@interface FZChallengAndTripViewController ()
@property (weak, nonatomic) IBOutlet UITextField *serachTextFiled;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FZChallengAndTripViewController


-(void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 100;
    self.serachTextFiled.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self.serachTextFiled setValue:[UIColor colorWithHexString:@"999999"] forKeyPath:@"_placeholderLabel.textColor"];
    self.serachTextFiled.layer.masksToBounds = YES;
    self.serachTextFiled.layer.cornerRadius = 1.5;
    self.title = @"添加挑战";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"],
                                                                      NSFontAttributeName : [UIFont systemFontOfSize:17]}];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZChallengTableViewCell" bundle:nil] forCellReuseIdentifier:@"FZChallengTableViewCell"];
    [self requestrt:@""];
    //这里的object传如的是对应的textField对象,方便在事件处理函数中获取该对象进行操作。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.serachTextFiled];
    
    [self.serachTextFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
//    [self requestrt:self.serachTextFiled.text];
}

-(void)requestrt:(NSString *)str{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:@(-1) forKey:@"pageNo"];
         [parm setObject:str forKey:@"tagContent"];
    [parm setObject:@"2" forKey:@"tagType"];
    [FZNetworkingManager requestLittleAntMethod:@"getTagsByContent" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        [self.dataArray removeAllObjects];
        if (success == 1) {
            [[response objectForKey:@"response"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                FZChallageModel *model = [[FZChallageModel alloc]initWithDictionary:obj error:nil];
                [self.dataArray addObject:model];
            }];
            [self.tableView reloadData];
            
        }

        NSLog(@"");
        
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FZChallageModel *model = self.dataArray[indexPath.row];
    if ([model.joinPeople isEqualToString:@"点击发起"]) {
        FZStartViewController *vc = [[FZStartViewController alloc]init];
        vc.titleaa = self.serachTextFiled.text;
        vc.block = ^(FZChallageModel  *dic) {
            if (self.delegate &&[self.delegate respondsToSelector:@selector(didSelectClass:)]) {
                [self.delegate didSelectClass:dic];
            }
            [self.navigationController popViewControllerAnimated:YES];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if (self.description && [self.delegate respondsToSelector:@selector(didSelectClass:)]) {
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:model.tagId forKey:@"tagId"];
            [parm setObject:@"2" forKey:@"tagType"];
             [parm setObject:model.tagTitle forKey:@"tagTitle"];
            if (self.delegate &&[self.delegate respondsToSelector:@selector(didSelectClass:)]) {
                      [self.delegate didSelectClass:model];
            }
   
            [self.navigationController popViewControllerAnimated:YES];
        }
    }

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FZChallengTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FZChallengTableViewCell"];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"FZChallengTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    if (self.dataArray.count > 0) {
        cell.model = self.dataArray[indexPath.row];
    }

    return cell;
}
#pragma maek 数据
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray =[[NSMutableArray alloc]init];
        
    }
    return _dataArray;
}
@end
