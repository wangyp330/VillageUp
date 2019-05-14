//
//  FZRecognitionViewController.m
//  LittentAntShortVideo
//
//  Created by mac on 2018/8/2.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZRecognitionViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+help.h"
#import "UIView+ZFFrame.h"
#import "FZShowARClassView.h"
#import "FZARBookModel.h"
 #import <MediaPlayer/MediaPlayer.h>
#import "FZPlayARViewController.h"
#import "ShortVideoModel.h"
#import "FZScanViewController.h"
#import "FZMessageSocketMgr.h"
#import "FZBaseNavigationViewController.h"
#import <SVProgressHUD.h>
@interface FZRecognitionViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,FZShowARClassViewDelegate>{
    UIButton *recognitionBtn;
    FZPlayARViewController *view;
}

@property (nonatomic, assign) BOOL isReading;
@property (nonatomic,strong) UIView *viewPreview;
@property (nonatomic, strong) UIView *boxView;//扫描框
@property (nonatomic, strong) CALayer *scanLayer;//扫描线
@property (nonatomic, strong) AVCaptureSession *captureSession;//捕捉会话
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;//展示layer
@property (nonatomic, strong) NSTimer *timer;//定时器
@property (nonatomic, strong) NSTimer *recognitionTimer;//定时器
@property(nonatomic,strong)UIImage *signImage;
@property(nonatomic,strong)UILabel  *verbLabel;//提示框
@property(nonatomic,strong)FZShowARClassView *showARClassView;
@property(nonatomic,strong)NSArray *Videopath;
@property(nonatomic,strong)MPMoviePlayerController *mPMoviePlayerController;
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,assign)NSInteger totalTime;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign) NSInteger pageNo;
@property(nonatomic,strong) NSString  *imageID;
@property(nonatomic,strong) NSMutableArray  *tagList;


@property(nonatomic,strong) NSString  *tags;
@property(nonatomic,assign) NSInteger presentUnber;
@end

