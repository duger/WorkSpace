//
//  main.c
//  test3
//
//  Created by Duger on 14-3-4.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

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


int main(int argc, const char * argv[])
{

    float x, y;
    scanf("%f", &x);
    y = Newton(x);
    y = (int)(1000.0 * y + 0.5) / 1000.0;
    printf("%f", y);
    // insert code here...
    printf("Hello, World!\n");
    return 0;
}

