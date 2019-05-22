 //
//  HVideoViewController.m
//  Join
//
//  Created by 黄克瑾 on 2017/1/11.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import "HVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HAVPlayer.h"
#import "HProgressView.h"
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "Utility.h"
#import "TOCropViewController.h"
#import "LandscapeTripViewController.h" //横屏提示
#import <CoreMotion/CoreMotion.h>
#import "HVideoViewController.h"
//#import "FZNetWorkMgr.h"
//#import "FZHttpSyncRequestClient.h"
//#import "FZHttpAsyncRequestClient.h"
#import "AFNetworking.h"
#import "AFURLResponseSerialization.h"
#import <TZImagePickerController.h>
//#import "FZUserInfoMgr.h"
//#import "FZShowHUD.h"
typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);
@interface HVideoViewController ()<AVCaptureFileOutputRecordingDelegate,TOCropViewControllerDelegate,TZImagePickerControllerDelegate>{
    LandscapeTripViewController *vc;
}
@property (weak, nonatomic) IBOutlet UIView *gggggView;

//轻触拍照，按住摄像
@property (strong, nonatomic) IBOutlet UILabel *labelTipTitle;

//视频输出流
@property (strong,nonatomic) AVCaptureMovieFileOutput *captureMovieFileOutput;
//图片输出流
//@property (strong,nonatomic) AVCaptureStillImageOutput *captureStillImageOutput;//照片输出流
//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;
//后台任务标识
@property (assign,nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@property (assign,nonatomic) UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier;

@property (weak, nonatomic) IBOutlet UIImageView *focusCursor; //聚焦光标

//负责输入和输出设备之间的数据传递
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

@property (strong, nonatomic) IBOutlet UIButton *btnBack;
//重新录制
@property (strong, nonatomic) IBOutlet UIButton *btnAfresh;
//确定
@property (strong, nonatomic) IBOutlet UIButton *btnEnsure;
//摄像头切换
@property (strong, nonatomic) IBOutlet UIButton *btnCamera;

@property (strong, nonatomic) IBOutlet UIImageView *bgView;
//记录录制的时间 默认最大60秒
@property (assign, nonatomic) NSInteger seconds;

//记录需要保存视频的路径
@property (strong, nonatomic) NSURL *saveVideoUrl;
//记录需要保存视频的路径
@property (strong, nonatomic) NSURL *mp4VideoUrl;

//是否在对焦
@property (assign, nonatomic) BOOL isFocus;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *afreshCenterX;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ensureCenterX;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backCenterX;

//视频播放
@property (strong, nonatomic) HAVPlayer *player;

@property (strong, nonatomic) IBOutlet HProgressView *progressView;

//是否是摄像 YES 代表是录制  NO 表示拍照
@property (assign, nonatomic) BOOL isVideo;

@property (strong, nonatomic) UIImage *takeImage;
@property (strong, nonatomic) UIImageView *takeImageView;
@property (strong, nonatomic) IBOutlet UIImageView *imgRecord;

@property (weak, nonatomic) IBOutlet UIButton *seleImageBtn;

@property(nonatomic,strong)UIImage *firstImage;//视频第一帧

@property(nonatomic,strong)CMMotionManager  *cmmotionManager;
@end

//时间大于这个就是视频，否则为拍照
#define TimeMax 1

@implementation HVideoViewController
//选择本地相册
- (IBAction)selectImageAction:(id)sender {
    
    if (self.isVideo) {
        [self recoverLayout];
    }else{
            __weak typeof(self)weakSelf = self;
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        imagePickerVc.maxImagesCount = 1;
        imagePickerVc.allowTakePicture = NO;
        imagePickerVc.allowTakeVideo = NO;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [SVProgressHUD showGif];
            [[FZNetworkingManager sharedUtil] uploadImageFiles:@[UIImageJPEGRepresentation(photos[0], 1)] complete:^(BOOL success, NSString *fileURLString, NSError *error) {
                //                [self->parm setObject:fileURLString forKey:@"firstUrl"];
                //                dispatch_group_leave(group);
                //            [self cal]
                if (fileURLString.length > 0) {
                    if (weakSelf.takeBlock ) {
                        weakSelf.takeBlock(fileURLString,@"1");
                    }
                 
                }
                [self dismissToRootViewController];
                [SVProgressHUD hidGif];
                NSString *json = [NSString stringWithFormat:@"%@?type=%@",fileURLString,@"1"];
//                [self responseStingToWeb:json];
      
                
            }];
        }];
        [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
            [self getAsset:asset resultHandler:^(NSURL *url) {
                
                //            weakself.videoFileURL = url.absoluteString;  可以把它转成字符串 接收出来  如果NSURL 可能失败 因该是苹果内部坐了处理
                NSLog(@"%@",url);
                [self onCancelAction:nil];
                //    UIImage *image = [self getVideoPreViewImage:self.saveVideoUrl];
                NSData *data = [NSData dataWithContentsOfFile:url];
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
                        if (weakSelf.takeBlock ) {
                            weakSelf.takeBlock(responseString,coverImage);
                        }
                           [self dismissToRootViewController];
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
-(void)dealloc{
    [self removeNotification];
    
    
}
- (void)orientationChange:(NSNotification *)notification {
    
    //    NSDictionary* ntfDict = [notification userInfo];
    
    
    
    UIDeviceOrientation  orientation = [UIDevice currentDevice].orientation;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"infoNotification" object:nil userInfo:@{@"UIDeviceOrientation":[NSString stringWithFormat:@"%ld",(long)orientation]}];
    
    switch (orientation)
    {
        case UIDeviceOrientationPortrait:
//            vc = [[LandscapeTripViewController alloc]init];
//            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//            [self presentViewController:vc animated:NO completion:nil];
            NSLog(@"屏幕 left --- home 键在上 --- ");
            break;
        case UIDeviceOrientationLandscapeLeft:
            
            vc.view = nil;
            NSLog(@"屏幕 left --- home 键在右侧 --- ");
            break;
//        case UIDeviceOrientationPortraitUpsideDown:
//            vc = [[LandscapeTripViewController alloc]init];
//            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//            [self presentViewController:vc animated:NO completion:nil];
            NSLog(@"屏幕 left --- home 键在下 --- ");
            break;
        case UIDeviceOrientationLandscapeRight:
//            vc = [[LandscapeTripViewController alloc]init];
//            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//            [self presentViewController:vc animated:NO completion:nil];
            NSLog(@"屏幕 right --- home 键在左侧 --- "); break;
        default:
            break;
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    NSLog(@"home 键在左侧 --- %ld",(long)orientation);
    if (orientation == 3) {
        [vc dismissViewControllerAnimated:NO completion:nil];
    }else{
//        vc = [[LandscapeTripViewController alloc]init];
//        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//        [self presentViewController:vc animated:NO completion:nil];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(LandscapeTrip:) name:@"infoNotification" object:nil];

    self.gggggView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    UIImage *image = [UIImage imageNamed:@"sc_btn_take.png"];
    self.backCenterX.constant = -([UIScreen mainScreen].bounds.size.width/2/2)-image.size.width/2/2;
    
    self.progressView.layer.cornerRadius = self.progressView.frame.size.width/2;
    if (self.HSeconds == 0) {
        self.HSeconds = 60;
    }
    
    [self performSelector:@selector(hiddenTipsLabel) withObject:nil afterDelay:4];
    
    
}

- (void)hiddenTipsLabel {
    self.labelTipTitle.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self customCamera];
    [self.session startRunning];

}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.session stopRunning];
    [self.player stopPlayer];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)customCamera {
    
    //初始化会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc] init];
    //设置分辨率 (设备支持的最高分辨率)
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
    }
    //取得后置摄像头
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    //添加一个音频输入设备
    AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    
    //初始化输入设备
    NSError *error = nil;
    self.captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    //添加音频
    error = nil;
    AVCaptureDeviceInput *audioCaptureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    //输出对象
    self.captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];//视频输出
    
    //将输入设备添加到会话
    if ([self.session canAddInput:self.captureDeviceInput]) {
        [self.session addInput:self.captureDeviceInput];
        [self.session addInput:audioCaptureDeviceInput];
        //设置视频防抖
        AVCaptureConnection *connection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([connection isVideoStabilizationSupported]) {
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeCinematic;
        }
    }
    
    //将输出设备添加到会话 (刚开始 是照片为输出对象)
    if ([self.session canAddOutput:self.captureMovieFileOutput]) {
        [self.session addOutput:self.captureMovieFileOutput];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = self.view.bounds;//CGRectMake(0, 0, self.view.width, self.view.height);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//填充模式
    [self.bgView.layer addSublayer:self.previewLayer];
    
    [self addNotificationToCaptureDevice:captureDevice];
    [self addGenstureRecognizer];
}



- (IBAction)onCancelAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [Utility hideProgressDialog];
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([[touches anyObject] view] == self.imgRecord) {
        NSLog(@"开始录制");
        //根据设备输出获得连接
        AVCaptureConnection *connection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeAudio];
        //根据连接取得设备输出的数据
        if (![self.captureMovieFileOutput isRecording]) {
            //如果支持多任务则开始多任务
            if ([[UIDevice currentDevice] isMultitaskingSupported]) {
                self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
            }
            if (self.saveVideoUrl) {
                [[NSFileManager defaultManager] removeItemAtURL:self.saveVideoUrl error:nil];
            }
            //预览图层和视频方向保持一致
            connection.videoOrientation = [self.previewLayer connection].videoOrientation;
            NSString *outputFielPath=[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mov"];
            NSLog(@"save path is :%@",outputFielPath);
            NSURL *fileUrl=[NSURL fileURLWithPath:outputFielPath];
            NSLog(@"fileUrl:%@",fileUrl);
            [self.captureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
        } else {
            [self.captureMovieFileOutput stopRecording];
        }
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([[touches anyObject] view] == self.imgRecord) {
        NSLog(@"结束触摸");
        if (!self.isVideo) {
            [self performSelector:@selector(endRecord) withObject:nil afterDelay:0.3];
        } else {
            [self endRecord];
        }
    }
}

- (void)endRecord {
    [self.captureMovieFileOutput stopRecording];//停止录制
}

- (IBAction)onAfreshAction:(UIButton *)sender {
    NSLog(@"重新录制");
    [self recoverLayout];
}

/**
 转换视频格式  mov ——MP4

 @param saveVideoUrl <#saveVideoUrl description#>
 */
-(void)zhunahuan:(NSURL *)saveVideoUrl{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:saveVideoUrl options:nil];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
     __weak typeof(self)weakSelf = self;
    NSLog(@"%@",compatiblePresets);
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
        
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        
        NSString * resultPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
        
        NSLog(@"resultPath = %@",resultPath);
        
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         
         {
             
             switch (exportSession.status) {
                     
                 case AVAssetExportSessionStatusUnknown:
                     
                     NSLog(@"AVAssetExportSessionStatusUnknown");
                     
                     break;
                     
                 case AVAssetExportSessionStatusWaiting:
                     
                     NSLog(@"AVAssetExportSessionStatusWaiting");
                     
                     break;
                     
                 case AVAssetExportSessionStatusExporting:
                     
                     NSLog(@"AVAssetExportSessionStatusExporting");
                     
                     break;
                     
                 case AVAssetExportSessionStatusCompleted:{
                     NSLog(@"AVAssetExportSessionStatusCompleted");
                
                 }
                 NSLog(@"大小%f",[weakSelf getFileSize:[NSString stringWithFormat:@"%@",exportSession.outputURL]]);
                     NSLog(@"大小%f",[weakSelf getFileSize:resultPath]);
//                     [weakSelf showSize:[NSString stringWithFormat:@"%.2f",[self getFileSize:resultPath]]];
                     weakSelf.mp4VideoUrl = [NSURL URLWithString:resultPath];
//                     [weakSelf saveUrl:resultPath];

                     [weakSelf uploadVideo:resultPath];
                     
                     break;
                 case AVAssetExportSessionStatusFailed:
                     
                     NSLog(@"AVAssetExportSessionStatusFailed");
                     
                     break;
                     
             }
             
         }];
    }
  
}
#pragma mark - 封装弹出对话框方法
// 提示错误信息
- (void)showSize:(NSString *)showSize {
    // 1.弹框提醒
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:showSize preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}
- (CGFloat) getFileSize:(NSString *)path
{
    
    NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }else{
        NSLog(@"找不到文件");
    }
    return filesize;
}//此方法可以获取文件的大小，返回的是单位是KB。
- (CGFloat) getVideoLength:(NSURL *)URL
{
    
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
    CMTime time = [avUrl duration];
    int second = ceil(time.value/time.timescale);
    return second;
}
// 视频保存回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
     __weak typeof(self)weakSelf = self;
    [[NSFileManager defaultManager] removeItemAtURL:weakSelf.saveVideoUrl error:nil];
    if (weakSelf.lastBackgroundTaskIdentifier!= UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:weakSelf.lastBackgroundTaskIdentifier];
                }
    if (error == nil) {
        if (weakSelf.takeBlock) {
                weakSelf.takeBlock(videoPath,nil);
            }
            NSLog(@"成功保存视频到相簿.");
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"视频保存成功" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 [weakSelf onCancelAction:nil];
        }]];
        [self presentViewController:alert animated:true completion:nil];
        
    }else{
            [weakSelf onCancelAction:nil];
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"视频保存失败" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        }]];
        [self presentViewController:alert animated:true completion:nil];
    }
}