@implementation FZRecognitionViewController
#pragma mark 懒加载
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
    
}
-(NSMutableArray *)tagList{
    if (!_tagList) {
        _tagList = [NSMutableArray new];
    }
    return _tagList;
    
}
-(void)requestData:(NSString *)tags{
//    [self.dataSource removeAllObjects];
//    self.imageID = tags;
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:@(self.pageNo) forKey:@"pageNo"];
    [parm setObject:tags forKey:@"tags"];
    [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
    [FZNetworkingManager requestLittleAntMethod:@"getARRecommenLittleVideoList" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        if (self->_pageNo == 1) {
            [self.dataSource removeAllObjects];
        }
        NSLog(@"");

        if (success == YES) {
            [[response objectForKey:@"response"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ShortVideoModel *mdoel = [[ShortVideoModel alloc]initWithDictionary:obj error:nil];
                [self.dataSource addObject:mdoel];
            }];
         self->view.VideoArray = [NSArray arrayWithArray:self.dataSource];
                    self->view.uuid = self.uuid;
            if (self.presentUnber == 0) {

                if (self.presentedViewController== nil)
                {
                    [self presentViewController:self->view animated:YES completion:nil];
                    self.presentUnber = 1;
                }
            }
        }
    }];
}
-(void)addUseArLimit:(NSString *)tags{

     NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:tags forKey:@"targetId"];
    [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
    [FZNetworkingManager requestLittleAntMethod:@"addUseArLimit" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        NSLog(@"限制成功");
    }];
    
}
-(FZShowARClassView *)showARClassView{
    if (!_showARClassView) {
        _showARClassView = [[FZShowARClassView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-100, SCREEN_WIDTH, 100)];
        _showARClassView.FZShowARClassViewDelegate = self;
    }
    return _showARClassView;
}
//选择的课程
-(void)didSelectClass:(NSString *)videoPath{
    [self removeBtnPlayer];
    if ([[videoPath pathExtension] isEqualToString:@"mp4"] || [[videoPath pathExtension] isEqualToString:@"MP4"]) {
          [self playVideo:videoPath];
    }else{
        
        [self playerDoc:videoPath];
    }

}
-(void)playVideo:(NSString *)videoPath{
    
    if (!_mPMoviePlayerController) {
        _mPMoviePlayerController = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:videoPath]];
        [self.view addSubview:_mPMoviePlayerController.view];
        _mPMoviePlayerController.view.frame = CGRectMake(0, _viewPreview.bounds.size.height*0.2, SCREEN_WIDTH, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.4f);
        [_mPMoviePlayerController play];
        UIButton *removeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [removeBtn setImage:[UIImage imageNamed:@"xgback"] forState:(UIControlStateNormal)];
        [removeBtn addTarget:self action:@selector(removeBtnPlayer) forControlEvents:(UIControlEventTouchDown )];
        [_mPMoviePlayerController.view addSubview:removeBtn];
    }

}
-(void)playerDoc:(NSString *)filePath{
  
    if (!self.webView) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, _viewPreview.bounds.size.height*0.2, SCREEN_WIDTH, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.4f)];
        self.view = self.webView;
        NSURL *url = [NSURL URLWithString:filePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        UIButton *removeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [removeBtn setImage:[UIImage imageNamed:@"xgback"] forState:(UIControlStateNormal)];
        [removeBtn addTarget:self action:@selector(removeBtnPlayer) forControlEvents:(UIControlEventTouchDown)];
        [self.webView addSubview:removeBtn];
    }

}
-(void)removeBtnPlayer{
    if (_mPMoviePlayerController) {
        [_mPMoviePlayerController stop];
        [_mPMoviePlayerController.view removeFromSuperview];
        _mPMoviePlayerController = nil;
    }
    if (_webView) {
        [_webView removeFromSuperview];
         _webView = nil;
    }
}
- (void)dealloc {
    self.captureSession = nil;
    [self removeBtnPlayer];
    [_showARClassView removeFromSuperview];
    _showARClassView = nil;
        [[FZMessageSocketMgr shareInstance] closeMessageSocket];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopRunning];

     self->_verbLabel.text = @"将要识别的图片放入识别框内，点击屏幕开始识别";
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
    if ([[FZUserInformation shareInstance].userModel.vIP isEqualToString:@"1"]) {
        
    }else{
        [FZNetworkingManager requestLittleAntMethod:@"isUseArPass" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
            if (success == YES) {
                FZUserModel *model = [FZUserInformation shareInstance].userModel;
                NSLog(@"");
                int  aa = [[response objectForKey:@"isIosCheckVersion"] intValue];
                if (aa == 1) {
                    
                }else{
                    if ([model.vIP isEqualToString:@"0"]) {
                        NSString *cunt = [NSString stringWithFormat:@"%@",[response objectForKey:@"response"]];
                        [MBProgressHUD showSuccess:[NSString stringWithFormat:@"非会员可识别10张图片，剩余识别图片数%@张",cunt] toView:self.view];
                    }
                }
            }
        }];
    }

}
-(void)initRecognitionTime{
    self.totalTime = 0;
    _recognitionTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(SatrtRecognition) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_recognitionTimer forMode:NSRunLoopCommonModes];
    
}
//上传服务器识别
-(void)SatrtRecognition{
    self.totalTime ++;
    self.presentUnber = 0;
    if (self.totalTime > 5) {
        //停止
        [self stopRunning];
        self->_verbLabel.text = @"将要识别的图片放入识别框内，点击屏幕开始识别";
    }else{
        if (self.signImage) {
            
            @autoreleasepool{
                 UIImage *image = self.signImage;
                 image= [self ct_imageFromImage:image inRect:CGRectMake(_viewPreview.bounds.size.width * 0.20, _viewPreview.bounds.size.height*0.2, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.1f, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.1f)];
                NSData *data = UIImageJPEGRepresentation( image, 1);
                [FZNetworkingManager requestLittleARsearchImageFiles:@[data] parameters:nil complete:^(BOOL success, NSDictionary *parm, NSError *error) {
                    if (success == YES) {
                        self.Videopath = [[parm objectForKey:@"response"] objectForKey:@"image_ids"];
                        NSArray *arr = [[parm objectForKey:@"response"] objectForKey:@"tags"];
  
                        if (self.Videopath.count > 0) {
                            self.tags = [arr componentsJoinedByString:@","];
                            [self stopRunning];
                            [self requestARBook:self.Videopath[0]];
                            [self addUseArLimit:self.Videopath[0]];
                        }
                    }
                }];
            }
        }
    }

}
-(void)requestARBook:(NSString *)imageID{
    __weak typeof(self) weakSlf = self;
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:imageID forKey:@"targetId"];
    [SVProgressHUD showGif];
    [FZNetworkingManager requestLittleAntARMethod:@"getARBookItemByEasyARId" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
        
        NSLog(@"haha%@",response);
        if (success == YES) {
               [SVProgressHUD hidGif];
            if (![[response objectForKey:@"response"] isKindOfClass:[NSDictionary class]]) {
                [self stopRunning];
                  self->_verbLabel.text = @"将要识别的图片放入识别框内，点击屏幕开始识别";
                return ;
            }
            
            [self.tagList removeAllObjects];
            [[[response objectForKey:@"response"] objectForKey:@"tagList"] enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [self.tagList addObject:[dic objectForKey:@"content"]];
            }];
            self->view=nil;
            self->view = [[FZPlayARViewController alloc]init];
            self->view.dismBck = ^{
                if ([[FZUserInformation shareInstance].userModel.vIP isEqualToString:@"1"]) {
                    
                }else{
                    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
                    [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
                    [FZNetworkingManager requestLittleAntMethod:@"isUseArPass" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
                        if (success == YES) {
                            FZUserModel *model = [FZUserInformation shareInstance].userModel;
                            NSLog(@"");
                            int  aa = [[response objectForKey:@"isIosCheckVersion"] intValue];
                            if (aa == 1) {
                                
                            }else{
                                if ([model.vIP isEqualToString:@"0"]) {
                                    NSString *cunt = [NSString stringWithFormat:@"%@",[response objectForKey:@"response"]];
                                    [MBProgressHUD showSuccess:[NSString stringWithFormat:@"非会员可识别10张图片，剩余识别图片数%@张",cunt] toView:weakSlf.view];
                                }
                            }
                        }
                    }];
                } 
            };
            self->view .modalPresentationStyle = UIModalPresentationOverCurrentContext;
            if (![[NSString stringWithFormat:@"%@",[response objectForKey:@"response"]] isEqualToString:@"<null>"]) {
                self->view.dataArray = [[[response objectForKey:@"response"] objectForKey:@"video"] componentsSeparatedByString:@"," ];
                [self requestData:[self.tagList componentsJoinedByString:@","]];
            }
        }else{
                    [SVProgressHUD hidGif];
        }
    
        //停止

       
        self->_verbLabel.text = @"将要识别的图片放入识别框内，点击屏幕开始识别";
    }];
    
}


