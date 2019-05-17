//
//  FZCollectionCell.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/23.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZCollectionCell.h"

@implementation FZCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)action:(id)sender {
    
    SuppressPerformSelectorLeakWarning(
                                       if ([_delegate respondsToSelector:@selector(removechallage:withCell:)])
                                       {
                                           [_delegate performSelector:@selector(removechallage:withCell:) withObject:sender withObject:self];
                                       });
}
- (void)setModel:(FZChallageModel *)model{
    _model = model;
    self.label.attributedText = [FZChangeTextColor changeString:[NSString stringWithFormat:@"# %@",model.tagTitle]];
    
}
@end
