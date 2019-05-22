//
//  FZBaseWebViewController.m
//  FZBaseLib
//
//  Created by Mac on 2018/7/27.
//  Copyright © 2018年 FZ. All rights reserved.
//

#import "FZBaseWebViewController.h"
#import <Masonry.h>
#import <MJRefresh.h>
#import <TZImagePickerController.h>
#import <WXApi.h>
#import "ShareView.h"
#import "ZFDouYinViewController.h"
#import "WebviewProgressLine.h"
#import <IQKeyboardManager.h>
#import "AFNetworking.h"
#import "AFURLResponseSerialization.h"
#import "HVideoViewController.h"
#import "TOCropViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <IDMPBConstants.h>
#import <IDMPhotoBrowser.h>
#import "FZPersonalCenterViewController.h"
@interface FZBaseWebViewController ()<UIWebViewDelegate,TZImagePickerControllerDelegate,IDMPhotoBrowserDelegate>{
         HVideoViewController *ctrl;
        ZFDouYinViewController *vc;
     MPMoviePlayerViewController *mPMoviePlayerViewController;
}
@property(nonatomic,strong)WebviewProgressLine *progressLine;
@property(nonatomic,strong)UIButton *moreButton;
@property(nonatomic,strong)NSString *editorInTopic;
@property (nonatomic, strong) NSMutableArray  *dataArray;
@end

@implementation FZBaseWebViewController
{
    NSString *callBackId;
}
//-(void) viewDidDisappear:(BOOL)animated
//{
//
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
//
//}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self dealUrl];
    [self configUI];
    [self loadWebView];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;}


- (void)goBackAction
{
    
    if ([self.editorInTopic isEqualToString:@"editorInTopic"]) {
        
        [self responseStingToWeb:@"editorInTopic"];
        self.editorInTopic = @"";
    }else{
        // 在这里增加返回按钮的自定义动作
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}
#pragma mark - 私有方法

//UI
-(void)configUI{

    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
//    self.webView.scrollView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
//        [self loadWebView];
//    }];
        [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).mas_equalTo(1);
        make.size.equalTo(self.view);
        make.left.equalTo(self.view);
    }];
    
 
    if (self.isNeedProgress == YES) {
        self.progressLine = [[WebviewProgressLine alloc]init];
        self.progressLine.lineColor = [UIColor colorWithHexString:@"5091fe"];
        self.progressLine.fullWidth = self.view.frame.size.width;
        [self.view addSubview:self.progressLine];
        //[self.view bringSubviewToFront:self.progressLine];
        [self.progressLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).offset(0);
            make.right.equalTo(self.view);
            make.height.mas_equalTo(2);
            make.left.equalTo(self.view);
        }];
    }

    
    [self configNav];
}

-(void)configNav{
    if (self.isHiddenShared)
    {
        return;
    }
    self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreButton.frame = CGRectMake(0, 2, 40, 40);
    [self.moreButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.moreButton setImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateNormal];
    [self.moreButton addTarget:self action: @selector(moreButtonClick) forControlEvents: UIControlEventTouchUpInside];
    self.moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.moreButton.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    UIBarButtonItem *moreBtnItem = [[UIBarButtonItem alloc]initWithCustomView:self.moreButton];
    self.navigationItem.rightBarButtonItem = moreBtnItem;
}

//下拉刷新方法
-(void)headerRefreshMethod{
    [self loadWebView];
}

//右上角。。。click
-(void)moreButtonClick{
    
}

//组url
-(void)dealUrl{
    //拼接url
    if (!self.isDirectUrl) {
        if ([_hostUrl rangeOfString:@"access_user"].location == NSNotFound  && [_hostUrl rangeOfString:@"?"].location == NSNotFound) {
            _hostUrl = [_hostUrl stringByAppendingString:[NSString stringWithFormat:@"?access_user=%@",[FZUserInformation shareInstance].userModel.uid]];
        }
        if ([_hostUrl rangeOfString:@"access_user"].location == NSNotFound  && [_hostUrl rangeOfString:@"?"].location != NSNotFound) {
            _hostUrl = [_hostUrl stringByAppendingString:[NSString stringWithFormat:@"&access_user=%@",[FZUserInformation shareInstance].userModel.uid]];
        }
        _hostUrl = [_hostUrl stringByAppendingString:@"&agent=ExcoordMessenger"];
        _hostUrl = [_hostUrl stringByAppendingString:[NSString stringWithFormat:@"&login_user=%@",[FZUserInformation shareInstance].userModel.uid]];
    }

    NSString *encodedURLString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)_hostUrl,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
    _hostUrl=encodedURLString;
}

- (NSString *)javaScriptTextFromTxtFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JavaScript" ofType:@"txt"];
    if (nil == path || 0 == [path length])
    {
        NSLog(@"cannot find path, path is %@", path);
        return nil;
    }
    NSString *jsString = [NSString string];
    NSError *error = nil;
    jsString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"error is %@", error.description);
    }
    jsString = [jsString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsString = [jsString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    jsString = [jsString stringByReplacingOccurrencesOfString:@" " withString:@""];
    jsString = [NSString stringWithFormat:@"var phone={%@}", jsString];
    return jsString;
}

- (void)injectionJavaScript:(UIWebView *)webView withJSString:(NSString *)jsString;
{
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var script = document.createElement('script');""script.type = 'text/javascript';""script.text = \"%@\";""document.getElementsByTagName('head')[0].appendChild(script);", jsString]];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
}


#pragma mark - 公开方法
-(void)loadWebView{
    NSURL * webURL = [NSURL URLWithString:_hostUrl];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:webURL];
    [self.webView loadRequest:urlRequest];
}


#pragma mark - webView delegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *absoluteURL = request.URL;
    NSString *requestString=absoluteURL.absoluteString;
    
    if ([requestString hasPrefix:@"https://itunes.apple.com"])
    {
        //跳转到appStroe
        [[UIApplication sharedApplication] openURL:absoluteURL options:[NSDictionary new] completionHandler:nil];
        return NO;
    }else if ([requestString hasPrefix:@"myweb:showLoadingClick"])
    {
        return NO;
    } else if ([absoluteURL.absoluteString hasPrefix:@"alipay://"]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:absoluteURL.absoluteString] options:nil completionHandler:nil];
        return NO;
    } else if ([absoluteURL.absoluteString hasPrefix:@"weixin://wap/pay?"]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:absoluteURL.absoluteString] options:nil completionHandler:nil];
        return NO;
    }
    
    else if ([requestString hasPrefix:@"myweb:callHandler"]){
        NSString *subUrl = [requestString substringFromIndex:@"myweb:callHandler:".length];
        subUrl = [subUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *jsonData = [subUrl dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData           options:NSJSONReadingMutableContainers error:&err];
        if(err) {
            NSLog(@"json解析失败：%@",err);
            return NO;
        }else{
            NSString * method = [dic objectForKey:@"method"];
            NSLog(@"webMethod:%@",method);
            
            if ([dic objectForKey:@"callbackId"]) {
                callBackId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"callbackId"]];
            }
            
            [self callhanderBymethod:method handlerData:dic];
           
            if ([method isEqualToString:@"openNewPage"])
            {
                   NSString *sss   =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
                [self callHandler_openNewPageWithData:dic];
         
            }
            if ([method isEqualToString:@"playArticleVideo"])
            {
                [self callHandler_playArticleVideoWithData:dic];
            }
            if ([method isEqualToString:@"perfectUserInfo"])
            {
                [self callHandler_perfectUserInfo:dic];
            }
            if ([method isEqualToString:@"playVideo"])
            {
                [self callHandler_playVideo:dic];
            }
            if ([method isEqualToString:@"finish"])
            {
                [self callHandler_finish:dic];
            }
            if ([method isEqualToString:@"shareWechat"])
            {
                [self callHandler_shareWechat:dic];
            }
            if ([method isEqualToString:@"selectImages"])
            {
                [self callHandler_selectImages:dic];
            }
            if ([method isEqualToString:@"selFilesSuccess"])
            {
                [self callHandler_selFilesSuccess:dic];
            }
            if ([method isEqualToString:@"toTakePhoto"])
            {
                [self callHandler_toTakePhoto:dic];
            }
            if ([method isEqualToString:@"showPhoto"])
            {
                [self callHandler_showPhoto:dic];
            }
            
            if ([method isEqualToString:@"selectedImage"])
            {
                [self callHandler_selectedImage:dic];
            }
            if ([method isEqualToString:@"moreSelectedImage"])
            {
                [self callHandler_moreSelectedImage:dic];
            }
            if ([method isEqualToString:@"printDoc"])
            {
                [self callHandler_printDoc:dic];
            }
            if ([method isEqualToString:@"editorInTopic"])
            {
                self.editorInTopic = @"editorInTopic";
            }
            
            if ([method isEqualToString:@"playChatVideo"])
            {
                NSString *playUrl = [dic objectForKey:@"playUrl"];
                mPMoviePlayerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:playUrl]];
                mPMoviePlayerViewController.view.frame = self.view.bounds;
                [self presentViewController:mPMoviePlayerViewController animated:YES completion:^{
                }];
               
            }
            if ([method isEqualToString:@"toUserpage"])
            {
                [self callHandler_toUserpage:dic];
            }
            
            if ([method isEqualToString:@"selectPictures"])
            {
                [self callHandler_selectPictures];
            }
            if ([method isEqualToString:@"showImage"])
            {
                [self callHandler_showImage];
            }
            if ([method isEqualToString:@"setShareAble"])
            {
                [self callHandler_setShareAble];
            }
            if ([method isEqualToString:@"setRefreshAble"])
            {
                [self callHandler_setRefreshAble];
            }
            if ([method isEqualToString:@"selectUser"]){
                
            }
            
            if ([method isEqualToString:@"selectGroup"]) {
                
            }
            if ([method isEqualToString:@"finishForExecute"]) {
               
            }if ([method isEqualToString:@"finishForRefresh"]) {
                
                [self goBackAction];
                if (self.finishForRefresh) {
                    self.finishForRefresh(1);
                }
//                [self loadWebView];
              
                
            }if ([method isEqualToString:@"isLocationServiceOpened"]) {
              
            }if ([method isEqualToString:@"singleChoice"]){
               
                
            }if ([method isEqualToString:@"shortAnswer"]){
               
                
            }if ([method isEqualToString:@"trueOrFalse"]){
               
                
            }if ([method isEqualToString:@"multipleChoice"]){
               
                
            }
            if ([method isEqualToString:@"singleChoiceInCloud"]){
              
                
            }
            if ([method isEqualToString:@"shortAnswerInCloud"]){
              
                
            }
            if ([method isEqualToString:@"trueOrFalseInCloud"]){
               
                
            }
            if ([method isEqualToString:@"multipleChoiceInCloud"]){
               
                
            }
            if ([method isEqualToString:@"useQuestion"]) {
              
                
            }if ([method isEqualToString:@"goBackWeb"]) {
               
                
            }if ([method isEqualToString:@"pushSubjects"]) {
                [self callHandler_pushSubjectsWithData:dic];
                
            }if ([method isEqualToString:@"arrangementWork"]) {
                
                
            }if ([method isEqualToString:@"callBackSubjectsId"]) {
              
                
            }if ([method isEqualToString:@"saveFile"]) {
               
            }if ([method isEqualToString:@"toGroupChat"]) {
              
            }if ([method isEqualToString:@"viewGroupInformation"]) {
               
            }if ([method isEqualToString:@"updateChatGroupName"]) {
               
            }if ([method isEqualToString:@"addGroupPerson"]) {
                
            }if ([method isEqualToString:@"delGroupPerson"]) {
               
            }if ([method isEqualToString:@"delChatGroupMember"]) {
                
            }if ([method isEqualToString:@"leaveRegist"]) {
               //放弃注册
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }if ([method isEqualToString:@"finishRegist"]) {
               //完成注册信息
                NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
                [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"uid"];
                [FZNetworkingManager requestLittleAntMethod:@"getLittleVideoUserById" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
                    NSLog(@"");
                    if (success == YES) {
                        NSDictionary *userInfoDic=[response objectForKey:@"response"];
                        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
                        [userDef setObject:userInfoDic forKey:@"userInfo"];
                        [userDef synchronize];
                        [userDef setObject:@"1" forKey:@"UserState"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUserLoginCount object:nil];
                    }
                }];
            }
            if ([method isEqualToString:@"end"]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
        return NO;
    }else if ([requestString hasPrefix:@"myweb:playVideoJSONClick"]){
        
        return YES;
    }else if ([requestString hasPrefix:@"myweb:playVideoClick"]){
        
        return YES;
    }else if ([requestString hasPrefix:@"myweb:playVideoMClick"]){
        
        return YES;
    }else if ([requestString hasPrefix:@"myweb:voiceClick"]){
        
        return YES;
    }else if ([requestString hasPrefix:@"myweb:showPdfClick"]){
        
        return YES;
    }else if ([requestString hasPrefix:@"myweb:finishForNewPageClick"]){
        
        return YES;
    }else if ([requestString hasPrefix:@"myweb:teacherJoinClassClick"]){
        
        return YES;
    }else if ([requestString hasPrefix:@"myweb:teacherJoinClassClick"]){
        
        return YES;
    }
    return YES;
}
- (void)dismissMoviePlayerViewControllerAnimated{
    mPMoviePlayerViewController = nil;
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
//    [self.progressLine startLoadingAnimation];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.progressLine startLoadingAnimation];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    [self.progressLine endLoadingAnimation];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.progressLine endLoadingAnimation];
    [self.webView.scrollView.mj_header endRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),         dispatch_get_main_queue(), ^{
        NSString *titleString = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        NSString*title = [titleString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (title && [title length] > 0)
        {
            self.title = title;
        }    });

    
    //注入js
    NSString *jsString = [self javaScriptTextFromTxtFile];
    [self injectionJavaScript:webView withJSString:jsString];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_webView.scrollView.mj_header endRefreshing];
     [self.progressLine endLoadingAnimation];
