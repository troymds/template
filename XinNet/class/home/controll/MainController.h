//
//  MainController.h
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDCycleBannerView.h"
@interface MainController : UIViewController<KDCycleBannerViewDataource,KDCycleBannerViewDelegate>{
    KDCycleBannerView * _bannerView; // 轮播
}
//离线数据
@property(nonatomic,strong)NSMutableArray *hotImageArrayOff;
@property(nonatomic,strong)NSMutableArray *adsImageArrayOff;


@property (strong,nonatomic)NSMutableArray *slideImages;
@end
