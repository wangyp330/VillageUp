//
//  FZARViewController.m
//  LittentAntShortVideo
//
//  Created by mac on 2018/8/2.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZARViewController.h"
#import "FZRecognitionViewController.h"
#import "UIView+ZFFrame.h"
#import <Masonry.h>
#import "FZScanViewController.h"
#import "FZBaseWebViewController.h"
@interface FZARViewController ()<UIAlertViewDelegate>


@property(nonatomic,strong)NSString *syncScreenUUID;//同屏获取到的uuid
@end

@implementation FZARViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)addRightBtn {
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"AR教材说明" style:UIBarButtonItemStylePlain target:self action:@selector(onClickedOKbtn)];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    
}

- (void)onClickedOKbtn {
//    NSLog(@"onClickedOKbtn");
//                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您可以在浏览器打开以下链接用来扫描"
//                                                                       message:@"http://www.maaee.com/upload8/2018-10-08/10/6cd89f63-55f0-46c8-98a4-e45ced650405.pdf"
//                                                                      delegate:self
//                                                             cancelButtonTitle:nil
//                                                             otherButtonTitles:@"确定", nil];
//                        [alert show];
    
    FZBaseWebViewController *vc = [[FZBaseWebViewController alloc]init];
      NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"ARUserGuide.html" withExtension:nil];
    vc.hostUrl = [NSString stringWithFormat:@"%@",fileURL];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"学习";
    
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    view.image = [UIImage imageNamed:@"背景图新版"];
    view.userInteractionEnabled = YES;
    [self.view addSubview:view];
    
   
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font=[UIFont boldSystemFontOfSize:14];
    label.text = @"扫描宣传图";
    label.textColor = APP_BLUE_COLOR;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(270, 25));
        make.centerX.equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-58);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 110;
    [btn setBackgroundImage:[UIImage imageNamed:@"按钮新版"] forState:(UIControlStateNormal)];
    btn.centerX= view.center.x;
    [btn addTarget:self action:@selector(click) forControlEvents:(UIControlEventTouchDown)];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(220, 220));
        make.centerX.equalTo(self.view);
        make.bottom.mas_equalTo(label.mas_top).offset(10);
    }];
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    NSString *aa = [def objectForKey:@"isIosCheckVersion"];
//    if ([aa isEqualToString:@"1"]) {
//        bookbtn.hidden = YES;
//        [label mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-58);
//        }];
//    }else{
//         bookbtn.hidden = NO;
//    }
}

-(void)syncScreenClick{
    FZScanViewController *vc = [[FZScanViewController alloc]init];
    vc.uuidBlock = ^(NSString *uuid) {
        self->_syncScreenUUID=uuid;
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)click{
    
    FZRecognitionViewController *vc = [[FZRecognitionViewController alloc]init];
    vc.uuid=[NSString stringWithFormat:@"%@",_syncScreenUUID];
    [self presentViewController:vc animated:YES completion:nil];
    
    
//    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
//    [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
//    [FZNetworkingManager requestLittleAntMethod:@"isUseArPass" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
//        if (success == YES) {
//            if ([[response objectForKey:@"response"] integerValue] > 0) {
//            NSString *str =[response objectForKey:@"response"];
//            NSInteger count = [str integerValue];
//            int  aa = [[response objectForKey:@"isIosCheckVersion"] intValue];
//                if (aa == 1) {
//                    FZRecognitionViewController *vc = [[FZRecognitionViewController alloc]init];
//                    [self presentViewController:vc animated:YES completion:nil];
//                }else{
//                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
//                                                                   message:[NSString stringWithFormat:@"还剩余%ld次扫描机会",(long)count]
//                                                                  delegate:self
//                                                         cancelButtonTitle:@"取消"
//                                                         otherButtonTitles:@"确定", nil];
//                    [alert show];
//                }
//            }else{
//                int  aa = [[response objectForKey:@"isIosCheckVersion"] intValue];
//                if (aa == 1) {
//                    FZRecognitionViewController *vc = [[FZRecognitionViewController alloc]init];
//                    [self presentViewController:vc animated:YES completion:nil];
//                }else{
//                    [MBProgressHUD showError:@"您还不是会员，请购买会员" toView:self.view];
//                }
//            }
//        }
//    }];
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{//点击弹窗按钮后
//    
//    if (buttonIndex == 0) {//取消
//
//    }else if (buttonIndex == 1){//确定
//        FZRecognitionViewController *vc = [[FZRecognitionViewController alloc]init];
//        [self presentViewController:vc animated:YES completion:nil];
//    }
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
