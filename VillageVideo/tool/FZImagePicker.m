//
//  FZImagePicker.m
//  FZBaseLib
//
//  Created by Mac on 2018/8/27.
//  Copyright © 2018年 FZ. All rights reserved.
//

#import "FZImagePicker.h"
#import "UIColor+Hex.h"

@interface FZImagePicker()<TZImagePickerControllerDelegate>

@end

@implementation FZImagePicker

-(instancetype)initWithMaxCount:(NSInteger)max{
    self = [super init];
    if (self) {
        _pickerController=[[TZImagePickerController alloc]init];
        _pickerController.maxImagesCount=max;
        [self config];
    }
    return self;
}

-(void)config{
    _pickerController.naviBgColor=[UIColor colorWithHexString:@"0281d2"];
    _pickerController.barItemTextFont=[UIFont systemFontOfSize:17];
    _pickerController.showSelectedIndex=YES;
    _pickerController.naviTitleFont=[UIFont systemFontOfSize:17];
    [_pickerController setNavLeftBarButtonSettingBlock:^(UIButton *leftButton) {
        [leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        leftButton.frame=CGRectMake(0, 20, 44, 44);
        leftButton.imageEdgeInsets=UIEdgeInsetsMake(2, -30, 0, 0);
    }];
    
    [_pickerController setPhotoPreviewPageUIConfigBlock:^(UICollectionView *collectionView, UIView *naviBar, UIButton *backButton, UIButton *selectButton, UILabel *indexLabel, UIView *toolBar, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel) {
        [backButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        backButton.frame=CGRectMake(0, 20, 44, 44);
        backButton.imageEdgeInsets=UIEdgeInsetsMake(2, -30, 0, 0);
    }];
    [_pickerController setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count> 0) {
            if (self.selectedImages) {
                self.selectedImages(photos);
            }
        }
    }];
}


#pragma mark -公开方法

-(void)showInController:(UIViewController *)controller{
    [controller presentViewController:_pickerController animated:YES completion:nil];
}
@end
