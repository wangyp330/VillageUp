//
//  LandscapeTripViewController.m
//  CamramDemo
//
//  Created by missyun on 2018/9/5.
//  Copyright © 2018年 FZ. All rights reserved.
//

#import "LandscapeTripViewController.h"

@interface LandscapeTripViewController ()

@end

@implementation LandscapeTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.view.userInteractionEnabled = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];

}
- (void)orientationChange:(NSNotification *)notification {
    
    //    NSDictionary* ntfDict = [notification userInfo];
    
    
    
    UIDeviceOrientation  orientation = [UIDevice currentDevice].orientation;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"infoNotification" object:nil userInfo:@{@"UIDeviceOrientation":[NSString stringWithFormat:@"%ld",(long)orientation]}];
    
    switch (orientation)
    {
        case UIDeviceOrientationPortrait:
            NSLog(@"屏幕 left --- home 键在上 --- ");
            break;
        case UIDeviceOrientationLandscapeLeft:
            
            [self dismissViewControllerAnimated:NO completion:nil];
            NSLog(@"屏幕 left --- home 键在右侧 --- ");
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"屏幕 left --- home 键在下 --- ");
            break;
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"屏幕 right --- home 键在左侧 --- "); break;
        default:
            break;
    }
    
}
- (IBAction)dismAction:(id)sender {
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:NO completion:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
