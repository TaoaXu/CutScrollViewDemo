//
//  SliderView.h
//  MxsmNetwork
//
//  Created by mxsm on 16/9/28.
//  Copyright © 2016年 mxsm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderView : UIView

//执行执行此方法之前必须要设定 SliderView的 frame
-(void)setViewControllers:(NSArray *)viewControllers owner:(UIViewController *)parentViewController;

//获取顶部的控制滚动视图
-(UIView *)topControlViewWithFrame:(CGRect)frame titleLabelWidth:(CGFloat)titleLabelWidth;


@end
