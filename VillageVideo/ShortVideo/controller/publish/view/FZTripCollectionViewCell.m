//
//  FZTripCollectionViewCell.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZTripCollectionViewCell.h"

@implementation FZTripCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.label.layer.cornerRadius = 1;
     self.label.layer.masksToBounds=YES;
     self.label.layer.borderWidth=1.0;
    self.label.backgroundColor = [[UIColor colorWithHexString:@"FFA318"] colorWithAlphaComponent:0.1];
     self.label.layer.borderColor=[[UIColor colorWithHexString:@"FFA318"] CGColor];
     self.label.textColor=[UIColor colorWithHexString:@"FFA318"];
    self.backgroundColor = [UIColor whiteColor] ;
    self.label.layer.masksToBounds = YES;
    self.label.layer.cornerRadius = 4;
}
- (void)setModel:(FZChallageModel *)model{
    _model = model;
    self.label.text = model.tagTitle;
}
- (IBAction)remove:(id)sender {
    SuppressPerformSelectorLeakWarning(
                                       if ([_delegate respondsToSelector:@selector(remove:withCell:)])
                                       {
                                           [_delegate performSelector:@selector(remove:withCell:) withObject:sender withObject:self];
                                       });
    
}

@end