//    [self.progressLine endLoadingAnimation];
//       [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - baseDeal Callhander

//重新该方法实现callHandler对应的具体操作
-(void)callhanderBymethod:(NSString *)method handlerData:(NSDictionary *)data{
    
}


-(void)callHandler_openNewPageWithData:(NSDictionary *)data{
    if (_isAdd_openNewPage) {
        if ([self.delegate respondsToSelector:@selector(fzwebViewControllCallHandlerWithMethod:data:)]) {
            [self.delegate fzwebViewControllCallHandlerWithMethod:@"openNewPage" data:data];
        }
    }else{
      

        FZBaseWebViewController *webVC=[[FZBaseWebViewController alloc]init];
        webVC.hostUrl=[NSString stringWithFormat:@"%@",[data objectForKey:@"url"]];
//          NSString *title= [webVC.webView stringByEvaluatingJavaScriptFromString:@"document.title"];we
        webVC.delegate= _delegate;
        webVC.isNeedProgress = YES;
//        webVC.title =self.title;
        webVC.finishForRefresh = ^(int number) {
            if (number == 1) {
                 [self loadWebView];
            }
        };
        [self.navigationController pushViewController:webVC animated:YES];
    }
}
-(void)callHandler_playArticleVideoWithData:(NSDictionary *)data{

        if ([self.delegate respondsToSelector:@selector(fzwebViewControllCallHandlerWithMethod:data:)]) {
            [self.delegate fzwebViewControllCallHandlerWithMethod:@"playArticleVideo" data:data];
        }

}
-(void)callHandler_perfectUserInfo:(NSDictionary *)data{
    
    if ([self.delegate respondsToSelector:@selector(fzwebViewControllCallHandlerWithMethod:data:)]) {
        [self.delegate fzwebViewControllCallHandlerWithMethod:@"perfectUserInfo" data:data];
    }
    
}
//播放视频
-(void)callHandler_playVideo:(NSDictionary *)data{
    
//    if ([self.delegate respondsToSelector:@selector(fzwebViewControllCallHandlerWithMethod:data:)]) {
//        [self.delegate fzwebViewControllCallHandlerWithMethod:@"playVideo" data:data];
//    }
    //播放视频
    [self.dataArray removeAllObjects];
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
-(void)callHandler_selectImages:(NSDictionary *)data{
    
//    if ([self.delegate respondsToSelector:@selector(fzwebViewControllCallHandlerWithMethod:data:)]) {
//        [self.delegate fzwebViewControllCallHandlerWithMethod:@"selectImages" data:data];
//    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.allowPickingVideo = NO;//不允许选择视频
    imagePickerVc.maxImagesCount = 1;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [[FZNetworkingManager sharedUtil] uploadImageFiles:@[UIImageJPEGRepresentation(photos[0], 1)] complete:^(BOOL success, NSString *fileURLString, NSError *error) {
            //                [self->parm setObject:fileURLString forKey:@"firstUrl"];
            //                dispatch_group_leave(group);
//            [self cal]
            NSString *json = [NSString stringWithFormat:@"%@?%@",fileURLString,@"file"];
            [self responseStingToWeb:json];
            
        }];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
-(void)callHandler_selFilesSuccess:(NSDictionary *)data{
    
    //    if ([self.delegate respondsToSelector:@selector(fzwebViewControllCallHandlerWithMethod:data:)]) {
    //        [self.delegate fzwebViewControllCallHandlerWithMethod:@"selectImages" data:data];
    //    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.maxImagesCount = 1;
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.allowTakeVideo = NO;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [[FZNetworkingManager sharedUtil] uploadImageFiles:@[UIImageJPEGRepresentation(photos[0], 1)] complete:^(BOOL success, NSString *fileURLString, NSError *error) {
            //                [self->parm setObject:fileURLString forKey:@"firstUrl"];
            //                dispatch_group_leave(group);
            //            [self cal]
            NSString *json = [NSString stringWithFormat:@"%@?type=%@",fileURLString,@"1"];
            [self responseStingToWeb:json];
            
        }];
    }];
    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
        [self getAsset:asset resultHandler:^(NSURL *url) {
            
            //            weakself.videoFileURL = url.absoluteString;  可以把它转成字符串 接收出来  如果NSURL 可能失败 因该是苹果内部坐了处理
            NSLog(@"%@",url);
            //    UIImage *image = [self getVideoPreViewImage:self.saveVideoUrl];
            NSData *data = [NSData dataWithContentsOfFile:url];
            __weak typeof(self)weakSelf = self;
            [SVProgressHUD showGif];
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            [manager.requestSerializer setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
            
            [manager POST:UPLOAD_FILE_BASE_URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                [formData appendPartWithFileData:data name:@"file" fileName:@"filename.mp4" mimeType:@"video/mp4"];
                
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
                NSLog(@"上传进度: %f", uploadProgress.fractionCompleted);
                
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                [SVProgressHUD hidGif];
                NSLog(@"responseString is %@",responseString);
                if (responseString && [responseString length] > 0)
                {
                    if (coverImage) {
                        [[FZNetworkingManager sharedUtil] uploadImageFiles:@[UIImageJPEGRepresentation(coverImage, 1)] complete:^(BOOL success, NSString *fileURLString, NSError *error) {
                            if (fileURLString.length > 0) {
                                NSString *json = [NSString stringWithFormat:@"%@?type=%@&firstImage=%@",responseString,@"2",fileURLString];
                                [weakSelf responseStingToWeb:json];
                            }
                        }];
                    }else{
                        NSString *json = [NSString stringWithFormat:@"%@?type=%@",responseString,@"2"];
                        [self responseStingToWeb:json];
                    }
                }
                else
                {
                    NSErrorDomain domain = @"返回的文件地址链接为空";
                    NSError *error = [[NSError alloc] initWithDomain:domain code:1100 userInfo:nil];
                    NSLog(@"error is %@", error.description);
                    //            [FZShowHUD showDefaultAlertText:@"视频发送失败"];
                }
            }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      NSLog(@"error is %@", error.description);
                         [SVProgressHUD hidGif];
                      //          [FZShowHUD showDefaultAlertText:@"视频发送失败"];
                  }];
        }];
    }];

    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

