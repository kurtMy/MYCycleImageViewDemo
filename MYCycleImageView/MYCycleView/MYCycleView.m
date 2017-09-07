//
//  MYCycleView.m
//  my
//
//  Created by my on 16/5/18.
//  Copyright © 2016年 51haohuo. All rights reserved.
//

#import "MYCycleView.h"
#import "HWWeakTimer.h"


#define kheight self.bounds.size.height
#define kwidth self.bounds.size.width
@interface MYCycleView ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scroll;

@property(nonatomic,strong) UIPageControl *pageControl;

@property(nonatomic,strong) UIImageView *LeftImageView;

@property(nonatomic,strong) UIImageView *centerImageView;

@property(nonatomic,strong) UIImageView *rightImageView;


@property(nonatomic,assign)NSInteger currentIndex;

@property(nonatomic,assign)NSInteger imageCount;

@property (nonatomic, strong) NSTimer *timer;




@end

@implementation MYCycleView

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];// 先调用父类的initWithFrame方法
    if (self) {
        
        [self addSubview:self.scroll];


        self.pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((kwidth - 60)/2, kheight - 20, 60, 20)];
        self.pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
        self.pageControl.pageIndicatorTintColor=[UIColor colorWithWhite:0 alpha:0.8];
        
        self.currentIndex = 0;
        
        
    }
        return self;
}



#pragma mark -定时器设置

- (void)setSecond:(NSTimeInterval)second {
    _second = second;
    if (second != 0) {
        if (self.imageArray && self.imageArray.count < 2) {
            return;
        }
       
        if (!self.timer) {
            NSTimeInterval interval = ABS(second);
            self.timer = [HWWeakTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
        
    }else {
        [self.timer invalidate];
        self.timer = nil;
    }
    

}

#pragma mark -加载图片
- (void)setImageArray:(NSArray<NSString *> *)imageArray {
    _imageArray = imageArray;
    self.imageCount = imageArray.count;
    if (imageArray.count > 1) {
        [self createPageControl:imageArray.count];
    }else {
        self.scroll.scrollEnabled = NO;
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        
    }
    [self setImageByIndex:(int)self.currentIndex array:imageArray];
}

- (void)setCurrentIndicatorColor:(UIColor *)currentIndicatorColor {
    _currentIndicatorColor = currentIndicatorColor;
    self.pageControl.currentPageIndicatorTintColor = currentIndicatorColor;
}

- (void)setPageIndicatorColor:(UIColor *)pageIndicatorColor {
    _pageIndicatorColor = pageIndicatorColor;
    self.pageControl.pageIndicatorTintColor = pageIndicatorColor;
}


-(void)createPageControl:(NSInteger)count
{
    self.pageControl.enabled=YES;
    self.pageControl.numberOfPages=count;
    
    [self addSubview:self.pageControl];
}
#pragma mark ----刷新图片
-(void)refreshImage
{
    if (self.scroll.contentOffset.x > kwidth) {
        
        self.currentIndex=((self.currentIndex + 1) % self.imageCount);
    }
    else if(self.scroll.contentOffset.x < kwidth){
//        防止currentIndex为0时，数组越界
        self.currentIndex=((self.currentIndex - 1 + self.imageCount) % self.imageCount);
    }
    [self setImageByIndex:(int)self.currentIndex array:self.imageArray];
}
#pragma mark ----该方法根据传回的下标设置三个ImageView的图片，如果是网络图片可以在这里进行修改
-(void)setImageByIndex:(int)currentIndex array:(NSArray *)array
{
    if (!array.count) {
        [self.timer invalidate];
        self.timer = nil;

        return;
    }
        NSString *curruntImageName=[NSString stringWithString:array[currentIndex]];
        
        self.centerImageView.image = [UIImage imageNamed:curruntImageName];
        self.centerImageView.tag = currentIndex;
        self.centerImageView.userInteractionEnabled = YES;
        [self.centerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgViewClick:)]];
        
        NSString *LeftString = array[((self.currentIndex - 1 + self.imageCount) % self.imageCount)];
        self.LeftImageView.image = [UIImage imageNamed:LeftString];
        
        NSString *rightString = array[((self.currentIndex + 1) % self.imageCount)];
        
        self.rightImageView.image = [UIImage imageNamed:rightString];
        
        self.pageControl.currentPage=currentIndex;
    
    
   
    
}

#pragma mark - 自动滚动
- (void) autoScroll {
    NSLog(@"123321");
    [self.scroll setContentOffset:CGPointMake(2 * kwidth, 0) animated:YES];
    
}


#pragma mark ----UIScrollViewDelegate代理方法（停止加速时调用）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self refreshImage];
    self.scroll.contentOffset = CGPointMake(kwidth,0);
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self refreshImage];
    self.scroll.contentOffset = CGPointMake(kwidth,0);

}
#pragma mark -- 拖拽停止NSTimer
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    [self.timer invalidate];
    self.timer = nil;
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    这里不建议使用 [self.timer setinvalidateDate:[NSDate distantPast]]方法
    if (self.second > 0) {
        
        self.timer = [HWWeakTimer scheduledTimerWithTimeInterval:self.second target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
        
    
    
    
}
#pragma mark - banner点击事件
-(void)imgViewClick:(UITapGestureRecognizer *)recognizer {
    UIImageView *imgView = (UIImageView *)recognizer.view;
    
    if (self.bannerClick) {
        self.bannerClick(imgView.tag);
    }
}

#pragma mark - 懒加载

- (UIImageView *)centerImageView {
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kwidth, 0, kwidth, kheight)];
        [_centerImageView.layer setMasksToBounds:YES];
        _centerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _centerImageView.backgroundColor = [UIColor whiteColor];
    }
    return _centerImageView;
}

- (UIImageView *)LeftImageView {
    if (!_LeftImageView) {
        _LeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kwidth, kheight)];
        [_LeftImageView.layer setMasksToBounds:YES];
        _LeftImageView.contentMode = UIViewContentModeScaleAspectFill;

        _LeftImageView.backgroundColor = [UIColor whiteColor];
    }
    return _LeftImageView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2 * kwidth, 0, kwidth, kheight)];
        [_rightImageView.layer setMasksToBounds:YES];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFill;

        _rightImageView.backgroundColor = [UIColor whiteColor];
    }
    return _rightImageView;
}

- (UIScrollView *)scroll {
    if (!_scroll) {
        _scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
        
        _scroll.backgroundColor=[UIColor whiteColor];
        _scroll.showsHorizontalScrollIndicator=NO;
        _scroll.showsVerticalScrollIndicator=NO;
        _scroll.pagingEnabled=YES;
        _scroll.bounces=NO;
        _scroll.delegate=self;
        _scroll.contentOffset=CGPointMake(kwidth, 0);
        _scroll.contentSize=CGSizeMake(kwidth*3, 0);
        
        [_scroll addSubview:self.LeftImageView];
        
        [_scroll addSubview:self.centerImageView];
        
        [_scroll addSubview:self.rightImageView];
    }
    
    return _scroll;
}

- (void)dealloc {
    NSLog(@"能放了我吗?");
    [self.timer fire];
}






@end
