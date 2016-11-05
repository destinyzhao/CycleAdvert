//
//  CycleAdvertView.h
//  CycleAdvert
//
//  Created by Alex on 2016/11/5.
//  Copyright © 2016年 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AdImageTapBlock)(NSInteger index);

@interface CycleAdvertView : UIView

/**
 *  手势回调block
 */
@property (copy, nonatomic) AdImageTapBlock imageTapBlock;

/**
 *  当前的点的颜色
 */
@property (strong, nonatomic) UIColor *curentPageTinColor;
/**
 *  全部点的背景色
 */
@property (strong, nonatomic) UIColor *pageTinColor;
/**
 *  滚动的间隔时间
 */
@property (assign, nonatomic) NSTimeInterval animationDuration;
/**
 图片数组
 */
@property (strong, nonatomic) NSArray *imagesArray;


@end
