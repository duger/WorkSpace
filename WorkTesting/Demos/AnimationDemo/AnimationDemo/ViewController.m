//
//  ViewController.m
//  AnimationDemo
//
//  Created by Duger on 14-3-25.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //主要功能通过UIView动画完成2个试图控制器的切换
    
    self.blueController = [[BlueViewController alloc] initWithNibName:nil bundle:nil];
    //设置导航控制器view的大小占整个屏幕
    [self.blueController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height)];
    
    self.yellowController = [[YellowController alloc]initWithNibName:nil bundle:nil ];
    [self.yellowController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height)];
    //将2个控制器view插入到目前导航控制器视图上，yellowController后插入，显示在最前面
    [self.view insertSubview:self.blueController.view atIndex:0];
    [self.view insertSubview:self.yellowController.view atIndex:1];
    //创建导航控制器右按钮，按钮名字叫next
    //添加buttonPressed 事件
    self.rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"next" style:UIBarButtonItemStylePlain target:self action:@selector(buttonPressed)];
    //将按钮添加到导航控制器默认右按钮上
    self.navigationItem.rightBarButtonItem = self.rightBarItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonPressed
{
    //  交换本视图控制器中2个view位置
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    //UIView开始动画，第一个参数是动画的标识，第二个参数附加的应用程序信息用来传递给动画代理消息
    [UIView beginAnimations:@"View Flip" context:nil];
    //动画持续时间
    [UIView setAnimationDuration:1.25];
    //设置动画的回调函数，设置后可以使用回调方法
    [UIView setAnimationDelegate:self];
    //设置动画曲线，控制动画速度
    [UIView  setAnimationCurve: UIViewAnimationCurveEaseInOut];
    //设置动画方式，并指出动画发生的位置
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view  cache:YES];
    //提交UIView动画
    [UIView commitAnimations];
}


@end
