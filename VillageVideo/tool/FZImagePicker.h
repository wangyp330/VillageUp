//
//  FZImagePicker.h
//  FZBaseLib
//
//  Created by Mac on 2018/8/27.
//  Copyright © 2018年 FZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <TZImagePickerController.h>

@interface FZImagePicker : NSObject

@property(nonatomic,copy)void(^selectedImages)(NSArray *images);

@property(nonatomic,strong)TZImagePickerController *pickerController;

-(instancetype)initWithMaxCount:(NSInteger)max;
-(void)showInController:(UIViewController *)controller;
@end
