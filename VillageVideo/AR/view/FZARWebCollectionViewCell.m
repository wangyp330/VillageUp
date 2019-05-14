//
//  FZARWebCollectionViewCell.m
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "FZARWebCollectionViewCell.h"
@interface FZARWebCollectionViewCell()<UIWebViewDelegate>

@end
@implementation FZARWebCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.webView.delegate = self;
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.contentView];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.contentView animated:YES];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
[MBProgressHUD hideHUDForView:self.contentView animated:YES];
}
@end
