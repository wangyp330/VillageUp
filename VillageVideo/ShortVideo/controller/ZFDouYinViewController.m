//
//  ZFDouYinViewController.m
//  ZFPlayer_Example
//
//  Created by 紫枫 on 2018/6/4.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import "ZFDouYinViewController.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFIJKPlayerManager.h"
#import "KSMediaPlayerManager.h"
#import  "ZFPlayerControlView.h"
#import "ZFDouYinCell.h"
#import "FZPlayVideoTableViewCell.h"
#import "ZFDouYinControlView.h"
#import <UINavigationController+FDFullscreenPopGesture.h>
#import <MJRefresh.h>
#import "ShortVideoModel.h"
#import "LTInputAccessoryView.h"//键盘
#import "FZShrotDiscussInfoLisView.h"//评论列表
#import "FZShortVideoDiscussModel.h"
#import "FZFlowingViewController.h"
#import <RTRootNavigationController.h>
#import "FZPersonCenterViewController.h"
#import "FZPersonalCenterViewController.h"
#import "FZChallageViewController.h"
#import "ShareView.h"
#import <WXApi.h>
#import "FZShortVideolikeAnimation.h"
#import <KTVHTTPCache/KTVHTTPCache.h>
#import "DHGuidePageHUD.h"
#import <IQKeyboardManager.h>
static NSString *kIdentifier = @"kIdentifier";
@interface ZFDouYinViewController ()  <UITableViewDelegate,UITableViewDataSource,shortVideoActionDelegaet,FZShrotDiscussInfoLisViewDelegate,UIGestureRecognizerDelegate>{
    LTInputAccessoryView* view;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFDouYinControlView *controlView;
@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic, strong) UIButton *backBtn;
@property(nonatomic,strong)FZShrotDiscussInfoLisView *shrotDiscussInfoLisView;
@property(nonatomic,strong)NSMutableArray *discussInfoArray;//评论
@property(nonatomic,assign)NSInteger  pageNo;//评论
@property(nonatomic,strong)NSIndexPath *  playTheIndex;//评论
@property(nonatomic,strong)NSMutableArray  *  dataSoure;//评论

@property (nonatomic, strong) UIImageView  *yindaoImage;//引导手势
@end

@implementation ZFDouYinViewController

