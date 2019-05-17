//
//  FZPublishCollectionReusableHeaderView.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZPublishCollectionReusableHeaderView.h"

@implementation FZPublishCollectionReusableHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.title.textColor = [UIColor colorWithHexString:@"333333"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selctAction)];
    [self addGestureRecognizer:tap];
}
- (IBAction)selectAction:(id)sender {
    if (self.block) {
        self.block();
    }
}
-(void)selctAction{
    if (self.block) {
        self.block();
    }
}
@end
