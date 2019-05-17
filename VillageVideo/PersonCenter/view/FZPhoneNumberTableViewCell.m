//
//  FZPhoneNumberTableViewCell.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/9/17.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZPhoneNumberTableViewCell.h"

@implementation FZPhoneNumberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)jiebangAction:(id)sender {
    SuppressPerformSelectorLeakWarning(
                                       if ([_delegate respondsToSelector:@selector(clickjiebanAction:withCell:)])
                                       {
                                           [_delegate performSelector:@selector(clickjiebanAction:withCell:) withObject:sender withObject:self];
                                       });
    
}

@end