/**
 ios 9以后的保存视频  放弃8的系统

 @param viewStr url
 */
-(void)saveUrl:(NSString *)viewStr{
    NSURL *ure =[NSURL URLWithString:viewStr];
    __weak typeof(self)weakSelf = self;
    UISaveVideoAtPathToSavedPhotosAlbum(viewStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
//    ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
//    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:ure completionBlock:^(NSURL *assetURL, NSError *error) {
//        NSLog(@"outputUrl:%@",weakSelf.saveVideoUrl);
//        [[NSFileManager defaultManager] removeItemAtURL:weakSelf.saveVideoUrl error:nil];
//        if (weakSelf.lastBackgroundTaskIdentifier!= UIBackgroundTaskInvalid) {
//            [[UIApplication sharedApplication] endBackgroundTask:weakSelf.lastBackgroundTaskIdentifier];
//        }
//        if (error) {
//            NSLog(@"保存视频到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
//            [Utility showAllTextDialog:KAppDelegate.window Text:@"保存视频到相册发生错误"];
//        } else {
//            if (weakSelf.takeBlock) {
//                weakSelf.takeBlock(assetURL);
//            }
//            NSLog(@"成功保存视频到相簿.");
//            [weakSelf onCancelAction:nil];
//
//        }
//
//    }];
}

/**
 保存视频和图片

 @param sender ACTion
 */
- (IBAction)onEnsureAction:(UIButton *)sender {
    
     NSLog(@"确定 这里进行保存或者发送出去");
    //先转码  再保存
//    NSURL *url = [self zhunahuan:self.saveVideoUrl];
    [self saveUrl:[NSString stringWithFormat:@"%@",self.mp4VideoUrl]];
    [Utility showProgressDialogText:@"处理中..."];
    if (self.saveVideoUrl) {
          [self zhunahuan:self.saveVideoUrl];
    }else{
        //照片
//        UIImageWriteToSavedPhotosAlbum(self.takeImage, self, nil, nil);
        if (self.takeBlock) {
            self.takeBlock(self.takeImage,nil);
        }
        [self onCancelAction:nil];
    }
}

//前后摄像头的切换
- (IBAction)onCameraAction:(UIButton *)sender {
    NSLog(@"切换摄像头");
    AVCaptureDevice *currentDevice=[self.captureDeviceInput device];
    AVCaptureDevicePosition currentPosition=[currentDevice position];
    [self removeNotificationFromCaptureDevice:currentDevice];
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionFront;//前
    if (currentPosition == AVCaptureDevicePositionUnspecified || currentPosition == AVCaptureDevicePositionFront) {
        toChangePosition = AVCaptureDevicePositionBack;//后
    }
    toChangeDevice=[self getCameraDeviceWithPosition:toChangePosition];
    [self addNotificationToCaptureDevice:toChangeDevice];
    //获得要调整的设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
    
    //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
    [self.session beginConfiguration];
    //移除原有输入对象
    [self.session removeInput:self.captureDeviceInput];
    //添加新的输入对象
    if ([self.session canAddInput:toChangeDeviceInput]) {
        [self.session addInput:toChangeDeviceInput];
        self.captureDeviceInput = toChangeDeviceInput;
    }
    //提交会话配置
    [self.session commitConfiguration];
}

- (void)onStartTranscribe:(NSURL *)fileURL {
    if ([self.captureMovieFileOutput isRecording]) {
        -- self.seconds;
        if (self.seconds > 0) {
            if (self.HSeconds - self.seconds >= TimeMax && !self.isVideo) {
                self.isVideo = YES;//长按时间超过TimeMax 表示是视频录制
                self.progressView.timeMax = self.seconds;
            }
            [self performSelector:@selector(onStartTranscribe:) withObject:fileURL afterDelay:1.0];
        } else {
            if ([self.captureMovieFileOutput isRecording]) {
                [self.captureMovieFileOutput stopRecording];
            }
        }
    }
}


#pragma mark - 视频输出代理
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    NSLog(@"开始录制...");
    self.seconds = self.HSeconds;
    [self performSelector:@selector(onStartTranscribe:) withObject:fileURL afterDelay:1.0];
}