-(void)callHandler_selectedImage:(NSDictionary *)data{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.maxImagesCount = 1;
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        PHAsset *aseet = assets[0];
        if (aseet.mediaType == 2) {
            [self getAsset:assets[0] resultHandler:^(NSURL *url) {
                UIImage *image = [self getVideoPreViewImage:url];
                [self sendSelectVideo:url andCover:image];
            }];
        }else{
            [[FZNetworkingManager sharedUtil] uploadImageFiles:@[UIImageJPEGRepresentation(photos[0], 1)] complete:^(BOOL success, NSString *fileURLString, NSError *error) {
                
                NSString *json = [NSString stringWithFormat:@"%@?type=%@",fileURLString,@"1"];
                [self responseStingToWeb:json];
            }];
        }

    }];
    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
        [self getAsset:asset resultHandler:^(NSURL *url) {
            
            //            weakself.videoFileURL = url.absoluteString;  可以把它转成字符串 接收出来  如果NSURL 可能失败 因该是苹果内部坐了处理
            NSLog(@"%@",url);
            //    UIImage *image = [self getVideoPreViewImage:self.saveVideoUrl];
            [self sendSelectVideo:url andCover:coverImage];
        }];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}
//选多张图片
-(void)callHandler_moreSelectedImage:(NSDictionary *)data{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
//    imagePickerVc.maxImagesCount = [[data objectForKey:@"count"] integerValue];
    if ([[data objectForKey:@"count"] integerValue] == 0) {
//        [MBProgressHUD showSuccess:@"最多添加9个图片或视频" toView:self.view];
        imagePickerVc.allowTakePicture = NO;
        imagePickerVc.allowTakeVideo = NO;
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowPickingImage = NO;
    }else{
       imagePickerVc.maxImagesCount = [[data objectForKey:@"count"] integerValue];
    }
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        PHAsset *aseet = assets[0];
        if (aseet.mediaType == 2) {
            [self getAsset:assets[0] resultHandler:^(NSURL *url) {
                UIImage *image = [self getVideoPreViewImage:url];
                [self sendSelectVideo:url andCover:image];
            }];
        }else{
            
            NSMutableArray * dataImgArray = [NSMutableArray new];
            for (UIImage * img in photos)
            {
                NSData * data = UIImageJPEGRepresentation(img, 0.5);
                [dataImgArray addObject:data];
            }
            NSMutableArray *imageArray = [NSMutableArray new];
            [[FZNetworkingManager sharedUtil] uploadImageFiles:[NSArray arrayWithArray:dataImgArray] complete:^(BOOL success, NSString *fileURLString, NSError *error) {
                NSArray *url = [fileURLString componentsSeparatedByString:@","];
                NSString *json;
                for (NSString *imagUrl in url) {
                    json = [NSString stringWithFormat:@"%@?type=%@",imagUrl,@"1"];
                    [imageArray addObject:json];
                }
                if (imageArray.count > 0) {
                    NSString *str = [imageArray componentsJoinedByString:@","];
                    [self responseStingToWeb:str];
                }

            }];
        }
        
    }];
    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
        [self getAsset:asset resultHandler:^(NSURL *url) {
            
            //            weakself.videoFileURL = url.absoluteString;  可以把它转成字符串 接收出来  如果NSURL 可能失败 因该是苹果内部坐了处理
            NSLog(@"%@",url);
            //    UIImage *image = [self getVideoPreViewImage:self.saveVideoUrl];
            [self sendSelectVideo:url andCover:coverImage];
        }];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}
