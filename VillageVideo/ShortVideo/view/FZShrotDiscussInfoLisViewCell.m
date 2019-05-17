//
//  FZShrotDiscussInfoLisViewCell.m
//  LittentAntShortVideo
//
//  Created by mac on 2018/8/4.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZShrotDiscussInfoLisViewCell.h"

@implementation FZShrotDiscussInfoLisViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(FZShortVideoDiscussModel *)model{
    [self.userHeader sd_setImageWithURL:[NSURL URLWithString:model.discussUser.avatar]];
    self.userName.text = model.discussUser.userName;
    self.content.text = model.discussContent;
    NSTimeInterval interval    =[model.createTime doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString       = [formatter stringFromDate: date];
    self.timeLabel.text =dateString;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
