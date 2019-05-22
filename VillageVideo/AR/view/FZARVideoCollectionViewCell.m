//
//  FZARVideoCollectionViewCell.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZARVideoCollectionViewCell.h"
@interface FZARVideoCollectionViewCell()
@end
@implementation FZARVideoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
      self.coverImage.tag = 100;
//    if (!_mPMoviePlayerController) {
//        _mPMoviePlayerController = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:@"http://60.205.86.217/upload8/2018-07-20/11/976c46e3-7008-470a-aac1-f22c04ecd064.mp4"]];
//        [self.contentView addSubview:_mPMoviePlayerController.view];
//        _mPMoviePlayerController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3);
////        [_mPMoviePlayerController play];
//    }
}

@end