-(void)sendSelectVideo:(NSURL *)url andCover:(UIImage *)coverImage{
    NSData *data = [NSData dataWithContentsOfFile:url];
    __weak typeof(self)weakSelf = self;
    [SVProgressHUD showGif];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:UPLOAD_FILE_BASE_URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:@"filename.mp4" mimeType:@"video/mp4"];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"上传进度: %f", uploadProgress.fractionCompleted);
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        [SVProgressHUD hidGif];
        NSLog(@"responseString is %@",responseString);
        if (responseString && [responseString length] > 0)
        {
                [SVProgressHUD hidGif];
            if (coverImage) {
                [[FZNetworkingManager sharedUtil] uploadImageFiles:@[UIImageJPEGRepresentation(coverImage, 1)] complete:^(BOOL success, NSString *fileURLString, NSError *error) {
                    if (fileURLString.length > 0) {
                        NSString *json = [NSString stringWithFormat:@"%@?type=%@?firstImage=%@",responseString,@"2",fileURLString];
                        [weakSelf responseStingToWeb:json];
                    }
                }];
            }else{
                    NSString *json = [NSString stringWithFormat:@"%@?type=%@",responseString,@"2"];
                    [self responseStingToWeb:json];
            }
            

            
            //                    NSString *json = [NSString stringWithFormat:@"%@?type=%@",responseString,@"2"];
            //                    [self responseStingToWeb:json];
        }
        else
        {
            NSErrorDomain domain = @"返回的文件地址链接为空";
            NSError *error = [[NSError alloc] initWithDomain:domain code:1100 userInfo:nil];
            NSLog(@"error is %@", error.description);
            //            [FZShowHUD showDefaultAlertText:@"视频发送失败"];
        }
    }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"error is %@", error.description);
              [SVProgressHUD hidGif];
              //          [FZShowHUD showDefaultAlertText:@"视频发送失败"];
          }];
}
-(void)callHandler_toTakePhoto:(NSDictionary *)data{
    
    __weak typeof(self)weakSelf = self;
    ctrl = [[NSBundle mainBundle] loadNibNamed:@"HVideoViewController" owner:nil options:nil].lastObject;
    ctrl.HSeconds = 10;//设置可录制最长时间
    ctrl.takeBlock = ^(id item,id message) {
        if ([item isKindOfClass:[NSString class]]) {
            //视频url
            //            UIImage *ima = [weakSelf getVideoPreViewImage:[NSURL URLWithString:item]];
            //            [self sendLibratyImageMessageWithImageData:UIImageJPEGRepresentation(ima, 0.5)];
            //            [weakSelf sendVideoMessage:item];
            if ([message isKindOfClass:[NSString class]]) {
                NSString *json = [NSString stringWithFormat:@"%@?type=%@",item,@"1"];
                [weakSelf responseStingToWeb:json];
            }
            if ([message isKindOfClass:[UIImage class]]) {
//                NSString *json = [NSString stringWithFormat:@"%@?type=%@",item,@"2"];
//                [self responseStingToWeb:json];
                [SVProgressHUD showGif];
                [mPMoviePlayerViewController.moviePlayer stop];;
                [[FZNetworkingManager sharedUtil] uploadImageFiles:@[UIImageJPEGRepresentation(message, 1)] complete:^(BOOL success, NSString *fileURLString, NSError *error) {
                    if (fileURLString.length > 0) {
                        NSString *json = [NSString stringWithFormat:@"%@?type=%@?firstImage=%@",item,@"2",fileURLString];
                        [weakSelf responseStingToWeb:json];
                    
                    }
                      [SVProgressHUD hidGif];
                }];
            }
            NSLog(@"ahahahahahah%@",item);
        } else {
            //            图片
            //            [weakSelf sendTakePhotoImage:(UIImage *)item];
            
        }
    };
    ctrl.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:ctrl animated:YES completion:nil];
    
    
    
}
//查看照片
-(void)callHandler_showPhoto:(NSDictionary *)data{
    NSString *imageUrlsString =[[NSString stringWithFormat:@"%@", [data objectForKey:@"photos"]] stringByReplacingOccurrencesOfString:@"webp"withString:@"jpg"];
    NSString *currentUrl = [[NSString stringWithFormat:@"%@", [data objectForKey:@"currentPhoto"]] stringByReplacingOccurrencesOfString:@"webp"withString:@"jpg"];
    NSArray * imageUrlArray = [imageUrlsString componentsSeparatedByString:@","];
    NSInteger currentIndex = [imageUrlArray indexOfObject:currentUrl];
    NSMutableArray *photos = [NSMutableArray new];
    for (NSString *url in imageUrlArray)
    {
        IDMPhoto * photo = [[IDMPhoto alloc]initWithURL:[NSURL URLWithString:url]];
        [photos addObject:photo];
    }
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos animatedFromView:self.view];
    browser.displayDoneButton = NO;
    browser.displayActionButton = YES;
    browser.displayCounterLabel = YES;
    browser.dismissOnTouch = YES;
    [browser setInitialPageIndex:currentIndex];
    [self presentViewController:browser animated:YES completion:nil];
}

