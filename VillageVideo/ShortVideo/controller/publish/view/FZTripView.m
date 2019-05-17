//
//  FZTripView.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZTripView.h"
#import "UIView+ZFFrame.h"
#import <Masonry.h>
#import "FZTripCollectionViewCell.h"
@interface FZTripView()<FZTripCollectionViewCellDelegate>
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIButton *delButton;
@end

@implementation FZTripView
{
    NSString *_title;
    NSInteger _tag;
}

-(instancetype)initWithTitle:(NSString *)title tag:(NSInteger)tag{
    self = [super init];
    if (self) {
        _title=title;
        _tag=tag;
        [self layoutUI];
    }
    return self;
}

-(void)layoutUI{
    /*
     self.label.layer.cornerRadius = 1;
     self.label.layer.masksToBounds=YES;
     self.label.layer.borderWidth=1.0;
     self.label.backgroundColor = [[UIColor colorWithHexString:@"FFA318"] colorWithAlphaComponent:0.1];
     self.label.layer.borderColor=[[UIColor colorWithHexString:@"FFA318"] CGColor];
     self.label.textColor=[UIColor colorWithHexString:@"FFA318"];
     
     */
    self.tag=_tag;
    _titleLab= [[UILabel alloc]init];
    _titleLab.font=[UIFont systemFontOfSize:12];
    _titleLab.textAlignment=NSTextAlignmentCenter;
    _titleLab.textColor=[UIColor colorWithHexString:@"FFA318"];
    _titleLab.text=_title;
    self.titleLab.backgroundColor=[[UIColor colorWithHexString:@"FFA318"] colorWithAlphaComponent:0.1];
    self.layer.masksToBounds=YES;
    self.titleLab.layer.borderWidth=1.0;
    self.titleLab.layer.borderColor=[[UIColor colorWithHexString:@"FFA318"] CGColor];
    self.titleLab.layer.masksToBounds = YES;
    self.titleLab.layer.cornerRadius = 3;
    [self addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(8);
        make.left.mas_equalTo(self.mas_left).offset(8);
        make.right.mas_equalTo(self.mas_right).offset(-8);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-8);
    }];
    
    _delButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_delButton setImage:[UIImage imageNamed:@"取消选择"] forState:UIControlStateNormal];
    [_delButton addTarget:self action:@selector(delButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_delButton];
    [_delButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.left.mas_equalTo(self.titleLab.mas_right).offset(-18);
        make.top.mas_equalTo(self.titleLab.mas_top).offset(-18);
    }];
}


-(void)delButtonClick:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tripViewDidTip:tag:)]) {
         [self.delegate tripViewDidTip:_title tag:_tag];
    }

}
@end
