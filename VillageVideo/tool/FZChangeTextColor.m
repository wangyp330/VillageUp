//
//  FZChangeTextColor.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZChangeTextColor.h"

@implementation FZChangeTextColor
+(NSAttributedString *)changeString:(NSString *)string{
    NSMutableAttributedString *headerMutableString = [[NSMutableAttributedString alloc]initWithString:string];
    
    //开始根据长度和位置 设置颜色
    [headerMutableString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"ffa318"] range:NSMakeRange(0, 1)];
    return headerMutableString;
  
}
@end