-(void)callHandler_finish:(NSDictionary *)data{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)getAsset:(id)asset resultHandler:(void (^)(NSURL *url))resultHandler {
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        
        PHVideoRequestOptions* options = [[PHVideoRequestOptions alloc] init];
        
        options.version = PHVideoRequestOptionsVersionOriginal;
        
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        
        options.networkAccessAllowed = YES;
        
        [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
            
            AVURLAsset *videoAsset = (AVURLAsset*)avasset;
            
            resultHandler(videoAsset.URL);
            
        }];
        
    }
    
}
-(void)responseStingToWeb:(NSString *)responseSting{
    NSString *textJS = [NSString stringWithFormat:@"javascript:Bridge.cb.%@('%@')",callBackId,responseSting];
    [_webView stringByEvaluatingJavaScriptFromString:textJS];
}
-(void)callHandler_printDoc:(NSDictionary *)dic{
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *music = [[paths objectAtIndex:0] stringByAppendingPathComponent:[dic objectForKey:@"url"]];
//    [[FZNetworkingManager sharedUtil] downloadFileWithUrl:[dic objectForKey:@"url"] withSaveFilePath:music callbackToMainThread:YES complete:^(BOOL success, id response, NSError *error) {
//        NSLog(@"");
//    }];
    
     [SVProgressHUD showGif];
    WXFileObject *fileObject = [WXFileObject object];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"url"]]];
      [SVProgressHUD hidGif];
        fileObject.fileData = data;
    if (data.length>1024*1024*9.5) {
        [MBProgressHUD showSuccess:@"导出到微信内容大于10M，请分批导出" toView:self.view];
        return;
    }
    
        fileObject.fileExtension = @"pdf";
    
        WXMediaMessage *message2 = [WXMediaMessage message];
    
        message2.mediaObject = fileObject;
    
        message2.title = [NSString stringWithFormat:@"%@.pdf",[dic objectForKey:@"title"]];
    