-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
  
    [self changeLayout];
    if (self.isVideo) {
        self.saveVideoUrl = outputFileURL;
        if (!self.player) {
            self.player = [[HAVPlayer alloc] initWithFrame:self.bgView.bounds withShowInView:self.bgView url:outputFileURL];
        } else {
            if (outputFileURL) {
                self.player.videoUrl = outputFileURL;
                self.player.hidden = NO;
            }
        }
        self.firstImage = [self getVideoPreViewImage:outputFileURL];
        [self.seleImageBtn setImage:[UIImage imageNamed:@"取消"] forState:(UIControlStateNormal)];

    } else {
        //照片
            self.saveVideoUrl = nil;
            [self videoHandlePhoto:outputFileURL];    }
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
/**
 获取视频帧数

 @param url url

 */
- (void)videoHandlePhoto:(NSURL *)url {
    
   
    
    NSLog(@"视频截取成功");
    AVURLAsset *urlSet = [AVURLAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
    imageGenerator.appliesPreferredTrackTransform = YES;    // 截图的时候调整到正确的方向
    NSError *error = nil;
    CMTime time = CMTimeMake(0,30);//缩略图创建时间 CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要获取某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actucalTime; //缩略图实际生成的时间
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
    if (error) {
        NSLog(@"截取视频图片失败:%@",error.localizedDescription);
    }
    CMTimeShow(actucalTime);
    UIImage *image = [UIImage imageWithCGImage:cgImage];

    CGImageRelease(cgImage);
    if (image) {
        NSLog(@"视频截取成功");
    } else {
        NSLog(@"视频截取失败");
    }
    if (image ) {
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
//                cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
        cropController.delegate = self;
        cropController.aspectRatioPickerButtonHidden = YES;
        cropController.rotateButtonsHidden = YES;
        cropController.cropView.cropBoxResizeEnabled = YES;
        UIImage *doneTextButtonimage = [[UIImage imageNamed:@"绿对号"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [cropController.toolbar.doneTextButton setImage:doneTextButtonimage forState:(UIControlStateNormal)];
        UIImage *cancelTextButtonmage = [[UIImage imageNamed:@"取消"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [cropController.toolbar.cancelTextButton setImage:cancelTextButtonmage forState:(UIControlStateNormal)];
        cropController.doneButtonTitle = @"";
        cropController.cancelButtonTitle = @"";
        [self presentViewController:cropController animated:YES completion:nil];
    }else{
        [self recoverLayout];
    }


//    self.takeImage = image;//[UIImage imageWithCGImage:cgImage];
//
////    [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
//
//    if (!self.takeImageView) {
//        self.takeImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
//        [self.bgView addSubview:self.takeImageView];
//    }
//    self.takeImageView.hidden = NO;
//    self.takeImageView.image = self.takeImage;
}
# pragma mark -TOCropViewControllerDelegate 图片裁剪
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle{
    
    //    UIImageWriteToSavedPhotosAlbum(image, self, nil, NULL);
//        [self dismissViewControllerAnimated:NO completion:nil];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    self.takeImage = image;
//        if (!self.takeImageView) {
//            self.takeImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
//            [self.bgView addSubview:self.takeImageView];
//        }
//        self.takeImageView.hidden = NO;
//        self.takeImageView.image = self.takeImage;
//    if (self.takeBlock) {
//        self.takeBlock(self.takeImage,@"1");
//    }
//    [self onCancelAction:nil];
    [Utility hideProgressDialog];
    [SVProgressHUD showGif];
    [self dismissToRootViewController];
    [[FZNetworkingManager sharedUtil] uploadImageFiles:@[UIImageJPEGRepresentation(image, 1)] complete:^(BOOL success, NSString *fileURLString, NSError *error) {
        //                [self->parm setObject:fileURLString forKey:@"firstUrl"];
        //                dispatch_group_leave(group);
        //            [self cal]
        if (fileURLString.length > 0) {
            if (self.takeBlock) {
                self.takeBlock(fileURLString,@"1");
            }
            [Utility hideProgressDialog];
             [SVProgressHUD hidGif];
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        }

    }];
    
}
- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled{
    [self dismissViewControllerAnimated:NO completion:nil];
     [self recoverLayout];
}
-(void)dismissToRootViewController
{
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark - 通知

//注册通知
- (void)setupObservers
{
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationWillResignActiveNotification object:[UIApplication sharedApplication]];
}

//进入后台就退出视频录制
- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [self onCancelAction:nil];
}

/**
 *  给输入设备添加通知
 */
-(void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice{
    //注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled=YES;
    }];
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //捕获区域发生改变
    [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
-(void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
/**
 *  移除所有通知
 */
-(void)removeNotification{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

-(void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //会话出错
    [notificationCenter addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:captureSession];
}

/**
 *  设备连接成功
 *
 *  @param notification 通知对象
 */
-(void)deviceConnected:(NSNotification *)notification{
    NSLog(@"设备已连接...");
}
/**
 *  设备连接断开
 *
 *  @param notification 通知对象
 */
-(void)deviceDisconnected:(NSNotification *)notification{
    NSLog(@"设备已断开.");
}
/**
 *  捕获区域改变
 *
 *  @param notification 通知对象
 */
-(void)areaChange:(NSNotification *)notification{
    NSLog(@"捕获区域改变...");
}

/**
 *  会话出错
 *
 *  @param notification 通知对象
 */
-(void)sessionRuntimeError:(NSNotification *)notification{
    NSLog(@"会话发生错误.");
}



/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] == position) {
            return camera;
        }
    }
    return nil;
}

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange{
    AVCaptureDevice *captureDevice= [self.captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        //自动白平衡
        if ([captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
            [captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        }
        //自动根据环境条件开启闪光灯
        if ([captureDevice isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [captureDevice setFlashMode:AVCaptureFlashModeAuto];
        }
        
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

/**
 *  设置闪光灯模式
 *
 *  @param flashMode 闪光灯模式
 */
-(void)setFlashMode:(AVCaptureFlashMode )flashMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFlashModeSupported:flashMode]) {
            [captureDevice setFlashMode:flashMode];
        }
    }];
}
/**
 *  设置聚焦模式
 *
 *  @param focusMode 聚焦模式
 */
-(void)setFocusMode:(AVCaptureFocusMode )focusMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}
/**
 *  设置曝光模式
 *
 *  @param exposureMode 曝光模式
 */
-(void)setExposureMode:(AVCaptureExposureMode)exposureMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
    }];
}
/**
 *  设置聚焦点
 *
 *  @param point 聚焦点
 */
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
//        if ([captureDevice isFocusPointOfInterestSupported]) {
//            [captureDevice setFocusPointOfInterest:point];
//        }
//        if ([captureDevice isExposurePointOfInterestSupported]) {
//            [captureDevice setExposurePointOfInterest:point];
//        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}

