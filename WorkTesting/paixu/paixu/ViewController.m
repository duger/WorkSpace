//
//  ViewController.m
//  paixu
//
//  Created by Duger on 14-3-12.
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
    NSTimer *timer = [[NSTimer alloc]init];
    [timer fire];
    __block NSMutableArray *temp1 = [NSMutableArray arrayWithArray: @[@2,@34,@56]];
    __block NSMutableArray *temp2 = [NSMutableArray arrayWithArray: @[@1,@35,@4]];
    __block NSMutableArray *temp3 = [NSMutableArray arrayWithArray: @[@5,@67,@21]];

    __block NSMutableArray *stringArray = [NSMutableArray arrayWithObjects:temp1,temp2,temp3,nil];
    typedef void(^testBlock)(NSMutableArray*,NSMutableArray*);
    

//    void(^testBlock)(NSMutableArray* ,NSMutableArray*) = ^(NSMutableArray *temp,NSMutableArray *array1) {
//        [array1 removeObject:temp];
//};
    NSComparator sortBlock = ^(id string1, id string2)
    {
        testBlock bc = ^(NSMutableArray *temp,NSMutableArray *array1) {
            [array1 removeObject:temp];
        };
        
        if ([string1 count] > 1 && [string2 count] > 1) {
            bc(string1, stringArray);
        return NSOrderedSame;
            
        }else
            return NSOrderedSame;
    };
    
    NSArray *sortArray = [stringArray sortedArrayUsingComparator:sortBlock];
    NSLog(@"sortArray:%@", sortArray);
    
    NSLog(@"wangfu before %d",stringArray.count);
    
    [stringArray removeObjectAtIndex:2];
    
    NSLog(@"wangfu after %d",stringArray.count);
    UIScrollView
    NSLog(@"%f",[timer timeInterval]);
    [timer invalidate];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
