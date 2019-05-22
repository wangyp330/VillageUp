//
//  FZChallengTableViewCell.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZChallengTableViewCell.h"
#import "SXColorLabel.h"
#import "UIColor+Wonderful.h"

#import "UILabel+Wonderful.h"
@implementation FZChallengTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(FZChallageModel *)model{
    if ([model.tagType isEqualToString:@"1"]) {
       self.title.text = model.tagTitle;
        self.content.text = @"";
        self.numberPerson.text = @"";
    }else{
        self.title.attributedText = [FZChangeTextColor changeString:[NSString stringWithFormat:@"# %@",model.tagTitle]];
        self.content.text = model.tagContent;
        self.numberPerson.text = [NSString stringWithFormat:@"%@",model.joinPeople];
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
