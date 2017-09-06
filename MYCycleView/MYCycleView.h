//
//  MYCycleView.h
//  my
//
//  Created by my on 16/5/18.
//  Copyright © 2016年 51haohuo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BannerClickBlock)(NSInteger index);
@interface MYCycleView : UIView
//点击轮播图片调用该block
@property (nonatomic, copy) BannerClickBlock bannerClick;
//轮播时间,当second为0是不进行自动轮播
@property (nonatomic, assign) NSTimeInterval second;
//轮播图片，当imageArray.count为1时不进行轮播
@property (nonatomic, strong) NSArray<NSString *> *imageArray;
//设置分页控制当前indicator的颜色
@property (nonatomic, strong) UIColor *currentIndicatorColor;
//设置分页控制器其他indicator的颜色
@property (nonatomic, strong) UIColor *pageIndicatorColor;


@end
