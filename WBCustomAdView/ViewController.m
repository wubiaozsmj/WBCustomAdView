//
//  ViewController.m
//  WBCustomAdView
//
//  Created by 吴飚 on 2016/10/18.
//  Copyright © 2016年 wubiao. All rights reserved.
//

#import "ViewController.h"
#import "WBAdView.h"

#define kInterfaceOne @"http://imgsrc.baidu.com/forum/w%3D580/sign=6b99730dbb0e7bec23da03e91f2fb9fa/3c2beea20cf431ad9977243b4836acaf2fdd98a3.jpg"
#define kInterfaceTwo @"http://imgsrc.baidu.com/forum/w%3D580/sign=01924beabf3eb13544c7b7b3961fa8cb/032df513495409235ccc047c9158d109b2de49a3.jpg"
#define kInterfaceThree @"http://imgsrc.baidu.com/forum/w%3D580/sign=af757c4188d4b31cf03c94b3b7d7276f/041e87014a90f6039615fb453a12b31bb151edac.jpg"
#define kInterfaceFour @"http://imgsrc.baidu.com/forum/w%3D580/sign=e9917a0a1c30e924cfa49c397c096e66/7685b818367adab4a4747c4188d4b31c8601e4ad.jpg"
#define kInterfaceFive @"http://imgsrc.baidu.com/forum/w%3D580/sign=f99dafc8ac51f3dec3b2b96ca4eff0ec/b84d112eb9389b502b4987508635e5dde6116e9e.jpg"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak)  UITableView *tableView;

@property (nonatomic, weak)  WBAdView *wbAdView;

/** 网络图片 */
@property (nonatomic, strong)  NSArray *urlArr;

/** 本地图片 */
@property (nonatomic, strong)  NSArray<NSString *> *localArr;

@end

@implementation ViewController

#pragma mark - load methods
- (WBAdView *)wbAdView
{
    if (!_wbAdView)
    {
        WBAdView *view = [[WBAdView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
        self.tableView.tableHeaderView = view;
        _wbAdView = view;
    }
    return _wbAdView;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView = tableView;
        [self.view addSubview:tableView];
    }
    return _tableView;
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = @"Click to start timer";
    }
    else
    {
        cell.textLabel.text = @"Click to stop timer";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        [self.wbAdView startTimer];
    }
    else
    {
        [self.wbAdView stopTimer];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 20;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.urlArr = @[kInterfaceOne, kInterfaceTwo, kInterfaceThree, kInterfaceFour, kInterfaceFive];
    
    // 网络图片
    [self.wbAdView setDataSource:_urlArr WithSourceType:WBSourceInternetType];
    
    // 本地图片
    /*
     self.localArr = @[@"1.jpg", @"2.jpg",@"3.jpg"];
     [self.wbAdView setDataSource:self.localArr WithSourceType:WBSourceLocalType];
     */
    
    // 滚动属性设置
    /*
     self.wbAdView.bottomViewColor = [UIColor redColor];
     self.wbAdView.currentPageIndicatorTintColor = [UIColor blackColor];
     self.wbAdView.pageIndicatorTintColor = [UIColor yellowColor];
     
     self.wbAdView.direction = KHScrollDirectionFromLeft;
     self.wbAdView.bottomViewHeight = 50;
     self.wbAdView.timeInterval = 1.f;
     self.wbAdView.alpha = 1.0;
     
     self.wbAdView.hideBottomView = YES;
     self.wbAdView.hidePageControl = YES;
     */
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.wbAdView invalidateTimer];
}

@end