-(NSMutableArray *)dataSoure{
    if (!_dataSoure) {
        _dataSoure = [NSMutableArray new];
    }
    return _dataSoure;
}
-(void)dealloc{
    NSLog(@"jaha");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    if (self.player) {
//        [self.player stop];
////             self.player = nil;
//    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    NSLog(@"jaha");
    if (self.player) {
        [self.player stop];
//        self.player = nil;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
        [IQKeyboardManager sharedManager].enable = NO;
//    KTVHTTPCache
    NSLog(@"jaha");
    if (self.player) {
        [self.player playTheIndex:self.playTheIndex.row];;
    }
}
-(FZShrotDiscussInfoLisView *)shrotDiscussInfoLisView{
    if (!_shrotDiscussInfoLisView) {
        _shrotDiscussInfoLisView = [[FZShrotDiscussInfoLisView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _shrotDiscussInfoLisView.delegate =self;
        [self.view addSubview:self.shrotDiscussInfoLisView];
        [self.view bringSubviewToFront:self.shrotDiscussInfoLisView];
    }
    return _shrotDiscussInfoLisView;
}
- (void)didMissFZShrotDiscussInfoLisView{
    if (_shrotDiscussInfoLisView) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.shrotDiscussInfoLisView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);

        } completion:^(BOOL finished) {
            [self->_shrotDiscussInfoLisView removeFromSuperview];
            self->_shrotDiscussInfoLisView = nil;
        }];
      
    }
    if (view) {
       [view close];
    }

}
-(void)writeDisCuss:(NSString *)targetID{
    
    NSMutableDictionary *parm = [NSMutableDictionary new];
    if (targetID != nil) {
      [parm setObject:targetID forKey:@"targetId"];
    }
    [parm setObject:targetID forKey:@"targetId"];
    [parm setObject:@"1" forKey:@"targetType"];
    [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
    view = [LTInputAccessoryView new];
    [view showBlock:^(NSString *contentStr) {
        [parm setObject:contentStr forKey:@"discussContent"];
        [FZNetworkingManager requestLittleAntMethod:@"saveDiscussInfo" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
            NSLog(@"%@",contentStr);
            if (success == YES) {
                [MBProgressHUD showSuccess:@"评论成功" toView:self.view ];
                NSMutableDictionary *parm1 = [[NSMutableDictionary alloc]init];
                [parm1 setObject:targetID forKey:@"videoId"];
                [parm1 setObject:@"1" forKey:@"type"];
                [parm1 setObject:@"-1" forKey:@"pageNo"];
                    [[NSNotificationCenter defaultCenter ] postNotificationName:@"isFollow" object:nil];
                [FZNetworkingManager requestLittleAntMethod:@"getDiscussInfoList" parameters:parm1 requestHandler:^(BOOL success, id  _Nullable response) {
                    NSLog(@"%@",response);
                    if (success == YES) {
                        [self.discussInfoArray removeAllObjects];
                        [[response objectForKey:@"response"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            FZShortVideoDiscussModel *model = [[FZShortVideoDiscussModel alloc]initWithDictionary:obj error:nil];
                            [self.discussInfoArray addObject:model];
                        }];
                        self.shrotDiscussInfoLisView.dataArray = [NSArray arrayWithArray:self.discussInfoArray];
                        [self.shrotDiscussInfoLisView.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
                    }
                }];
            }
        }];
        
    }];
    
}
#pragma mark 举报
- (void)isIosCheckVersion:(UIButton *)btn withCell:(FZPlayVideoTableViewCell *)cell{
    NSLog(@"%s",__func__);
    [MBProgressHUD showSuccess:@"感谢您的举报，我们将在24小时内回复您" toView:self.view];
}
#pragma mark 挑战
- (void)chagllActionAction:(UIButton *)btn withCell:(FZPlayVideoTableViewCell *)cell{

    ShortVideoModel *model = cell.model;
    FZChallageViewController *vc = [[FZChallageViewController alloc]init];
//    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:vc];
    [model.tags enumerateObjectsUsingBlock:^(Tags * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj = (Tags *)obj;
        Tags *t = [[Tags alloc]initWithDictionary:obj error:nil];
        if ([t.tagType intValue] == 2) {
            vc.tagId = [NSString stringWithFormat:@"%@",t.tagId];
            vc.tagtitle = t.tagTitle;
            vc.tagConten = t.tagContent;
            vc.tagModel = t;
        }
    }];
    if (vc.tagId.length > 0) {
        [self presentViewController:vc animated:YES completion:^{
            
        }];
    }

}

#pragma mark 删除视频
- (void)delectBtnAction:(UIButton *)btn withCell:(FZPlayVideoTableViewCell *)cell{
    
//    FZAlertView *alertView = [[FZAlertView alloc]initWithButtonTitles:@[@"取消",@"确定"] title:@"你确定删除吗？" message:nil];
//    [alertView setFzAlertViewButtonTouchedBlock:^(FZAlertView *alertView, int buttonIndex) {
//        [alertView close];
//        if (buttonIndex == 0) {
//
//        }else{
//            NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
//            ShortVideoModel *model = cell.model;
//            [parm setObject:model.vid forKey:@"videoIds"];
//            [FZNetworkingManager requestLittleAntMethod:@"deleteLittleVideoInfoByType" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
//                NSLog(@"%@",response);
//                if (success == YES) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"punblishSuccess" object:nil];
//                    [self.dataArray removeObject:model];
//                    if (self.dataArray.count == 0) {
//                        [self dismissViewControllerAnimated:YES completion:nil];
//                        if (self->view) {
//                            [self->view close];
//                        }
//                    }else{
//                        if (self.playTheIndex.row == self.dataArray.count) {
//                             [self playTheVideoAtIndexPath:[NSIndexPath indexPathForRow:self.playTheIndex.row-1 inSection:0] scrollToTop:YES];
//                        }else{
////                            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.playTheIndex.row inSection:0]] withRowAnimation:(UITableViewRowAnimationTop)];
//                            [self playTheVideoAtIndexPath:[NSIndexPath indexPathForRow:self.playTheIndex.row+1 inSection:0] scrollToTop:YES];
//
//                        }
//
//                        if (self->view) {
//                            [self->view close];
//                        }
//                    }
//                }
//            }];
//        }
//
//
//    }];
//    [alertView show];
 
}
#pragma mark 查看某人
- (void)lookansAction:(UIButton *)btn withCell:(FZPlayVideoTableViewCell *)cell{
     NSLog(@"%s",__func__);
    ShortVideoModel *model = cell.model;
    FZPersonalCenterViewController *vc = [[FZPersonalCenterViewController alloc]init];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:vc];
    vc.userId = model.userInfo.uid;
    vc.userModel = model.userInfo;
    if ([[FZUserInformation shareInstance].userModel.uid isEqualToString:model.userInfo.uid]) {
         vc.isSelf=YES;
    }else{
        vc.isSelf=NO;
    }
//    vc.higth = 64;
    if (vc.userId.length > 0) {
        [self presentViewController:na animated:YES completion:^{
            
        }];
    }

}
#pragma maek 去看评论
- (void)clickCommentNumberAction:(UIButton *)btn withCell:(FZPlayVideoTableViewCell *)cell{
    NSLog(@"%s",__func__);
     NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
      ShortVideoModel *model = cell.model;
    [parm setObject:model.vid forKey:@"videoId"];
    [parm setObject:@"1" forKey:@"type"];
    [parm setObject:@"-1" forKey:@"pageNo"];
    [FZNetworkingManager requestLittleAntMethod:@"getDiscussInfoList" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        NSLog(@"%@",response);
        if (success == YES) {
            [self.discussInfoArray removeAllObjects];
            [[response objectForKey:@"response"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
                FZShortVideoDiscussModel *model = [[FZShortVideoDiscussModel alloc]initWithDictionary:obj error:nil];
                [self.discussInfoArray addObject:model];
            }];
            [self shrotDiscussInfoLisView];
            self.shrotDiscussInfoLisView.dataArray = [NSArray arrayWithArray:self.discussInfoArray];
            self.shrotDiscussInfoLisView.targetId = model.vid;
        }
    }];
    self.shrotDiscussInfoLisView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    [UIView animateWithDuration:0.5 animations:^{
        self.shrotDiscussInfoLisView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}
#pragma mark -  去分享
- (void)clickShareAction:(UIButton *)btn withCell:(FZPlayVideoTableViewCell *)cell{
    NSLog(@"%s",__func__);
    
    BOOL hadInstalledWeixin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    NSMutableArray *titlearr     = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *imageArr     = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *typeArr     = [NSMutableArray arrayWithCapacity:5];
    ShortVideoModel *model = cell.model;

    if ([[FZUserInformation shareInstance].userModel.uid isEqualToString:model.userInfo.uid]) {
      
        [titlearr addObjectsFromArray:@[@"分享到微信", @"分享到微信朋友圈", @"删除视频"]];
        [imageArr addObjectsFromArray:@[@"wechat",@"friend",@"视频删除"]];
        [typeArr addObjectsFromArray:@[@(ShareTypeWechatSession), @(ShareTypeWechatTimeLine),@(shareDelect)]];
    }else{
        [titlearr addObjectsFromArray:@[@"分享到微信", @"分享到微信朋友圈"]];
        [imageArr addObjectsFromArray:@[@"wechat",@"friend"]];
        [typeArr addObjectsFromArray:@[@(ShareTypeWechatSession), @(ShareTypeWechatTimeLine)]];
    }

    ShareView *shareView = [[ShareView alloc] initWithShareHeadOprationWith:titlearr andImageArry:imageArr andProTitle:@"fenxiangdao"];
    shareView.proFont = 0;
    shareView.topHigth = 10;
    [shareView setBtnClick:^(NSInteger btnTag) {
        NSLog(@"\n点击第几个====%d\n当前选中的按钮title====%@",(int)btnTag,titlearr[btnTag]);
        //创建发送对象实例
        if (btnTag == 2) {
            
            FZAlertView *alertView = [[FZAlertView alloc]initWithButtonTitles:@[@"取消",@"确定"] title:@"你确定删除吗？" message:nil];
            [alertView setFzAlertViewButtonTouchedBlock:^(FZAlertView *alertView, int buttonIndex) {
                [alertView close];
                if (buttonIndex == 0) {
                    
                }else{
                    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
                    ShortVideoModel *model = cell.model;
                    [parm setObject:model.vid forKey:@"videoIds"];
                    [FZNetworkingManager requestLittleAntMethod:@"deleteLittleVideoInfoByType" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
                        NSLog(@"%@",response);
                        if (success == YES) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"punblishSuccess" object:nil];
                            [self.dataArray removeObject:model];
                            [self.tableView reloadData];
                            if (self.dataArray.count == 0) {
                                [self dismissViewControllerAnimated:YES completion:nil];
                                if (self->view) {
                                    [self->view close];
                                }
                            }else{
//                                  [self.tableView deleteRowsAtIndexPaths:@[self.playTheIndex] withRowAnimation:(UITableViewRowAnimationTop)];
                                if (self.playTheIndex.row == self.dataArray.count) {
                                    [self playTheVideoAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] scrollToTop:YES];
                                     [self.player.currentPlayerManager reloadPlayer];
                                    [self.player.currentPlayerManager play];
                                }else{
//                                    [self playTheVideoAtIndexPath:[NSIndexPath indexPathForRow:self.playTheIndex.row inSection:0] scrollToTop:YES];
                                    [self.player playTheNext] ;
                                }
                                if (self->view) {
                                    [self->view close];
                                }
                            }
                        }
                    }];
                }
                
            }];
            [alertView show];
            
        }else{
            SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
            sendReq.bText = NO;//不使用文本信息
            sendReq.scene = (int)btnTag;//0 = 好友列表 1 = 朋友圈 2 = 收藏
            //创建分享内容对象
            WXMediaMessage *urlMessage = [WXMediaMessage message];
            urlMessage.title = [NSString stringWithFormat:@"[%@]的这个视频好精彩，快来围观吧",model.userInfo.userName];//分享标题
            urlMessage.description = model.videoContent;//分享描述
            //创建多媒体对象
            [urlMessage setThumbImage:[UIImage imageNamed:@"有样icon1024"]];
            NSString *kLinkURL = model.videoPath;
            
            //        WXVideoObject *video = [WXVideoObject object];
            //        video.videoUrl = [NSString stringWithFormat:@"%@/#/playVideo?url=%@",App_JAIOXUYE_BASE_URL,kLinkURL];//分享链接
            //
            //        //完成发送对象实例
            //        urlMessage.mediaObject = video;
            //        sendReq.message = urlMessage;
            
            WXWebpageObject *webObj = [WXWebpageObject object];
            webObj.webpageUrl =  [NSString stringWithFormat:@"%@/#/playVideo?videoId=%@",App_JAIOXUYE_BASE_URL,model.vid];//分享链接
            //        WXVideoObject *video = [WXVideoObject object];
            //        video.videoUrl = [data objectForKey:@"shareUrl"];//分享链接
            
            //完成发送对象实例
            urlMessage.mediaObject = webObj;
            sendReq.message = urlMessage;
            
            //
            //发送分享信息
            [WXApi sendReq:sendReq];
        }
        
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
}
#pragma mark -  去跟拍
- (void)clickFlowingAction:(UIButton *)btn withCell:(FZPlayVideoTableViewCell *)cell{
    NSLog(@"%s",__func__);
     ShortVideoModel *model = cell.model;
    FZFlowingViewController *vc = [[FZFlowingViewController alloc]init];
 
    UINavigationController *MineNav =[[UINavigationController alloc]initWithRootViewController:vc];
       vc.videoFatherId = model.vid;
    [self presentViewController:MineNav animated:YES completion:nil];
    
    
    
}
#pragma maek 去点赞
- (void)clicLlickAction:(UIButton *)btn withCell:(FZPlayVideoTableViewCell *)cell{
    NSLog(@"%s",__func__);
}
#pragma maek 去点赞
- (void)createAnimation:(UITapGestureRecognizer*)recognizer withCell:(FZPlayVideoTableViewCell *)cell{
    NSLog(@"%s",__func__);
    recognizer.delegate = self;
//     [[FZShortVideolikeAnimation shareInstance] createAnimationWithTap:recognizer];
}
#pragma maek 去评论
- (void)clickCommentAction:(UIButton *)btn withCell:(FZPlayVideoTableViewCell *)cell{
   
    NSMutableDictionary *parm = [NSMutableDictionary new];
    ShortVideoModel *model = cell.model;
    [parm setObject:model.vid forKey:@"targetId"];
    [parm setObject:@"1" forKey:@"targetType"];
    [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
       view = [LTInputAccessoryView new];
       [view showBlock:^(NSString *contentStr) {
            [parm setObject:contentStr forKey:@"discussContent"];
           [FZNetworkingManager requestLittleAntMethod:@"saveDiscussInfo" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
                     NSLog(@"%@",contentStr);
               if (success == YES) {
                   [MBProgressHUD showSuccess:@"评论成功" toView:self.view ];
                   [[NSNotificationCenter defaultCenter ] postNotificationName:@"isFollow" object:nil];
               }
           }];
           
    }];

}
#pragma mark 关注用户
-(void)enterLoginView{
    /// 加载下一页数据
    [self.urls removeAllObjects];

    [self requestData];
    self.player.assetURLs = self.urls;
    [self.tableView reloadData];
}
//-(void)dismm{
//    [self dismissViewControllerAnimated:YES  completion:nil];
//}
//分享成功
-(void)SendMessageToWXResp{
    
    [MBProgressHUD showSuccess:@"分享成功" toView:self.view];
}
- (void)setupHTTPCache
{
    [KTVHTTPCache logSetConsoleLogEnable:YES];
    NSError * error;
    [KTVHTTPCache proxyStart:&error];
    if (error) {
        NSLog(@"Proxy Start Failure, %@", error);
    } else {
        NSLog(@"Proxy Start Success");
    }
    [KTVHTTPCache tokenSetURLFilter:^NSURL * (NSURL * URL) {
        NSLog(@"URL Filter reviced URL : %@", URL);
        return URL;
    }];
    [KTVHTTPCache downloadSetUnsupportContentTypeFilter:^BOOL(NSURL * URL, NSString * contentType) {
        NSLog(@"Unsupport Content-Type Filter reviced URL : %@, %@", URL, contentType);
        return NO;
    }];
}
-(UIImageView *)yindaoImage{
    if (!_yindaoImage) {
        _yindaoImage = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _yindaoImage.image = [UIImage imageNamed:@"操作手势"];
    UISwipeGestureRecognizer *    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [_yindaoImage addGestureRecognizer:recognizer];
    }
    return _yindaoImage;
}
-(BOOL) isFileExist:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
    return result;
}
-(void)clearSuccessAction{
        [self setupHTTPCache];
}
- (void)viewDidLoad {
    [super viewDidLoad];
       [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setupHTTPCache];
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearSuccessAction) name:@"clearSuccess" object:nil];
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterLoginView) name:@"hahaha" object:nil];
//           [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismm) name:@"dismm" object:nil];
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SendMessageToWXResp) name:@"SendMessageToWXResp" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.backBtn];
    self.fd_prefersNavigationBarHidden = YES;
    [self requestData];
    /// playerManager
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
//    KSMediaPlayerManager *playerManager = [[KSMediaPlayerManager alloc] init];
//    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];
    
    /// player,tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:100];
    self.player.assetURLs = self.urls;
    self.player.disableGestureTypes = ZFPlayerDisableGestureTypesDoubleTap | ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesPinch;
    self.player.controlView = self.controlView;
    self.player.allowOrentitaionRotation = NO;

    self.player.WWANAutoPlay = YES;
    self.player.shouldAutoPlay = YES;
    /// 1.0是完全消失时候
    self.player.playerDisapperaPercent = 1;
    
    @weakify(self)
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player.currentPlayerManager replay];
    };
    // 设置APP引导页
    if ([NSUSERGET(BOOLFORKEY) isEqualToString:@"1"]) {
         [self.view addSubview:self.yindaoImage];
        [self.view bringSubviewToFront:self.yindaoImage];
        [self.player stop];
    }else{
        
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.yindaoImage.hidden = YES;
    [self.yindaoImage removeFromSuperview];
    self.yindaoImage = nil;
      NSUSERSET(@"10", BOOLFORKEY);
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)tap{
      self.yindaoImage.hidden = YES;
    [self.yindaoImage removeFromSuperview];
    self.yindaoImage = nil;

    [self.player playTheNext];
    
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews]; 
    self.backBtn.frame = CGRectMake(10, 10, 36, 36);
}
- (void)requestData {
    
    for (ShortVideoModel *model in self.dataArray) {
        NSURL *url = [NSURL URLWithString:model.videoPath];
        NSURL * proxyURL = [KTVHTTPCache proxyURLWithOriginalURL:url];
        [self.urls addObject:proxyURL];
    }
    [self.tableView.mj_header endRefreshing];
}
- (void)playTheIndex:(NSInteger)index {
    @weakify(self)
    /// 指定到某一行播放
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    }];
    /// 如果是最后一行，去请求新数据
    if (index == self.dataArray.count-1) {
          [[NSNotificationCenter defaultCenter] postNotificationName:NotificationIsLikeShortVideo object:nil];
//        /// 加载下一页数据
        if (self.pageNumber  == 10000) {
            [self requMoreDat];
            self.player.assetURLs = self.urls;
            [self.tableView reloadData];
        }

    }
}
-(void)requMoreDat{

        NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
        [parm setObject:@(++self.index) forKey:@"pageNo"];
        [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
        [FZNetworkingManager requestLittleAntMethod:@"getArticleRecommenLittleVideoList" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
            [self.dataSoure removeAllObjects];
            if (success == YES) {
                [[response objectForKey:@"response"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ShortVideoModel *mdoel = [[ShortVideoModel alloc]initWithDictionary:obj error:nil];
                    [self.dataSoure addObject:mdoel];
                }];
                [self.dataArray addObjectsFromArray:self.dataSoure];
                [self.urls removeAllObjects];
                for (ShortVideoModel *model in self.dataArray) {
                    NSURL *url = [NSURL URLWithString:model.videoPath];
                    NSURL * proxyURL = [KTVHTTPCache proxyURLWithOriginalURL:url];
                    [self.urls addObject:proxyURL];
                }

                self.player.assetURLs = self.urls;
                [self.tableView reloadData];

                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationIsLikeShortVideo object:nil];

            }
        }];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    FZPlayVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    FZPlayVideoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FZPlayVideoTableViewCell" owner:nil options:nil].firstObject;
    }
    cell.model = self.dataArray[indexPath.row];
    ShortVideoModel *model =self.dataArray[indexPath.row];
    cell.model = model;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}
