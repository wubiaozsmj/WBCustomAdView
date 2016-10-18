//
//  WBAdView.m
//  WBCustomAdView
//
//  Created by 吴飚 on 2016/10/18.
//  Copyright © 2016年 wubiao. All rights reserved.
//

#import "WBAdView.h"

@interface WBAdView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, weak) UIPageControl *pageControl;

@property (nonatomic, weak) UIView *bottomView;

@property (nonatomic, strong) NSArray<NSString *> *dataSource;

@property(nonatomic, strong) NSMutableArray<UIImage *> *images;

@end

@implementation WBAdView

#pragma mark - load methods
- (UIView *)bottomView
{
    if (!_bottomView )
    {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = self.bottomViewColor;
        view.alpha = self.alpha;
        [self addSubview:view];
        _bottomView = view;
        [self bringSubviewToFront:self.pageControl];
    }
    return _bottomView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl)
    {
        UIPageControl *pageC = [[UIPageControl alloc] init];
        pageC.currentPage = 0;
        [self addSubview:pageC];
        _pageControl = pageC;
    }
    _pageControl.numberOfPages = self.dataSource.count;
    return _pageControl;
}

- (NSTimer *)timer
{
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(timerHandle) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.pagingEnabled = YES;
        
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.bounces = NO;
        [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
        [self addSubview:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    for (UIView *subView in cell.contentView.subviews)
    {
        [subView removeFromSuperview];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
    imageView.image = self.images[indexPath.row];
    [cell.contentView addSubview:imageView];
    
    return cell;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentPage = (scrollView.contentOffset.x / CGRectGetWidth(self.frame)) - 1;
    self.pageControl.currentPage = currentPage;
    
    if (currentPage < 0)
    {
        self.pageControl.currentPage = self.dataSource.count - 1;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.dataSource.count inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        return;
    }
    else if (currentPage == self.dataSource.count)
    {
        self.pageControl.currentPage = 0;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        return;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}


#pragma mark - Events Hanlde
- (void)setDataSource:(NSArray<NSString *> *)dataSource WithSourceType:(WBSourceType)sourceType
{
    _dataSource = dataSource;
    self.images = [NSMutableArray array];
    NSInteger count = dataSource.count + 2;
    
    for (NSInteger i = 0; i < count; i++)
    {
        UIImage *image = nil;
        switch (sourceType)
        {
            case WBSourceInternetType:
                if (0 == i)
                {
                    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dataSource lastObject]]]];
                }
                else if(count - 1 == i)
                {
                    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dataSource firstObject]]]];
                }
                else
                {
                    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dataSource[i - 1]]]];
                }
                [self.images addObject:image];
                break;
                
            default:
                if (0 == i)
                {
                    image = [UIImage imageNamed:[dataSource lastObject]];
                }
                else if(count - 1 == i)
                {
                    image = [UIImage imageNamed:[dataSource firstObject]];
                }
                else
                {
                    image = [UIImage imageNamed:dataSource[i - 1]];
                }
                [self.images addObject:image];
                break;
        }
    }
    
    [self.collectionView reloadData];
}

- (void)timerHandle
{
    NSInteger curPage = self.collectionView.contentOffset.x / CGRectGetWidth(self.collectionView.frame);
    NSInteger nextPage = 0;
    
    if (self.direction == WBScrollDirectionFromRight)
    {
        nextPage = curPage + 1;
        if (nextPage == self.images.count)
        {
            nextPage = 2;
        }
    }
    else
    {
        nextPage = curPage - 1;
        if (nextPage < 0)
        {
            nextPage = self.images.count - 2;
        }
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)startTimer
{
    [self timer];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)setHideBottomView:(BOOL)hideBottomView
{
    _hideBottomView = hideBottomView;
    self.bottomView.hidden = hideBottomView;
}

- (void)setHidePageControl:(BOOL)hidePageControl
{
    _hidePageControl = hidePageControl;
    self.pageControl.hidden = hidePageControl;
}

- (void)setAlpha:(CGFloat)alpha
{
    _alpha = alpha;
    self.bottomView.alpha = alpha;
}

- (void)invalidateTimer
{
    [self stopTimer];
}

#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _timeInterval = 2.f;
    _bottomViewColor = [UIColor blackColor];
    _pageIndicatorTintColor = [UIColor whiteColor];
    _currentPageIndicatorTintColor = [UIColor redColor];
    _bottomViewHeight = 30;
    _direction = WBScrollDirectionFromRight;
    _alpha = 0.3;
}

#pragma mark - layoutSubViews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = self.bottomViewHeight;
    CGFloat y = CGRectGetHeight(self.frame) - height;
    
    self.bottomView.frame = CGRectMake(0, y, width, height);
    self.pageControl.frame = CGRectMake(0, y, width, height);
    
    self.pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