/**
 *  添加点按手势，点按时聚焦
 */
-(void)addGenstureRecognizer{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self.bgView addGestureRecognizer:tapGesture];
}

-(void)tapScreen:(UITapGestureRecognizer *)tapGesture{
    if ([self.session isRunning]) {
        CGPoint point= [tapGesture locationInView:self.bgView];
        //将UI坐标转化为摄像头坐标
        CGPoint cameraPoint= [self.previewLayer captureDevicePointOfInterestForPoint:point];
        [self setFocusCursorWithPoint:point];
        [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposureMode:AVCaptureExposureModeContinuousAutoExposure atPoint:cameraPoint];
    }
}

/**
 *  设置聚焦光标位置
 *
 *  @param point 光标位置
 */
-(void)setFocusCursorWithPoint:(CGPoint)point{
    if (!self.isFocus) {
        self.isFocus = YES;
        self.focusCursor.center=point;
        self.focusCursor.transform = CGAffineTransformMakeScale(1.25, 1.25);
        self.focusCursor.alpha = 1.0;
        [UIView animateWithDuration:0.5 animations:^{
            self.focusCursor.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [self performSelector:@selector(onHiddenFocusCurSorAction) withObject:nil afterDelay:0.5];
        }];
    }
}

- (void)onHiddenFocusCurSorAction {
    self.focusCursor.alpha=0;
    self.isFocus = NO;
}

