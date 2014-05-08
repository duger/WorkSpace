//
//  main.m
//  Test
//
//  Created by Duger on 14-3-4.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

#include <stdio.h>

bool equal(float x, float y){
	float t = x - y, eps = 1e-4;
	if(t < eps && t > -eps) return true;
	return false;
}
float Newton(float x)
{
	float yk = x, yka1 = 1;//不要从0开始迭代。。否则第一步就会挂掉
	x = (int)(10000.0 * x + 0.5) / 10000.0;
	yk = (int)(10000.0 * yk + 0.5) / 10000.0;
	while(1)
	{
		if(equal(yk, yka1))//浮点数不要直接判相等。。自己写个比较函数。。
			break;
		else
		{
			yk = yka1;
			yka1 = 1.0 / 2 * (yk + x / yk);//你这里1/2直接等于0了。。
			yka1 = (int)(10000.0 * yka1 + 0.5) / 10000.0;
		}
	}
	return yka1;
}


float InvSqrt(float x)
{    float xhalf = 0.5f*x;
    int i = *(int*)&x; // get bits for floating value
    i = 0x5f375a86- (i>>1); // gives initial guess y0
    x = *(float*)&i; // convert bits back to float
    x = x*(1.5f-xhalf*x*x); // Newton step, repeating increases accuracy
    return x;
}


int main(int argc, char * argv[])
{
    @autoreleasepool {
        
        log(<#double#>)
        float x, y;
//        scanf("%f", &x);
        x = 64.0f;
//        y = Newton(x);
        y = InvSqrt(x);
        NSLog(@"测试%f",y);
        y = (int)(1000.0 * y + 0.5) / 1000.0;
        printf("%f", y);
        NSLog(@"%f",y);
        
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        
    }
}
