//
//  FZShrotDiscussInfoLisView.m
//  LittentAntShortVideo
//
//  Created by mac on 2018/8/4.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZShrotDiscussInfoLisView.h"
#import "FZShrotDiscussInfoLisViewCell.h"
#import "FZShortVideoDiscussModel.h"
#import <Masonry.h>
static    NSString *cellID = @"FZShrotDiscussInfoLisViewCe";
@interface FZShrotDiscussInfoLisView()<UITableViewDelegate,UITableViewDataSource>{
    UIView *bgview;
}

@property(nonatomic,strong)UILabel  *discussInfoNumberLabel;//评论数量
@property(nonatomic,strong)UIButton *dismissBtn;;
@property(nonatomic,strong)NSArray  *array;;

@property(nonatomic,strong)UIButton *writeDisCussBtn;
@end
@implementation FZShrotDiscussInfoLisView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTableview];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.01];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMissAction)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}
-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    self.discussInfoNumberLabel.text = [NSString stringWithFormat:@"%ld条评论",dataArray.count];
    [self.tableview reloadData];
}
-(void)initTableview{
    [self addSubview:self.tableview];
     bgview = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    bgview.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgview];
    
    
    //评论数量
    UIView *commentBgView=[[UIView alloc]init];
    commentBgView.backgroundColor=[UIColor whiteColor];
    [self addSubview:commentBgView];
    [commentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
        make.bottom.mas_equalTo(self.tableview.mas_top);
        make.left.mas_equalTo(0);
    }];
    [commentBgView addSubview:self.discussInfoNumberLabel];
    [_discussInfoNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-13, 44));
        make.bottom.mas_equalTo(self.tableview.mas_top);
        make.left.mas_equalTo(13);
    }];

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH,0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    [commentBgView addSubview:lineView];
    [commentBgView addSubview:self.dismissBtn];
    [_dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.right.mas_equalTo(commentBgView.mas_right).offset(-10);
        make.centerY.equalTo(commentBgView);
    }];
    
    //写评论
    [bgview addSubview:self.writeDisCussBtn];
    UIView *writeCommentLine=[[UIView alloc]init];
    writeCommentLine.backgroundColor=[UIColor colorWithHexString:@"e5e5e5"];
    [bgview addSubview:writeCommentLine];
    [writeCommentLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
        make.top.mas_equalTo(self->bgview.mas_top).offset(1);
        make.left.mas_equalTo(0);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FZShrotDiscussInfoLisViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];

    FZShortVideoDiscussModel *mdoel = self.dataArray[indexPath.row];
    cell.model = mdoel;
    self.targetId = mdoel.targetId;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

//小时
-(void)disMissAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didMissFZShrotDiscussInfoLisView)]) {
        [self.delegate didMissFZShrotDiscussInfoLisView];
    }
}
#pragma mark 懒加载
-(UIButton *)dismissBtn{
    if (!_dismissBtn) {
        _dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dismissBtn setImage:[UIImage imageNamed:@"叉号"] forState:(UIControlStateNormal)];

        [_dismissBtn addTarget:self action:@selector(disMissAction) forControlEvents:(UIControlEventTouchDown)];
    }
    return _dismissBtn;
}
-(UILabel *)discussInfoNumberLabel{
    if (!_discussInfoNumberLabel) {
        _discussInfoNumberLabel = [[UILabel alloc]init];
        _discussInfoNumberLabel.font = [UIFont systemFontOfSize:15];
        _discussInfoNumberLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _discussInfoNumberLabel.textAlignment=NSTextAlignmentLeft;
        _discussInfoNumberLabel.text = @"0条评论";
    }
    return _discussInfoNumberLabel;
}
-(UITableView *)tableview{
    if (!_tableview ) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT *0.35, self.mj_w, SCREEN_HEIGHT *0.65-49) style:(UITableViewStyleGrouped)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.backgroundColor = [UIColor whiteColor];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:@"FZShrotDiscussInfoLisViewCell" bundle:nil] forCellReuseIdentifier:cellID];
        _tableview.tableFooterView = [UIView new];
        // self-sizing(iOS8以后才支持)
        // 设置tableView所有的cell的真实高度是自动计算的(根据设置的约束)
        self.tableview.rowHeight = UITableViewAutomaticDimension;
        // 设置tableView的估算高度
        self.tableview.estimatedRowHeight = 100;
        if (@available(iOS 11.0, *)) {
            self.tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
    }
    return _tableview;
}
-(UIButton *)writeDisCussBtn{
    if (!_writeDisCussBtn) {
        _writeDisCussBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 8  , self.mj_w-40, 31)];
        [_writeDisCussBtn setImage:[UIImage imageNamed:@"写评论"] forState:(UIControlStateNormal)];
        [_writeDisCussBtn setTitle:@"写评论" forState:(UIControlStateNormal)];
        _writeDisCussBtn.layer.cornerRadius = 15.5;
        _writeDisCussBtn.layer.masksToBounds = YES;
        _writeDisCussBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _writeDisCussBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        _writeDisCussBtn.imageEdgeInsets =  UIEdgeInsetsMake(0, 10, 0, 0);
        [_writeDisCussBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:(UIControlStateNormal)];
        _writeDisCussBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _writeDisCussBtn.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        [_writeDisCussBtn addTarget:self action:@selector(writeDisCuss:) forControlEvents:(UIControlEventTouchDown)];
    }
    return _writeDisCussBtn;
}
//写评论
-(void)writeDisCuss:(UIButton *)sender{
    SuppressPerformSelectorLeakWarning(
                                       if ([_delegate respondsToSelector:@selector(writeDisCuss:)])
                                       {
                                           [self.delegate writeDisCuss:self.targetId];
                                       });
    
}
@end
