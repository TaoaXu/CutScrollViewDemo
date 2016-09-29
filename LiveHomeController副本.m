//
//  LiveHomeController.m
//  MxsmNetwork
//
//  Created by mxsm on 16/9/26.
//  Copyright © 2016年 mxsm. All rights reserved.
//

#import "LiveHomeController.h"
#import "LiveViewController.h"
#import "ClassroomController.h"

#import "SliderView.h"

@interface LiveHomeController ()

@end

@implementation LiveHomeController

- (void)viewDidLoad {
   
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    // 创建两个子控制器
    [self CreatChildViewControllers];
    
    // 导航连设置不是半透明的
    self.navigationController.navigationBar.translucent = NO;
    
    /*
       http://blog.csdn.net/hcy_12345/article/details/48130345 上面有详细的介绍这个属性
       设置这个属性为UIRectEdgeNone，可以保证界面不延伸到导航和标签栏的下面去，这个属性默认是UIRectEdgeAll
     */
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}


/**
    创建 LiveController 和 ClassroomController 两个控制器
 */

-(void)CreatChildViewControllers

{
    
    // 直播控制器
    LiveViewController * liveController = [[LiveViewController alloc]init];
    liveController.title = @"直播";
    
    // 课堂控制器
    ClassroomController * classroomController =[[ClassroomController alloc]init];
    classroomController.title = @"课堂";
    //
    NSArray * controllerArray = @[liveController,classroomController];
    
    // SliderView 取LiveHomeController 的View的大小
    SliderView * sliderView = [[SliderView alloc]initWithFrame:self.view.frame];
    
    // 设置两个控制器
    [sliderView setViewControllers:controllerArray owner:self];
    [self.view addSubview:sliderView];

    // 前面 Frame 控制整个TopView 的大小 titleLabelWidth 控制Label的宽度
    UIView * TopView = [sliderView topControlViewWithFrame:CGRectMake(0, 0, 100, 40) titleLabelWidth:50];
    
    // 设置获取到的TopView 添加到titleview上
    self.navigationItem.titleView = TopView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
