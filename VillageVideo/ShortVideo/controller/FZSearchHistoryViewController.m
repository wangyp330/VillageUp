//
//  FZSearchHistoryViewController.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/16.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZSearchHistoryViewController.h"
#import "FZBaseWebViewController.h"
#import "ShortVideoModel.h"
#import "ZFDouYinViewController.h"
@interface FZSearchHistoryViewController ()<FZWebViewControllerDelegate>{
      ZFDouYinViewController *vc;
}
@property (nonatomic, strong) NSMutableArray  *dataArray;
@end

@implementation FZSearchHistoryViewController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索视频";
    FZBaseWebViewController *vc = [[FZBaseWebViewController alloc]init];
    //    vc.title = @"审核列表";
    vc.delegate=self;
    vc.hostUrl = self.hostUrl;
    [self addChildViewController:vc];
    vc.view.frame = self.view.frame;
    [self.view addSubview:vc.view];
}
-(void)fzwebViewControllCallHandlerWithMethod:(NSString *)method data:(NSDictionary *)data{
    [self.dataArray removeAllObjects];
    if ([method isEqualToString:@"playVideo"]) {
        //播放视频
        [[data objectForKey:@"videos"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ShortVideoModel *model = [[ShortVideoModel alloc]initWithDictionary:obj error:nil];
            [self.dataArray addObject:model];
            
        }];
        vc = [[ZFDouYinViewController alloc]init];
        vc.dataArray = [[NSMutableArray alloc]initWithArray:self.dataArray];
        vc.pageNumber = 10000;
        vc.index = [[data objectForKey:@"pageNo"] integerValue];
        [vc playTheIndex:[[data objectForKey:@"position"] intValue]];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

@end
