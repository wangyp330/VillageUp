//
//  FZShowARClassView.h
//  LittentAntShortVideo
//
//  Created by missyun on 2018/8/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FZShowARClassViewDelegate <NSObject>

-(void)didSelectClass:(NSInteger  )videoPath;

@end
@interface FZShowARClassView : UIView
@property(nonatomic,strong)NSArray  *videoArray;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,weak)id<FZShowARClassViewDelegate> FZShowARClassViewDelegate;
@end
