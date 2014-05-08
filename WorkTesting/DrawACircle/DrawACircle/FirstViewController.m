//
//  FirstViewController.m
//  DrawACircle
//
//  Created by Duger on 14-4-30.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIBezierPath *path=[[UIBezierPath alloc]init];
    [path addArcWithCenter:CGPointMake(160, 15) radius:120 startAngle:M_PI endAngle:2*M_PI clockwise:NO];
    CAShapeLayer *arcLayer = [[CAShapeLayer alloc]init];
    arcLayer.path = path.CGPath;
    arcLayer.strokeColor = [UIColor blackColor].CGColor;
    arcLayer.fillColor = [UIColor whiteColor].CGColor;
    arcLayer.lineWidth = 4;
    arcLayer.frame = CGRectMake(0, 0,self.transformView.bounds.size.width , self.transformView.bounds.size.height);
    [self.transformView.layer insertSublayer:arcLayer atIndex:0];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickButton:(UIButton *)sender {
    
    CABasicAnimation *animation = [CABasicAnimation  animationWithKeyPath:@"affineTransform"];
    animation.toValue = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeRotation(0.2*M_PI)];
//    animation.duration =.4;
    animation.cumulative =YES;
    animation.repeatCount=2;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.transformView.layer addAnimation:animation forKey:@"animation"];
}
@end
