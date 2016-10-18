//
//  WBAdView.h
//  WBCustomAdView
//
//  Created by 吴飚 on 2016/10/18.
//  Copyright © 2016年 wubiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WBSourceType){
    WBSourceInternetType = 0,
    WBSourceLocalType = 1
};

typedef NS_ENUM(NSInteger, WBScrollDirection){
    WBScrollDirectionFromRight = 0,
    WBScrollDirectionFromLeft = 1
};

@interface WBAdView : UIView

/** 时间 */
@property (nonatomic, assign) NSTimeInterval timeInterval;

/** page背景颜色 */
@property (nonatomic, strong) UIColor *bottomViewColor;

/** page颜色 */
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

/** page选中颜色 */
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

/** page背景高度 */
@property (nonatomic, assign) CGFloat bottomViewHeight;

/** page背景alpha */
@property (nonatomic, assign) CGFloat alpha;

/** 滚动方向 */
@property (nonatomic, assign) WBScrollDirection direction;

/** 隐藏page背景 */
@property (nonatomic, assign) BOOL hideBottomView;

/** 隐藏page */
@property (nonatomic, assign) BOOL hidePageControl;


- (void)setDataSource:(NSArray<NSString *> *)dataSource WithSourceType:(WBSourceType)sourceType;

- (void)startTimer;

- (void)stopTimer;

- (void)invalidateTimer;

@end
