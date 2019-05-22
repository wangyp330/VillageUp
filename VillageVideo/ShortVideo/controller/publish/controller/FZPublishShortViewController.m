//
//  FZPublishShortViewController.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZPublishShortViewController.h"
#import "FSTextView.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>
#import <TZImagePickerController.h>
#import "MBProgressHUD+Add.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+ZFFrame.h"
#import "BindingTableViewCell.h"
#import "FZChallengAndTripViewController.h"
#import "FZTripViewController.h"
#import <Masonry.h>
#import "FZPublishSelectChallageTripView.h"
#import <YYWebImage.h>
#import <UIImageView+WebCache.h>
@interface FZPublishShortViewController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,FZChallengAndTripViewControllerDelegate,FZTripViewControllerDelegate,delectSomeTripDelegate>{
    MPMoviePlayerViewController *mPMoviePlayerViewController;
    NSMutableDictionary *parm;
    NSMutableArray *array;
        NSMutableArray *challagearray;
        NSMutableArray *tripArray;
    UIView *bottomLine;
    UIView *bgView;
    
    UILabel *titleLab;
    FZPublishSelectChallageTripView *vc;//挑战，标签视图
}
@property(nonatomic,strong)FSTextView *textfiled;
@property(nonatomic,strong)UIButton *videoImageBtn;
@property(nonatomic,strong)UIButton *PublishBtn;
@property(nonatomic,strong)UIImage   *userSelectFirstImage;
@property(nonatomic,assign)CGFloat    challageHigth;
@end

@implementation FZPublishShortViewController

- (void)viewDidLoad {
        [super viewDidLoad];
    self.title=@"发布";

    if (self.model) {
        self.viderPath = [NSURL URLWithString:self.model.videoPath];
    }
    self.challageHigth = 330;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName : [UIFont systemFontOfSize:17]}];
     parm = [[NSMutableDictionary alloc]init];

    array = [[NSMutableArray alloc]init];
    challagearray = [[NSMutableArray alloc]init];
     tripArray = [[NSMutableArray alloc]init];
    [array addObjectsFromArray:@[challagearray,tripArray]];
    [self.view addSubview:self.textfiled];
    [self creaetvideoImageBtn];
//
//
    UIView *lineView=[[UIView alloc]init];
    lineView.backgroundColor=[UIColor colorWithHexString:@"e5e5e5"];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.mas_equalTo(_videoImageBtn.mas_bottom).offset(15);
        make.height.mas_equalTo(0.5);
    }];
    [self configItems];
        [self creaetPubliceBtn];
    if (self.model) {
        if (self.model.videoContent.length > 0) {
               self.textfiled.text = self.model.videoContent;
        }
        [self.model.tags enumerateObjectsUsingBlock:^(Tags * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            Tags *model = [[Tags alloc]initWithDictionary:obj error:nil];
            if ([model.tagType isEqualToString:@"1"]) {
                [self->tripArray addObject:model];
            }else{
                [self->challagearray addObject:model];
            }
              vc.dataArray = [NSMutableArray arrayWithArray:array];
        }];
    }
    if (self.tagModel) {
         [self->challagearray addObject:self.tagModel];
           vc.dataArray = [NSMutableArray arrayWithArray:array];
    }
     self.view.backgroundColor = [UIColor whiteColor];
    
}

