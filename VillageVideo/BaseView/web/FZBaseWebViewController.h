//
//  FZBaseWebViewController.h
//  FZBaseLib
//
//  Created by Mac on 2018/7/27.
//  Copyright © 2018年 FZ. All rights reserved.
//

#import "FZBaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol FZWebViewControllerDelegate <NSObject>

@optional
-(void)fzwebViewControllCallHandlerWithMethod:(NSString *)method data:(NSDictionary *)data;
@end

typedef void(^finishForRefresh)(int number);
@interface FZBaseWebViewController : FZBaseViewController

@property(nonatomic,weak)id<FZWebViewControllerDelegate>delegate;

@property(nonatomic,strong)UIWebView *webView;

@property(nonatomic,strong)NSString *hostUrl;

@property(nonatomic,assign)BOOL isHiddenShared;//是否有右上角按钮

@property(nonatomic,assign)BOOL isDirectUrl;//是否拼接url,默认拼接url

@property(nonatomic,assign)BOOL isAdd_openNewPage;//openNewPage 用add的方式
@property(nonatomic,assign)BOOL isNeedProgress;//openNewPage 用add的方式
@property(nonatomic,copy)finishForRefresh finishForRefresh;//openNewPage 用add的方式

#pragma mark - 公开方法
-(void)loadWebView;
@end