//        message2.description = @"你的内容";
    
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    
        req.bText = NO;
    
        req.message = message2;
    
        req.scene = WXSceneSession;
    
        [WXApi sendReq:req];
    
}
-(void)callHandler_shareWechat:(NSDictionary *)data{
    
//    if ([self.delegate respondsToSelector:@selector(fzwebViewControllCallHandlerWithMethod:data:)]) {
//        [self.delegate fzwebViewControllCallHandlerWithMethod:@"shareWechat" data:data];
//    }
    
    BOOL hadInstalledWeixin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    NSMutableArray *titlearr     = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *imageArr     = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *typeArr     = [NSMutableArray arrayWithCapacity:5];
    [titlearr addObjectsFromArray:@[@"分享到微信", @"分享到微信朋友圈"]];
    [imageArr addObjectsFromArray:@[@"wechat",@"friend"]];
    [typeArr addObjectsFromArray:@[@(ShareTypeWechatSession), @(ShareTypeWechatTimeLine)]];
        [typeArr addObjectsFromArray:@[@(ShareTypeWechatSession), @(ShareTypeWechatTimeLine)]];
    ShareView *shareView = [[ShareView alloc] initWithShareHeadOprationWith:titlearr andImageArry:imageArr andProTitle:@"fenxiangdao"];
     shareView.proFont = 0;
    [shareView setBtnClick:^(NSInteger btnTag) {
        SendMessageToWXReq *req1 = [[SendMessageToWXReq alloc]init];

        // 是否是文档
        req1.bText =  NO;

        //    WXSceneSession  = 0,        /**< 聊天界面    */
        //    WXSceneTimeline = 1,        /**< 朋友圈      */
        //    WXSceneFavorite = 2,


        req1.scene =(int) btnTag;

        //创建分享内容对象
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = [data objectForKey:@"shareUserName"];//分享标题
        NSString *url = [data objectForKey:@"shareTitle"];
        if (url.length > 30) {
             urlMessage.description =[NSString stringWithFormat:@"%@...",[url substringToIndex:30]];//分享描述
        }else{
              urlMessage.description =url;//分享描述
        }
//        urlMessage.description =  [data objectForKey:@"shareTitle"];//分享描述
        
        [urlMessage setThumbImage:[UIImage imageNamed:@"有样icon1024"]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小

        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl =  [data objectForKey:@"shareUrl"];//分享链接
//        WXVideoObject *video = [WXVideoObject object];
//        video.videoUrl = [data objectForKey:@"shareUrl"];//分享链接

        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        req1.message = urlMessage;

        //发送分享信息
        [WXApi sendReq:req1];

    }];
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    
}
//课堂推送题目
-(void)callHandler_pushSubjectsWithData:(NSDictionary *)data{
//    NSString *ids=[NSString stringWithFormat:@"%@",[data objectForKey:@"ids"]];
//    [[FZClassSocketMgr shareInstance] commandSend_pushSubjecShowContentUrl:ids];
//    [MBProgressHUD defaultShowText:@"推送成功!"];
    
}

-(void)callHandler_toUserpage:(NSDictionary *)data{
    
    FZPersonalCenterViewController *vc = [[FZPersonalCenterViewController alloc]init];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:vc];
 
    NSDictionary *dd= [data objectForKey:@"user"];
    FZUserModel *model = [[FZUserModel alloc]initWithDictionary:dd error:nil];
    vc.userId = model.uid;
//    vc.userModel = model;
    if ([[FZUserInformation shareInstance].userModel.uid isEqualToString:model.uid]) {
        vc.isSelf=YES;
    }else{
        vc.isSelf=NO;
    }
    if (vc.userId.length > 0) {
        [self presentViewController:na animated:YES completion:^{
            
        }];
    }
    //    vc.higth = 64;

}
//点击图片
-(void)callHandler_selectPictures{
    
}

//展示图片
-(void)callHandler_showImage{
    
}

//是否允许分享
-(void)callHandler_setShareAble{
    
}

//是否允许刷新
-(void)callHandler_setRefreshAble{
    
//    [self loadWebView];
}



#pragma mark - 懒加载
-(UIWebView *)webView{
    if (!_webView) {
        _webView=[[UIWebView alloc]init];
    }
    return _webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 获取视频第一帧
- (UIImage*) getVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
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
@end