#pragma mark - ZFTableViewCellDelegate

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}

#pragma mark - private method

- (void)backClick:(UIButton *)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    if (view) {
        [view close];
    }
}

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop];
    [self.controlView resetControlView];
    
    ShortVideoModel *data = self.dataArray[indexPath.row];
    if ([data.width integerValue] > [data.height integerValue]) {
        
         [self.player.currentPlayerManager setScalingMode:ZFPlayerScalingModeNone];
    }else{
          [self.player.currentPlayerManager setScalingMode:ZFPlayerScalingModeAspectFill];
        
    }
//    [self.controlView showCoverViewWithUrl:data.coverPath];
    self.playTheIndex = indexPath;
    //播放量
    NSMutableDictionary *pp = [NSMutableDictionary new];
    [pp setObject:data.vid forKey:@"videoId"];
    [FZNetworkingManager requestLittleAntMethod:@"addVideoReadCount" parameters:pp requestHandler:^(BOOL success, id  _Nullable response) {
        
        NSLog(@"调用次数");
    }];
}

#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.pagingEnabled = YES;
//        [_tableView registerClass:[ZFDouYinCell class] forCellReuseIdentifier:kIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:@"FZPlayVideoTableViewCell" bundle:nil] forCellReuseIdentifier:kIdentifier];
        _tableView.backgroundColor = [UIColor lightGrayColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.frame = self.view.bounds;
        _tableView.rowHeight = _tableView.frame.size.height;
        
        /// 停止的时候找出最合适的播放
        @weakify(self)
        _tableView.zf_scrollViewDidStopScrollCallback = ^(NSIndexPath * _Nonnull indexPath) {
            @strongify(self)
            if (indexPath.row == self.dataArray.count-1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationIsLikeShortVideo object:nil];
//                /// 加载下一页数据
                if (self.pageNumber  == 10000) {
                    [self requMoreDat];
                    self.player.assetURLs = self.urls;
                    [self.tableView reloadData];
                }
            }
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        };
    }
    return _tableView;
}

- (ZFDouYinControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFDouYinControlView new];
        
    }
    return _controlView;
}


- (NSMutableArray *)urls {
    if (!_urls) {
        _urls = @[].mutableCopy;
    }
    return _urls;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"xgback"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
-(NSMutableArray *)discussInfoArray{
    if (!_discussInfoArray) {
        
        _discussInfoArray = [[NSMutableArray alloc]init];
    }
    return _discussInfoArray;
}

@end
