//
//  ShortViewCollectionViewCell.m
//  PlayShortVideo
//
//  Created by missyun on 2018/7/31.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ShortViewCollectionViewCell.h"
#import "UIView+ZFFrame.h"
#import <YYWebImage.h>
#import <Masonry.h>

@implementation ShortViewCollectionViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    

    
    //solve UICollectionViewCell subviews do not resize
    self.contentView.autoresizingMask =
    //UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleWidth |
    //UIViewAutoresizingFlexibleRightMargin |
    //UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight
    //UIViewAutoresizingFlexibleBottomMargin
    ;
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
    // Initialization code
    self.laebl = [[UILabel alloc]init];
    self.laebl.numberOfLines = 2;
    self.laebl.text = @"";
    self.laebl.textColor = [UIColor whiteColor];
    self.laebl.font = [UIFont systemFontOfSize:15];
    self.laebl.lineBreakMode = NSLineBreakByCharWrapping;
////    self.laebl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
//    self.LikeCout.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.1];
//    self.lookCount.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.1];
    self.laebl.layer.masksToBounds = YES;
    self.laebl.layer.cornerRadius = 3;
    self.lookCount.layer.masksToBounds = YES;
    self.lookCount.layer.cornerRadius = 3;
    self.LikeCout.layer.cornerRadius = 3;
    self.LikeCout.layer.masksToBounds = YES;
    
 
    [self.upImage addSubview:self.laebl];
    [self.upImage bringSubviewToFront:self.laebl];
    [self.laebl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.left.mas_equalTo(10);
    }];
    
//    
//    // 创建渐变色图层
//    CAGradientLayer *gradientLayer= [CAGradientLayer layer];
//     gradientLayer.frame = self.buttomView.bounds;
//    
//    gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,(__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor,(__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor,(__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor];
//
//    // 设置渐变方向(0~1)
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(0, 1);
//    
//    // 设置渐变色的起始位置和终止位置(颜色的分割点)
//    gradientLayer.locations = @[@(0.20f),@(0.20f),@(0.30f),@(0.30f)];
//    gradientLayer.borderWidth  = 0.0;
//    // 添加图层
//    [self.buttomView.layer addSublayer:gradientLayer];
}
-(void)setModel:(ShortVideoModel *)model{
    if ([model.status isEqualToString:@"0"]) {
        self.laebl.text = @"";
        [self.lookCount setImage:[UIImage imageNamed:@"草稿箱"] forState:(UIControlStateNormal)];
         [self.lookCount setTitle:@"草稿箱" forState:(UIControlStateNormal)];
          self.LikeCout.text = @"";
    }else{
        self.laebl.text = model.videoContent;
          [self.lookCount setImage:[UIImage imageNamed:@"播放-2"] forState:(UIControlStateNormal)];
        [self.lookCount setTitle:[NSString stringWithFormat:@"%@%@",@" ",model.readCount] forState:(UIControlStateNormal)];
        self.LikeCout.text = [NSString stringWithFormat:@"%@赞",model.likeCount];
    }
        self.coverImage.yy_imageURL = [NSURL URLWithString:model.coverPath];
    [self.coverImage yy_setImageWithURL:[NSURL URLWithString:model.coverPath] placeholder:[UIImage imageNamed:@"背景底图"]];

}
@end
