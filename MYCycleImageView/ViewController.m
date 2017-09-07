//
//  ViewController.m
//  MYCycleImageView
//
//  Created by may on 2017/9/5.
//  Copyright © 2017年 may. All rights reserved.
//

#import "ViewController.h"
#import "MYCycleView.h"
#import "NextViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <NetworkExtension/NetworkExtension.h>

@interface ViewController ()

@property (nonatomic, strong) MYCycleView *cycleView;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    开始轮播
    self.cycleView.second = 3;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    停止轮播
    self.cycleView.second = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.cycleView = [[MYCycleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
//    当imageArray.cout为1时，不轮播，相当于imageView;
    self.cycleView.imageArray = @[@"home_banner01",@"home_banner02",@"home_banner03"];
//    设置轮播时间，小于0时逆向，大于0时正向，等于0是不自动轮播
    self.cycleView.second = 3;
////    设置pageControl未选中indicator的颜色
//    self.cycleView.pageIndicatorColor = [UIColor grayColor];
////    设置pageControl当前indicator的颜色
//    self.cycleView.currentIndicatorColor = [UIColor redColor];
    
    self.cycleView.bannerClick = ^(NSInteger index) {
        
        NSLog(@"点击了%zd",index);
        
    };
    
    [self.view addSubview:self.cycleView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(150, 300, 60, 40)];
    [btn setTitle:@"next" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(nextController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
 
    
    
}

- (void)nextController {
    NextViewController *nextVc = [[NextViewController alloc] init];
    
    nextVc.title = @"lunbo2";
    
    nextVc.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController pushViewController:nextVc animated:YES];
}

- (NSString *)macAddress {
    NSArray *ifs = CFBridgingRelease(CNCopySupportedInterfaces());
    id info = nil;
    for (NSString *ifnames in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef)ifnames);
        if (info && [info count]) {
            break;
        }
    }
    NSDictionary *dict = (NSDictionary *)info;
    NSString *ssid = [[dict objectForKey:@"SSID"] lowercaseString];
    NSString *bssid = [dict objectForKey:@"BSSID"];
    NSLog(@"%@--%@",ssid,bssid);
    return bssid;
}



@end