-(void)creaetvideoImageBtn{
    for (int i = 0; i < 2; i ++) {
        _videoImageBtn = [[UIButton alloc]initWithFrame:CGRectMake(13+i*100+(i*10), 70+100+10, 100, 133)];
        if (self.model.videoPath.length > 0) {
         [_videoImageBtn yy_setBackgroundImageWithURL:[NSURL URLWithString:self.model.firstUrl] forState:(UIControlStateNormal) options:(0)];
        }else{
            [_videoImageBtn setBackgroundImage:[self getVideoPreViewImage:self.viderPath] forState:(UIControlStateNormal)];
        }
      
        [_videoImageBtn addTarget:self action:@selector(videoImageBtnAction:) forControlEvents:(UIControlEventTouchDown)];
        [self.view addSubview:_videoImageBtn];
        _videoImageBtn.tag  = 100+i;
        if(i == 0 ){
            UIImageView *image = [[UIImageView alloc]init];
            image.image = [UIImage imageNamed:@"视频"];
            [_videoImageBtn addSubview:image];
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(35, 35));
                make.center.equalTo(_videoImageBtn);
            }];
        } 
        if (i==1) {
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 41, 41)];
            image.image = [UIImage imageNamed:@"封面"];
            [_videoImageBtn addSubview:image];
            if (self.model.coverPath.length > 0) {
                 [_videoImageBtn yy_setBackgroundImageWithURL:[NSURL URLWithString:self.model.coverPath] forState:(UIControlStateNormal) options:(0)];
            }
        }
    }
}
#pragma mark 图片点击事件
-(void)videoImageBtnAction:(UIButton *)sender{
    
    if (sender.tag == 101) {
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        imagePickerVc.allowPickingVideo = NO;//不允许选择视频
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            self.userSelectFirstImage = photos[0];
            [sender setBackgroundImage:self.userSelectFirstImage forState:(UIControlStateNormal)];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }else{
        

        mPMoviePlayerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:self.viderPath];
        mPMoviePlayerViewController.view.frame = self.view.bounds;
        [self presentViewController:mPMoviePlayerViewController animated:YES completion:nil];
    }
}
-(void)creaetPubliceBtn{
    CGFloat buttonW1 = (SCREEN_WIDTH-39)/3;
    CGFloat buttonW2 = buttonW1*2;
    CGFloat buttonH = KScreenScaleRatio(45);

    for (int i = 0; i < 2; i++) {

        _PublishBtn = [[UIButton alloc]init];
        _PublishBtn.userInteractionEnabled = YES;
        _PublishBtn.layer.masksToBounds = YES;
        _PublishBtn.layer.cornerRadius = 5;
        _PublishBtn.layer.borderWidth = 1;
        _PublishBtn.layer.borderColor = APP_BLUE_COLOR.CGColor;
        _PublishBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [self.view addSubview:_PublishBtn];
        [_PublishBtn bringSubviewToFront:self.view];

        _PublishBtn.tag = 200+i;
        if (i == 0) {
            _PublishBtn.backgroundColor = [UIColor whiteColor];
            [_PublishBtn setTitle:@"草稿" forState:(UIControlStateNormal)];
            [_PublishBtn setTitleColor:APP_BLUE_COLOR forState:(UIControlStateNormal)];
        }else{
            _PublishBtn.backgroundColor = APP_BLUE_COLOR;
             [_PublishBtn setTitle:@"发布" forState:(UIControlStateNormal)];
             [_PublishBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        }


        //设置frame
        _PublishBtn.x = (SCREEN_WIDTH-buttonW1-buttonW2-13)/2+(i % 2) * (buttonW1+13);//button的X
        _PublishBtn.y = KScreenScaleRatio( SCREEN_HEIGHT-90);
        if (i == 0) {
          _PublishBtn.width = buttonW1;//button的width
        }else{
           _PublishBtn.width = buttonW2;
        }


        _PublishBtn.height = buttonH;//button的height
        [_PublishBtn addTarget:self action:@selector(publishAction:) forControlEvents:(UIControlEventTouchDown)];

    }
}
#pragma mark -  标签代理
-(void)didSelectTrip:(NSArray *)arry{
    [tripArray removeAllObjects];
    for (FZChallageModel *model in arry) {
        [tripArray addObject:model];
    }
     vc.dataArray = [NSMutableArray arrayWithArray:array];
}
#pragma Mark 挑战
-(void)didSelectClass:(FZChallageModel  *)model{
    [challagearray removeAllObjects];
    [challagearray addObject:model];
    vc.dataArray = [NSMutableArray arrayWithArray:array];
}
-(void)delectSomeTrtp:(FZChallageModel *)model{

    for (NSMutableArray *arr in array) {

            [arr enumerateObjectsUsingBlock:^(FZChallageModel *mo, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([mo.tagTitle isEqualToString:model.tagTitle]) {
                    *stop = YES;
                    [arr removeObjectAtIndex:idx];
                    
                 }
          
            }];
    }
    vc.dataArray = [NSMutableArray arrayWithArray:array];
    
}
#pragma mark 保存 发布
-(void)publishAction:(UIButton *)sender{
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [SVProgressHUD showGif];
    

    NSMutableArray *data = [[NSMutableArray alloc]init];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.001 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        // Insert myTask code here
        
        for (FZChallageModel *mo in self->challagearray) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
            [parm setObject:@"2" forKey:@"tagType"];
            [parm setObject:mo.tagTitle forKey:@"tagTitle"];
            if (mo.tagId) {
                [parm setObject:mo.tagId forKey:@"tagId"];
            }
            [data addObject:parm];
        }
        for (FZChallageModel *mo in self->tripArray) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
            [parm setObject:@"1" forKey:@"tagType"];
            [parm setObject:mo.tagTitle forKey:@"tagTitle"];
            if (mo.tagId) {
                [parm setObject:mo.tagId forKey:@"tagId"];
            }
            [data addObject:parm];
        }
        [self->parm setObject:data forKey:@"tags"];
        [self->parm setObject:@"1" forKey:@"videoType"];
        [self->parm setObject:[FZUserInformation shareInstance].userModel.uid forKey:@"userId"];
        [self->parm setObject:@"1" forKey:@"visibilityType"];
        [self->parm setObject:[FZUserInformation shareInstance].userModel.villageId forKey:@"villageId"];
        [self->parm setObject:[FZUserInformation shareInstance].userModel.groupId  forKey:@"groupId"];
        
        
        AVAsset *asset = [AVAsset assetWithURL:self.viderPath];
        NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
        if([tracks count] > 0) {
            AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
            NSLog(@"=====hello  width:%f===height:%f",videoTrack.naturalSize.width,videoTrack.naturalSize.height);//宽高
            [self->parm setObject:[NSString stringWithFormat:@"%.0f",videoTrack.naturalSize.height] forKey:@"height"];
            [self->parm setObject:[NSString stringWithFormat:@"%.0f",videoTrack.naturalSize.width] forKey:@"width"];
        }
        
        NSString *city=[NSString stringWithFormat:@"%@",NSUSERGET(@"city")];
        [self->parm setObject:city forKey:@"userCity"];
        if ([self.viderType isEqualToString:@"1"]) {
            [self->parm setObject:self.targetId forKey:@"fatherId"];
        }
        
        
        if (sender.tag == 200) {
            [self->parm setObject:@"0" forKey:@"status"];
            [self->parm setObject:@"0" forKey:@"isLocalSave"];
            if (self.textfiled.text.length >0 ) {
                [self->parm setObject:self.textfiled.text forKey:@"videoContent"];
            }else{
            }
        }else{
            [self->parm setObject:@"1" forKey:@"status"];
            [self->parm setObject:@"1" forKey:@"isLocalSave"];
            if (self.textfiled.text.length >0 ) {
                [self->parm setObject:self.textfiled.text forKey:@"videoContent"];
            }else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showSuccess:@"请输入心情" toView:self.view];
                return;
            }
        }
        
        
        if (self.model) {
            [self->parm setObject:self.model.vid forKey:@"vid"];
            if (self.model.fatherId && self.model.fatherId.length > 0) {
                [self->parm setObject:self.model.fatherId forKey:@"fatherId"];
            }
        }else{
            
        }
        //发布
        dispatch_group_t group = dispatch_group_create();
        
        //上传视频
        dispatch_group_enter(group);
        NSData *dataa = [NSData dataWithContentsOfURL:self.viderPath];
        if (self.model.videoPath.length > 0) {
            [self->parm setObject:self.model.videoPath forKey:@"videoPath"];
             dispatch_group_leave(group);
        }else{
            [[FZNetworkingManager sharedUtil] uploadDatFile:dataa withVType:@".mp4" complete:^(BOOL success, NSString *fileURLString, NSError *error) {
                if (fileURLString.length > 0) {
                 [self->parm setObject:fileURLString forKey:@"videoPath"];
                }
                dispatch_group_leave(group);
            }];
        }

        dispatch_group_enter(group);
        
        
        if (self.model.firstUrl.length > 0) {
            [self->parm setObject:self.model.firstUrl forKey:@"firstUrl"];
            dispatch_group_leave(group);
        }else{
            [[FZNetworkingManager sharedUtil] uploadImageFiles:@[UIImageJPEGRepresentation([self getVideoPreViewImage:self.viderPath], 1)] complete:^(BOOL success, NSString *fileURLString, NSError *error) {
                [self->parm setObject:fileURLString forKey:@"firstUrl"];
                dispatch_group_leave(group);
            }];
        }

        dispatch_group_enter(group);
        if (!self.userSelectFirstImage) {
            
            if (self.model.coverPath.length > 0) {
                [self->parm setObject:self.model.coverPath forKey:@"coverPath"];
                dispatch_group_leave(group);
            }else{
                [[FZNetworkingManager sharedUtil] uploadImageFiles:@[UIImageJPEGRepresentation([self getVideoPreViewImage:self.viderPath], 1)] complete:^(BOOL success, NSString *fileURLString, NSError *error) {
                    [self->parm setObject:fileURLString forKey:@"coverPath"];
                    dispatch_group_leave(group);
                }];
            }
 
        }else{
            [[FZNetworkingManager sharedUtil] uploadImageFiles:@[UIImageJPEGRepresentation(self.userSelectFirstImage, 1)] complete:^(BOOL success, NSString *fileURLString, NSError *error) {
                [self->parm setObject:fileURLString forKey:@"coverPath"];
                dispatch_group_leave(group);
            }];
        }
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSLog(@"所有任务组都完成了");
            NSMutableDictionary *par = [[NSMutableDictionary alloc]init];
            NSString *jsonSte = [self convertToJsonData:self->parm];
            [par setObject:jsonSte forKey:@"videoJson"];
            [FZNetworkingManager requestLittleAntMethod:@"saveLittleVideoInfo" parameters:par requestHandler:^(BOOL success, id  _Nullable response) {
                if (success == YES) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"punblishSuccess" object:nil];
                }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                [SVProgressHUD hidGif];
            }];
            
        });
        
    });

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
-(UITextView *)textfiled{
    if (!_textfiled) {
        _textfiled = [[FSTextView alloc]initWithFrame:CGRectMake(10, 70, SCREEN_WIDTH-20, 100)];
        _textfiled.backgroundColor = [UIColor whiteColor];
        _textfiled.placeholder = @"分享你此刻的心情...(限制60个字)";
        _textfiled.textColor = [UIColor colorWithHexString:@"333333"];
        _textfiled.maxLength = 50;
    }
    return  _textfiled;
}

-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

#pragma mark - itemUI
-(void)configItems{
//    [self addItemViewWithTitle:@"添加挑战" imgName:@"chellangeIcon" index:100 frameY:self.challageHigth];
//    [self addItemViewWithTitle:@"添加标签" imgName:@"tripIcon" index:101 frameY:self.challageHigth+55];
    vc = [[FZPublishSelectChallageTripView alloc]initWithFrame:CGRectMake(0, 330, SCREEN_WIDTH, 300)];
    __weak typeof(self)weakSelf = self;
    vc.delegate = self;
    vc.block = ^(int index) {
        if (index == 0) {
            //挑战
            FZChallengAndTripViewController *vc = [[FZChallengAndTripViewController alloc]init];
            vc.delegate = weakSelf;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            //标签
            FZTripViewController *vc = [[FZTripViewController alloc]init];
            vc.delegate = weakSelf;
            vc.dataSource = [[NSMutableArray alloc]initWithArray:self->tripArray];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    [self.view addSubview:vc];


}
@end
