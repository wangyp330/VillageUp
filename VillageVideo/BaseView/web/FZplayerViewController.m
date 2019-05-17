//
//  FZplayerViewController.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/9/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZplayerViewController.h"

#import <MediaPlayer/MediaPlayer.h>
@interface FZplayerViewController ()
@property (nonatomic,strong)MPMoviePlayerViewController *moviePlayerViewController;

@end

@implementation FZplayerViewController

#pragma mark - 控制器视图方法
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)dealloc{
    //移除所有通知监控
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark - 私有方法
/**
 *  取得本地文件路径
 *
 *  @return 文件路径
 */

/**
 *  取得网络文件路径
 *
 *  @return 文件路径
 */

-(MPMoviePlayerViewController *)moviePlayerViewController{
    if (!_moviePlayerViewController) {
        _moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:self.url];
        [self addNotification];
    }
    return _moviePlayerViewController;
}

#pragma mark - UI事件 点击模态化出现播放界面.
- (IBAction)playClick:(UIButton *)sender {
    self.moviePlayerViewController=nil;//保证每次点击都重新创建视频播放控制器视图，避免再次点击时由于不播放的问题。所以当再次点击播放弹出新的模态窗口的时如果不销毁之前的MPMoviePlayerViewController，那么新的对象就无法完成初始化，这样也就不能再次进行播放。
    //    [self presentViewController:self.moviePlayerViewController animated:YES completion:nil];
    //注意，在MPMoviePlayerViewController.h中对UIViewController扩展两个用于模态展示和关闭MPMoviePlayerViewController的方法，增加了一种下拉展示动画效果
    [self presentMoviePlayerViewControllerAnimated:self.moviePlayerViewController];
}

#pragma mark - 控制器通知
/**
 *  添加通知监控媒体播放控制器状态
 */
-(void)addNotification{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayerViewController.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished: )name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayerViewController.moviePlayer];
    
}

/**
 *  播放状态改变，注意播放完成时的状态是暂停
 *
 *  @param notification通知对象
 */
-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
    switch (self.moviePlayerViewController.moviePlayer.playbackState) {
        caseMPMoviePlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        caseMPMoviePlaybackStatePaused:
            NSLog(@"暂停播放.");
            break;
        caseMPMoviePlaybackStateStopped:
            NSLog(@"停止播放.");
            break;
        default:
            NSLog(@"播放状态:%li",self.moviePlayerViewController.moviePlayer.playbackState);
            break;
    }
}

/**
 *  播放完成
 *
 *  @param notification通知对象
 */
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    NSLog(@"播放完成.%li",self.moviePlayerViewController.moviePlayer.playbackState);
}


@end
