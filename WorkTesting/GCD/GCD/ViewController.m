//
//  ViewController.m
//  GCD
//
//  Created by Duger on 14-4-17.
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
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        ;
    });
    dispatch_sync(<#dispatch_queue_t queue#>, <#^(void)block#>);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        <#code to be executed once#>
    });
    
    dispatch_group_create()
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
