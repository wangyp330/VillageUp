//
//  ZFDouYinCell.m
//  ZFPlayer_Example
//
//  Created by 紫枫 on 2018/6/4.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import "ZFDouYinCell.h"
#import "UIImageView+ZFCache.h"
#import "UIView+ZFFrame.h"
#import "UIImageView+ZFCache.h"
#import "ZFUtilities.h"
#import "ZFLoadingView.h"
#import <YYWebImage/YYWebImage.h>
@interface ZFDouYinCell ()

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) UIButton *followingPlay;//跟拍
@property (nonatomic, strong) UIButton *likeBtn;//点赞
@property (nonatomic, strong) UIButton *commentBtn;//评论
@property (nonatomic, strong) UIButton *shareBtn;//分享
@property (nonatomic, strong) UIButton   *headImageAndName;//头像名字
@property (nonatomic, strong) UIButton   *attentionBtn;//关注
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImage *placeholderImage;

@end

@implementation ZFDouYinCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.coverImageView];
        [self.contentView addSubview:self.titleLabel];
//        [self.contentView addSubview:self.likeBtn];
//        [self.contentView addSubview:self.commentBtn];
//        [self.contentView addSubview:self.shareBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.coverImageView.frame = self.contentView.bounds;
    
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.width;
    CGFloat min_view_h = self.height;
    CGFloat margin = 30;
//
//    min_w = 40;
//    min_h = min_w;
//    min_x = min_view_w - min_w - 20;
//    min_y = min_view_h - min_h - 80;
//    self.shareBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
//
//    min_w = CGRectGetWidth(self.shareBtn.frame);
//    min_h = min_w;
//    min_x = CGRectGetMinX(self.shareBtn.frame);
//    min_y = CGRectGetMinY(self.shareBtn.frame) - min_h - margin;
//    self.commentBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
//
//    min_w = CGRectGetWidth(self.shareBtn.frame);
//    min_h = min_w;
//    min_x = CGRectGetMinX(self.commentBtn.frame);
//    min_y = CGRectGetMinY(self.commentBtn.frame) - min_h - margin;
//    self.likeBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
//
    min_x = 20;
    min_h = 20;
    min_y = min_view_h - min_h - 50;
    min_w = min_view_w - margin;
    self.titleLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}
//
//- (UIButton *)likeBtn {
//    if (!_likeBtn) {
//        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
//    }
//    return _likeBtn;
//}
//
//
//- (UIButton *)commentBtn {
//    if (!_commentBtn) {
//        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_commentBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
//    }
//    return _commentBtn;
//}

//- (UIButton *)shareBtn {
//    if (!_shareBtn) {
//        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
//    }
//    return _shareBtn;
//}

- (UIImage *)placeholderImage {
    if (!_placeholderImage) {
        _placeholderImage = [ZFUtilities imageWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1] size:CGSizeMake(1, 1)];
    }
    return _placeholderImage;
}
-(void)setModel:(ShortVideoModel *)model{
    self.coverImageView.yy_imageURL = [NSURL URLWithString:model.firstUrl];
    self.titleLabel.text = model.videoContent;
}
- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.tag = 100;
        _coverImageView.backgroundColor = [UIColor blackColor];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}
@end
