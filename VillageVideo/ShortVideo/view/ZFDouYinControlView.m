//
//  ZFDouYinControlView.m
//  ZFPlayer_Example
//
//  Created by 任子丰 on 2018/6/4.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import "ZFDouYinControlView.h"
#import "UIView+ZFFrame.h"
#import "UIImageView+ZFCache.h"
#import "ZFUtilities.h"
#import "ZFLoadingView.h"
#import "ZFSliderView.h"
#import <YYWebImage.h>
#import "ZFPlayerGestureControl.h"
@interface ZFDouYinControlView ()
/// 封面图
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) ZFSliderView *sliderView;
/// 加载loading
@property (nonatomic, strong) ZFLoadingView *activity;

@end

@implementation ZFDouYinControlView
@synthesize player = _player;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.activity];
        [self addSubview:self.playBtn];
        [self addSubview:self.sliderView];
        [self resetControlView];
        self.backgroundColor = [UIColor clearColor];
        UIButton *btn = [[UIButton alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(aaaa:) forControlEvents:(UIControlEventTouchDown)];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.coverImageView.frame = self.player.currentPlayerManager.view.bounds;
    
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.width;
    CGFloat min_view_h = self.height;
    
    min_w = 44;
    min_h = 44;
    self.activity.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.activity.center = self.center;
    
    min_w = 44;
    min_h = 44;
    self.playBtn.frame = CGRectMake(min_x, min_y, 50, 50);
    self.playBtn.center = self.center;
    
    min_x = 0;
    min_y = min_view_h - 1;
    min_w = min_view_w;
    min_h = 1;
    self.sliderView.frame = CGRectMake(min_x, min_y, min_w, min_h);
}

- (void)resetControlView {
    self.playBtn.hidden = YES;
    self.sliderView.value = 0;
    self.sliderView.bufferValue = 0;
}

/// 加载状态改变
- (void)videoPlayer:(ZFPlayerController *)videoPlayer loadStateChanged:(ZFPlayerLoadState)state {
    if (state == ZFPlayerLoadStatePrepare) {
        self.coverImageView.hidden = NO;
    } else if (state == ZFPlayerLoadStatePlaythroughOK) {
        self.coverImageView.hidden = YES;
    }
    if (state == ZFPlayerLoadStateStalled) {
        [self.activity startAnimating];
    } else {
        [self.activity stopAnimating];
    }
}

/// 播放进度改变回调
- (void)videoPlayer:(ZFPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    self.sliderView.value = videoPlayer.progress;
}

/// 缓冲改变回调
- (void)videoPlayer:(ZFPlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime {
    self.sliderView.bufferValue = videoPlayer.bufferProgress;
}

- (void)gestureSingleTapped:(ZFPlayerGestureControl *)gestureControl {
//    if (self.player.currentPlayerManager.isPlaying) {
//        [self.player.currentPlayerManager pause];
//         self.playBtn.hidden = NO;
//    } else {
//        [self.player.currentPlayerManager play];
//        self.playBtn.hidden = YES;
//    }
}
-(void)aaaa:(UIButton *)btn{
        if (self.player.currentPlayerManager.isPlaying) {
            [self.player.currentPlayerManager pause];
             self.playBtn.hidden = NO;
        } else {
            [self.player.currentPlayerManager play];
            self.playBtn.hidden = YES;
        }
}
-(void)gestureDoubleTapped:(ZFPlayerGestureControl *)gestureControl{
//    if (self.player.currentPlayerManager.isPlaying) {
//        [self.player.currentPlayerManager pause];
//        self.playBtn.hidden = NO;
//    } else {
//        [self.player.currentPlayerManager play];
//        self.playBtn.hidden = YES;
//    }
}
- (void)setPlayer:(ZFPlayerController *)player {
    _player = player;
    [player.currentPlayerManager.view insertSubview:self.coverImageView atIndex:0];
}

- (void)showCoverViewWithUrl:(NSString *)coverUrl {
//    [self.coverImageView setImageWithURLString:coverUrl placeholder:[UIImage imageNamed:@"loading_bgView"]];
    [self.coverImageView yy_setImageWithURL:[NSURL URLWithString:coverUrl] placeholder:[UIImage imageNamed:@"背景底图"]];
}

- (ZFLoadingView *)activity {
    if (!_activity) {
        _activity = [[ZFLoadingView alloc] init];
        _activity.lineWidth = 0.8;
        _activity.duration = 1;
        _activity.hidesWhenStopped = YES;
    }
    return _activity;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.userInteractionEnabled = NO;
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"视频"] forState:(UIControlStateNormal)];
    }
    return _playBtn;
}

- (ZFSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[ZFSliderView alloc] init];
        _sliderView.maximumTrackTintColor = [UIColor clearColor];
        _sliderView.minimumTrackTintColor = [UIColor whiteColor];
        _sliderView.bufferTrackTintColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _sliderView.sliderHeight = 1;
        _sliderView.isHideSliderBlock = NO;
    }
    return _sliderView;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.backgroundColor = [UIColor clearColor];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}

@end
