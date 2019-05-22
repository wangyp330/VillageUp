//
//  FZUserAgreementViewController.m
//  Elearning
//
//  Created by missyun on 2018/10/9.
//  Copyright © 2018年 smallAnts. All rights reserved.
//

#import "FZUserAgreementViewController.h"

@interface FZUserAgreementViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation FZUserAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"http://maaee.com/luble/agreement/privacy_policy.html"];
    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
    
}
- (IBAction)disAgree:(id)sender {
    if(_agree) _agree(NO);
}
- (IBAction)agreee:(id)sender {
        if(_agree) _agree(YES);
}
@end
