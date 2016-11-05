//
//  CycleAdvertView.m
//  CycleAdvert
//
//  Created by Alex on 2016/11/5.
//  Copyright © 2016年 Alex. All rights reserved.
//

#import "CycleAdvertView.h"
#import "UIImageView+WebCache.h"
#import "AdvertModel.h"

#define PAGE_CONTROL_HEIGHT 20.

@interface CycleAdvertView ()<UIScrollViewDelegate>
/**
 ScrollView
 */
@property (strong,nonatomic) UIScrollView *scrollView;
/**
 pageControl
 */
@property (strong, nonatomic) UIPageControl *pageControl;
/**
 计时
 */
@property (nonatomic,assign) NSInteger timeCount;
/**
 图片总数
 */
@property (nonatomic,assign) NSInteger imagesCount;
/**
 定时器
 */
@property(nonatomic,strong) NSTimer  *animationTimer;
/**
 View 高度
 */
@property (assign, nonatomic) CGFloat advertViewHeight;
/**
 View 宽度
 */
@property (assign, nonatomic) CGFloat advertVihewWidth;

@end


@implementation CycleAdvertView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark -
#pragma mark - 初始化
- (void)setupView
{
    [self setupScrollView];
    [self setupPageControl];
}

#pragma mark -
#pragma mark - 初始化scrollView
- (void)setupScrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor redColor];
        _scrollView.delegate = self;
        //设置显示当前图片
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        
        [self addSubview:_scrollView];
    }
}

#pragma mark -
#pragma mark - 初始化PageControl
- (void)setupPageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        [self addSubview:_pageControl];
    }
}

#pragma mark -
#pragma mark - 更新ScrollView
- (void)updaeScrollViewWithImages
{
    _scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    //滚动区域
    _scrollView.contentOffset = CGPointMake(_advertVihewWidth, 0);
    _scrollView.contentSize = CGSizeMake(_advertVihewWidth*(_imagesCount+2), 0);
}

#pragma mark -
#pragma mark - 更新Pagecontrol
- (void)updatePageControlWithImages
{
    _pageControl.frame = CGRectMake(0, _advertViewHeight - PAGE_CONTROL_HEIGHT - 5, _advertVihewWidth, PAGE_CONTROL_HEIGHT);
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = _imagesCount;
}

#pragma mark -
#pragma mark - 初始化ImageView
- (void)addImageViewWithImages
{
    //添加图片
    for (int i=0; i<_imagesCount+2; i++) {
        
        UIImageView *imageView ;
        
        if (i == 0) //第一张显示最后一张
        {
            AdvertModel *model = _imagesArray[_imagesCount-1];
            NSString *imageUrl = model.imageUrl;
            
            imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _advertVihewWidth, _advertViewHeight)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
            [self.scrollView addSubview:imageView];
            
        }
        else if (i == _imagesArray.count + 1) //最后一张显示第一张
        {
            AdvertModel *model = _imagesArray[0];
            NSString *imageUrl = model.imageUrl;

            imageView=[[UIImageView alloc]initWithFrame:CGRectMake(_advertVihewWidth*i, 0, _advertVihewWidth,_advertViewHeight)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
            [self.scrollView addSubview:imageView];
            
        }
        else
        {
            AdvertModel *model = _imagesArray[i-1];
            NSString *imageUrl = model.imageUrl;
            
            imageView=[[UIImageView alloc]initWithFrame:CGRectMake(_advertVihewWidth*i, 0, _advertVihewWidth, _advertViewHeight)];
            imageView.tag= i-1 ;
            imageView.userInteractionEnabled=YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClickTap:)]];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
            
            [self.scrollView addSubview:imageView];
        }
    }

}

#pragma mark -
#pragma mark - 手势回调
- (void)imageClickTap:(UITapGestureRecognizer* )tap
{
    if (self.imageTapBlock) {
        self.imageTapBlock(tap.view.tag);
    }
}

#pragma mark -
#pragma mark - 设置图片
- (void)setImagesArray:(NSArray *)imagesArray
{
    if (imagesArray.count == 0) return;
 
    _imagesArray = imagesArray;
    _advertViewHeight = self.bounds.size.height;
    _advertVihewWidth = self.bounds.size.width;
    
    self.imagesCount =imagesArray.count;
    
    [self updaeScrollViewWithImages];
    [self updatePageControlWithImages];
    [self addImageViewWithImages];
    [self addTimer];
}

#pragma mark -
#pragma mark - Setter currentPageIndicatorTintColor
- (void)setCurentPageTinColor:(UIColor *)curentPageTinColor
{
    _curentPageTinColor = curentPageTinColor;
    _pageControl.currentPageIndicatorTintColor = curentPageTinColor;
}

#pragma mark -
#pragma mark - Setter pageIndicatorTintColor
- (void)setPageTinColor:(UIColor *)pageTinColor
{
    _pageTinColor = pageTinColor;
    _pageControl.pageIndicatorTintColor = pageTinColor;
}

#pragma mark -
#pragma mark - 定时器
-(void)addTimer
{
    if (self.animationTimer == nil)
    {
        _timeCount = 0;
        
        NSTimeInterval time = self.animationDuration ? self.animationDuration : 3.0;
        
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:time
                                                               target:self
                                                             selector:@selector(goToNext)
                                                             userInfo:nil
                                                              repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
    }
}

#pragma mark -
#pragma mark - 定时器回调
-(void)goToNext
{
    if (!self.animationTimer) return;
    
    _timeCount++;
    
    if (_timeCount == _imagesCount)
    {
        _timeCount = 0;
        _scrollView.contentOffset = CGPointMake(0, 0);
    }
    
    [_scrollView setContentOffset:CGPointMake(_advertVihewWidth*_timeCount, 0) animated:YES];
    
    _pageControl.currentPage=_timeCount-1;
}

#pragma mark - 销毁定时器
-(void)destroyTimer
{
    [self.animationTimer invalidate];
    self.animationTimer = nil;
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 停止计时
    [self destroyTimer];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 启动计时器
    [self addTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView)
    {
        if (scrollView.contentOffset.x/_advertVihewWidth == 0)
        {
            scrollView.contentOffset = CGPointMake(_advertVihewWidth*_imagesCount, 0);
        }
        else if (scrollView.contentOffset.x/_advertVihewWidth == _imagesCount+1)
        {
            
            scrollView.contentOffset=CGPointMake(_advertVihewWidth, 0);
        }
        
        CGFloat offsetCount = scrollView.contentOffset.x/_advertVihewWidth;
        
        _pageControl.currentPage = offsetCount-1;
        
        _timeCount = offsetCount;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