//拍摄完成时调用
- (void)changeLayout {
    self.imgRecord.hidden = YES;
    self.btnCamera.hidden = YES;
    self.btnAfresh.hidden = NO;
    self.btnEnsure.hidden = NO;
    self.btnBack.hidden = YES;
    if (self.isVideo) {
        [self.progressView clearProgress];
    }
    
    self.afreshCenterX.constant = -([UIScreen mainScreen].bounds.size.width/2/2);
    self.ensureCenterX.constant = [UIScreen mainScreen].bounds.size.width/2/2;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    self.lastBackgroundTaskIdentifier = self.backgroundTaskIdentifier;
    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    [self.session stopRunning];
}


//重新拍摄时调用
- (void)recoverLayout {
    if (self.isVideo) {
        self.isVideo = NO;
        [self.player stopPlayer];
        self.player.hidden = YES;
    }
    [self.session startRunning];

    if (!self.takeImageView.hidden) {
        self.takeImageView.hidden = YES;
    }
//    self.saveVideoUrl = nil;
    self.afreshCenterX.constant = 0;
    self.ensureCenterX.constant = 0;
    self.imgRecord.hidden = NO;
    self.btnCamera.hidden = NO;
    self.btnAfresh.hidden = YES;
    self.btnEnsure.hidden = YES;
    self.btnBack.hidden = NO;
    [self.seleImageBtn setImage:[UIImage imageNamed:@"上传本地相机"] forState:(UIControlStateNormal)];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

/**
 上传视频到服务器

 @param URL 视频地址
 */
-(void)uploadVideo:(NSString *)URL{
     [self onCancelAction:nil];
//    UIImage *image = [self getVideoPreViewImage:self.saveVideoUrl];
    NSData *data = [NSData dataWithContentsOfFile:URL];
    __weak typeof(self)weakSelf = self;
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

        NSLog(@"responseString is %@",responseString);
        if (responseString && [responseString length] > 0)
        {
            UIImage *image = [self getVideoPreViewImage:[NSURL URLWithString:responseString]];
            if (weakSelf.takeBlock ) {
               weakSelf.takeBlock(responseString,image);
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
//          [FZShowHUD showDefaultAlertText:@"视频发送失败"];
    }];
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //宣告一個UIDevice指標，並取得目前Device的狀況
    UIDevice *device = [UIDevice currentDevice] ;
    
    //取得當前Device的方向，來當作判斷敘述。（Device的方向型態為Integer）
    switch (device.orientation) {
        case UIDeviceOrientationFaceUp:
            NSLog(@"螢幕朝上平躺");
            break;
            
        case UIDeviceOrientationFaceDown:
            NSLog(@"螢幕朝下平躺");
            break;
            
            //系統無法判斷目前Device的方向，有可能是斜置
        case UIDeviceOrientationUnknown:
            NSLog(@"未知方向");
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"螢幕向左橫置");
            break;
            
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"螢幕向右橫置");
            break;
            
        case UIDeviceOrientationPortrait:
            NSLog(@"螢幕直立");
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"螢幕直立，上下顛倒");
            break;
            
        default:
            NSLog(@"無法辨識");
            break;
    }
    
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft); // 只支持向左横向, YES 表示支持所有方向
}
- (IBAction)selectImageAndVideo:(id)sender {
    //选择视频是图片
}

@end
