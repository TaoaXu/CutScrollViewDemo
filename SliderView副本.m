//
//  SliderView.m
//  MxsmNetwork
//
//  Created by mxsm on 16/9/28.
//  Copyright © 2016年 mxsm. All rights reserved.
//

#import "SliderView.h"

@interface SliderView()<UIScrollViewDelegate>

// 底层控制器
@property (weak,nonatomic) UIViewController *parentViewController;

// 导航上面的滚动视图
@property(nonatomic,strong) UIScrollView * topScrollView;

// 滚动视图下面的滚动条图片
@property(nonatomic,strong) UIImageView * topIndicatorView;

// 包含两个控制器的滚动视图
@property(nonatomic,strong) UIScrollView * contentScrollView;

// 导航上面的titleLabelArray
@property(nonatomic,strong) NSMutableArray * titleLabelArray;

// 索要添加的控制器数组
@property (strong,nonatomic) NSArray *viewControllers;

// titleLabel的宽度
@property (nonatomic) float titleLabelWidth;

@end

@implementation SliderView

- (instancetype)init
{
    self = [super init];
    if (self) {
    
    }
    return self;
}

#pragma mark  -- setViewControllers
/**

 给底层控制器添加控制器数组
 @param viewControllers      索要添加的控制器数组这里是 直播和课堂
 @param parentViewController 底层控制器 LiveHomeController
 */
-(void)setViewControllers:(NSArray *)viewControllers owner:(UIViewController *)parentViewController
{
    // 底层控制器
    self.parentViewController = parentViewController;
    self.viewControllers = viewControllers;
    
    // 添加滚动视图
    [self addSubview:self.contentScrollView];
    
    for (int i=0; i<viewControllers.count; i++) {
        
        UIViewController *viewController = viewControllers[i];
        
        // 设置 两个字控制器的 ViewFrame 根据 contentScrollView
        viewController.view.frame = CGRectMake(i*_contentScrollView.frame.size.width, 0, _contentScrollView.frame.size.width, _contentScrollView.frame.size.height);
        
        // 设置 两个控制器的背景色
        viewController.view.backgroundColor = [UIColor whiteColor];
        
        // contentScrollView 添加控制器的view
        [self.contentScrollView addSubview:viewController.view];
        
        // 添加子控制器
        [self.parentViewController addChildViewController:viewController];
    
    }
    
    // 根据viewControllers.count设置contentSize 这里的高度必须要比 self.contentScrollView.frame.size。height小，不然会有随便移动的效果
    _contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width * viewControllers.count, 0);
    
    //显示第一个控制器
    [self contentScrollViewShowPage:0];

}

#pragma mark -- 获取TopView
//获取顶部的控制滚动视 图，获取是为了把它添加到 titleView上去
-(UIView *)topControlViewWithFrame:(CGRect)frame titleLabelWidth:(CGFloat)titleLabelWidth;
{
 
    _titleLabelWidth = titleLabelWidth;
    
    // 创建导航的滚动视图，它的Frame在外面控制
    self.topScrollView.frame = frame;
    [self addSubview:self.topScrollView];
    
    //添加Label
    _titleLabelArray = [[NSMutableArray alloc] init];
    for (int i=0; i<_viewControllers.count; i++) {
        
        UIViewController *vc = _viewControllers[i];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelWidth * i, 0, titleLabelWidth, _topScrollView.frame.size.height)];
        label.text = vc.title;
        label.userInteractionEnabled = YES;
        
        // label 的Tag
        label.tag = i+100;
        // 设置显示中间
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        
        [_titleLabelArray addObject:label];
        
        // Label添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLabelCutScrollView:)];
        
        [label addGestureRecognizer:tap];
        [_topScrollView addSubview:label];
        
    }
    
    _topScrollView.contentSize = CGSizeMake(titleLabelWidth * _viewControllers.count, _topScrollView.frame.size.height);
    
    //添加提示线条滚动视图 设置Frame
    _topIndicatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0,20, titleLabelWidth, 2)];
    // 设置图片
    _topIndicatorView.image = [UIImage imageNamed:@"red_line_and_shadow.png"];
    
    // 下面的滚动线条 添加到滚动视图
    [_topScrollView addSubview:_topIndicatorView];
    
    // 显示第0张
    [self topScrollViewShowPage:0];
    return _topScrollView;
    
}

#pragma mark - 处理动画结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 根据scrollView 的tag 判断
    // 这里是判断是不是滚动的为 contentScrollView
    if(scrollView.tag == CONTENT_TAG)
    {
        //注意0除
        int page = scrollView.contentOffset.x / self.frame.size.width;
        [self topScrollViewShowPage:page];
        
    }
}

/**
 Label点击事件
 @param tap tap description
 */
-(void)clickLabelCutScrollView:(UITapGestureRecognizer *)tap
{
    int page = (int)tap.view.tag - 100;
    [self topScrollViewShowPage:page];
    [self contentScrollViewShowPage:page];
    
}

// 按照点击的滚动到那个控制器界面
-(void)topScrollViewShowPage:(int)page
{
    
    for (UILabel *label in _titleLabelArray) {
        //没有选中的Label的颜色
        label.textColor = [UIColor blackColor];
        //label.backgroundColor = [UIColor whiteColor];

    }
    // 选中的Label
    UILabel *selectLabel = _titleLabelArray[page];
    // 设置选中的Label的颜色
    selectLabel.textColor = [UIColor redColor];
    //selectLabel.backgroundColor = [UIColor blueColor];
    
    [UIView animateWithDuration:0.1 animations:^{
        // 设置下面线条的frame跟着选中Label的走
        _topIndicatorView.frame = selectLabel.frame;
        
    }];
}

// 根据设置_contentScrollView的ContentOffset属性控制显示哪一个控制器
-(void)contentScrollViewShowPage:(int)page
{
    
    [_contentScrollView setContentOffset:CGPointMake(page * _contentScrollView.frame.size.width, 0) animated:YES];

}

// 添加contentScrollView
-(UIScrollView * )contentScrollView
{
    if (_contentScrollView == nil) {
        
        //创建contentScrollView Frame 是根据 SliderView 的大小
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.tag = CONTENT_TAG;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.delegate = self;
        _contentScrollView.bounces = NO;
        
    }
    
    return _contentScrollView;
}

// 添加topScrollView
-(UIScrollView *)topScrollView
{
    if (_topScrollView == nil) {
        
        //导航上的滚动视图
        _topScrollView = [[UIScrollView alloc] init];
        _topScrollView.tag = TOP_TAG;
        _topScrollView.showsHorizontalScrollIndicator = NO;
        _topScrollView.showsVerticalScrollIndicator = NO;
        _topScrollView.delegate = self;
    }
    
    return _topScrollView;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
