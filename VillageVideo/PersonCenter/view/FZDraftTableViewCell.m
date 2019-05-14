//
//  FZDraftTableViewCell.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/16.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZDraftTableViewCell.h"

@implementation FZDraftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userInteractionEnabled = YES;
}
-(void)setModel:(ShortVideoModel *)model{
    self.coverImage.yy_imageURL = [NSURL URLWithString:model.coverPath];
    if (model.videoContent.length > 0) {
      self.contentLabel.text = model.videoContent;
           self.contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }else{
          self.contentLabel.text = @"标题为空";
         self.contentLabel.textColor = [UIColor colorWithHexString:@"666666"];
    }
  
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
