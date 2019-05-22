//
//  FZStartViewController.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZStartViewController.h"
#import "FSTextView.h"
#import "FZPublishShortViewController.h"
@interface FZStartViewController ()
@property (weak, nonatomic) IBOutlet UIView *titleBgView;
@property (weak, nonatomic) IBOutlet UITextField *titleTets;
@property(nonatomic,strong)FSTextView *textfiled;
@property (weak, nonatomic) IBOutlet UIView *contentView;


@end

@implementation FZStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"发起挑战";
    self.titleTets.attributedText = [FZChangeTextColor changeString:[NSString stringWithFormat:@"# %@",self.titleaa]];;
    [self textfiled];
    
}

-(void)configUI{
    _titleBgView.layer.masksToBounds=YES;
    _titleBgView.layer.cornerRadius=2.0;
    
    _contentView.layer.masksToBounds=YES;
    _contentView.layer.cornerRadius=2.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sureAction:(id)sender {
//    NSMutableDictionary *parm = [NSMutableDictionary new];
    FZChallageModel *model = [[FZChallageModel alloc]init];
    
    if (self.titleTets.text.length > 0) {
        model.tagContent =self.titleTets.text;
    }
     model.tagType =@"2";
     model.tagTitle =self.titleaa;
     
    
    if (self.block) {
        self.block(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(FSTextView *)textfiled{
    if (!_textfiled) {
        _textfiled = [[FSTextView alloc]init];
        _textfiled.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.05];
        _textfiled.textColor = [UIColor colorWithHexString:@"333333"];
        _textfiled.font = [UIFont systemFontOfSize:14];
        _textfiled.placeholder = @"简单描述下你的挑战";
        _textfiled.maxLength = 60;
        _textfiled.frame = CGRectMake(0, 0, SCREEN_WIDTH-26, 130);
        [self.contentView addSubview:_textfiled];
    }
    return  _textfiled;
}
@end