-(void)enterLoginView{

    self->_pageNo ++;
    [self requestData:[self.tagList componentsJoinedByString:@","]];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.uuid) {
        [[FZMessageSocketMgr shareInstance] closeMessageSocket];
        [[FZMessageSocketMgr shareInstance] open];
    }
    self.pageNo = 1;
    self.presentUnber = 0;
          [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterLoginView) name:NotificationIsLikeShortVideo object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initScanPreview];
    //判断权限
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (granted) {
                [self loadScanView];
            } else {
                NSString *title = @"请在iPhone的”设置-隐私-相机“选项中，允许App访问你的相机";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
            }
            
        });
    }];
//    [self initRecognitionTime];
    // Do any additional setup after loading the view.
}

- (void)initScanPreview {
    self.viewPreview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.viewPreview];
}

- (void)loadScanView {
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    //3.创建媒体数据输出流
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    //4.实例化捕捉会话
    _captureSession = [[AVCaptureSession alloc] init];
//    gao'zhi'liang'cai'ji
        [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    //4.1.将输入流添加到会话

    [_captureSession addInput:input];
    //4.2.将媒体输出流添加到会话中
    [_captureSession addOutput:output];
    //5.设置代理 在主线程里刷新
    
    [output setSampleBufferDelegate:self queue:dispatch_get_main_queue()];

    [output setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    //6.实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    //7.设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //8.设置图层的frame
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    //9.将图层添加到预览view的图层上
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    //10.设置扫描范围
//    output.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);
    //10.1.扫描框
    _boxView = [[UIView alloc] initWithFrame:CGRectMake(_viewPreview.bounds.size.width * 0.2, _viewPreview.bounds.size.height*0.2, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.4f, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.4f)];
    _boxView.layer.borderColor = [UIColor greenColor].CGColor;
    _boxView.layer.borderWidth = 1.0;
    
    [_viewPreview addSubview:_boxView];
    
    
    
    _verbLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _boxView.y+(_viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.4f)+30, SCREEN_WIDTH, 30)];
    _verbLabel.backgroundColor = [UIColor clearColor];
    _verbLabel.textAlignment = NSTextAlignmentCenter;
    _verbLabel.textColor = [UIColor whiteColor];
    _verbLabel.font = [UIFont systemFontOfSize:13];
    _verbLabel.text = @"将要识别的图片放入识别框内，点击屏幕开始识别";
    [_viewPreview addSubview:_verbLabel];
    
    
    recognitionBtn = [[UIButton alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [recognitionBtn addTarget:self action:@selector(srartReciontionAction:) forControlEvents:(UIControlEventTouchDown)];
    
    [_viewPreview addSubview:recognitionBtn];
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    [btn setImage:[UIImage imageNamed:@"xgback"] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:(UIControlEventTouchDown)];
    [_viewPreview addSubview:btn];
    
    
    
//    UIButton *synchronization = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, 10, 40, 40)];
//    [synchronization setTitle:@"同屏" forState:(UIControlStateNormal)];
//    [synchronization addTarget:self action:@selector(synchronizationAction) forControlEvents:(UIControlEventTouchDown)];
//    [_viewPreview addSubview:synchronization];
    
    
    _scanLayer = [[CALayer alloc] init];
    _scanLayer.frame = CGRectMake(0, 0, _boxView.bounds.size.width, 1);
    _scanLayer.backgroundColor = [UIColor greenColor].CGColor;
    [_boxView.layer addSublayer:_scanLayer];
    
    
    
    if (self.captureSession) {
        [self.captureSession startRunning];
    }
}
//返回
-(void)goBackAction{
    [self dismissViewControllerAnimated:YES completion:nil];

}
//-(void)synchronizationAction{
//    FZScanViewController *vc = [[FZScanViewController alloc]init];
////    FZBaseNavigationViewController *na = [FZBaseNavigationViewController alloc]initWithRootViewController:<#(nonnull UIViewController *)#>
//    vc.uuidBlock = ^(NSString *uuid) {
//        NSLog(@"");
//        self.uuid = uuid;
//    };
//    [self presentViewController:vc animated:YES completion:nil];
//}

//开始和停止识别

-(void)srartReciontionAction:(UIButton *)sender{
    sender.selected =  !sender.selected;
    //
    if (sender.selected) {
        
        
        NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
        [parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
        [FZNetworkingManager requestLittleAntMethod:@"isUseArPass" parameters:parm requestHandler:^(BOOL success, id  _Nullable response) {
            if (success == YES) {
                
                int  aa = [[response objectForKey:@"isIosCheckVersion"] intValue];
                if (aa == 1) {
                    [self->_showARClassView removeFromSuperview];
                    self->_showARClassView = nil;
                    if (self->_mPMoviePlayerController) {
                        [self->_mPMoviePlayerController.view removeFromSuperview];
                        self->_mPMoviePlayerController = nil;
                    }
                    self.signImage = nil;
                    _recognitionTimer = nil;
                    [[SDImageCache sharedImageCache] clearMemory];
                    [self startRunning];
                    self->_verbLabel.text = @"正在识别...";
                    [self initRecognitionTime];
                }else{
                     FZUserModel *model = [FZUserInformation shareInstance].userModel;
                    if ([model.vIP isEqualToString:@"1"]) {
                        [self->_showARClassView removeFromSuperview];
                        self->_showARClassView = nil;
                        if (self->_mPMoviePlayerController) {
                            [self->_mPMoviePlayerController.view removeFromSuperview];
                            self->_mPMoviePlayerController = nil;
                        }
                        [self startRunning];
                        self->_verbLabel.text = @"正在识别...";
                        [self initRecognitionTime];
                    }else{
                        if ([[response objectForKey:@"response"] integerValue] > 0) {
                            [self->_showARClassView removeFromSuperview];
                            self->_showARClassView = nil;
                            if (self->_mPMoviePlayerController) {
                                [self->_mPMoviePlayerController.view removeFromSuperview];
                                self->_mPMoviePlayerController = nil;
                            }
                            [self startRunning];
                            self->_verbLabel.text = @"正在识别...";
                            [self initRecognitionTime];
                            
                        }else{
                            
                            NSString *cunt = [NSString stringWithFormat:@"%@",[response objectForKey:@"response"]];
                            [MBProgressHUD showSuccess:[NSString stringWithFormat:@"非会员最多能扫描10张图片，你还有%@次扫描次数，请购买会员",cunt] toView:self.view];
                            
                        }
                    }

                }
            }
        }];
        
    }else{
        //停止
        [self stopRunning];
        _verbLabel.text = @"将要识别的图片放入识别框内，点击屏幕开始识别";
        
    }

}
#pragma mark 开始
- (void)startRunning {
    if (self.captureSession) {
        self.isReading = YES;
      
        _timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(moveUpAndDownLine) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}
#pragma mark 结束
- (void)stopRunning {
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil ;
    }
    if ([_recognitionTimer isValid]) {
        [_recognitionTimer invalidate];
        _recognitionTimer = nil ;
    }
    
    _signImage = nil;
    _scanLayer.hidden = YES;
//    [_videoPreviewLayer removeFromSuperlayer];
}

- (void)moveUpAndDownLine {
     _scanLayer.hidden = NO;
    CGRect frame = self.scanLayer.frame;
    if (_boxView.frame.size.height < self.scanLayer.frame.origin.y) {
        frame.origin.y = 0;
        self.scanLayer.frame = frame;
    } else {
        frame.origin.y += 5;
        [UIView animateWithDuration:0.2 animations:^{
            self.scanLayer.frame = frame;
        }];
    }
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    self.signImage = [self imageFromSampleBuffer:sampleBuffer];
//     UIImageWriteToSavedPhotosAlbum(self.signImage, self, nil, nil);
}
//获得某个范围内的屏幕图像
- (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;//[self getImageAreaFromImage:theImage atFrame:r];
}
- (UIImage *)ct_imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //把像 素rect 转化为 点rect（如无转化则按原图像素取部分图片）
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x= rect.origin.x*scale,y=rect.origin.y*scale,w=rect.size.width*scale,h=rect.size.height*scale;
    CGRect dianRect = CGRectMake(x, y, w, h);
    
    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return newImage;
}
-(UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    // 为媒体数据设置一个CMSampleBuffer的Core Video图像缓存对象
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // 锁定pixel buffer的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    // 得到pixel buffer的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // 得到pixel buffer的行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // 得到pixel buffer的宽和高
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    // 创建一个依赖于设备的RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // 根据这个位图context中的像素数据创建一个Quartz image对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    // 释放context和颜色空间
    CGContextRelease(context); CGColorSpaceRelease(colorSpace);
    // 用Quartz image创建一个UIImage对象image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    // 释放Quartz image对象
    CGImageRelease(quartzImage);
    return (image);
}


-(void)didReceiveMemoryWarning{
    //NSLog(@"fuck");
    
    [super didReceiveMemoryWarning];
}
@end
