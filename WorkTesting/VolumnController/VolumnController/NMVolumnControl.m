//
//  NMVolumnControl.m
//  VolumnController
//
//  Created by Duger on 14-4-28.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "NMVolumnControl.h"

@implementation NMVolumnControl

static  NMVolumnControl *s_NMVolumnControl = nil;
+(NMVolumnControl *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_NMVolumnControl = [[self alloc]init];
    });
    return s_NMVolumnControl;
}


/* something has caused your audio session to be interrupted */
- (void)beginInterruption
{
    
}
/* the interruption is over */
/* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
- (void)endInterruptionWithFlags:(NSUInteger)flags
{
    
}
/* endInterruptionWithFlags: will be called instead if implemented. */
- (void)endInterruption
{
    
}

/* notification for input become available or unavailable */
- (void)inputIsAvailableChanged:(BOOL)isInputAvailable
{
    
}
@end
