//
//  AnimationView.m
//  PopDemo
//
//  Created by 张永峰 on 5/3/14.
//  Copyright (c) 2014 zhangyongfeng. All rights reserved.
//

#import "AnimationView.h"

@implementation AnimationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.animations = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)dealloc
{
    [_animations release];
    [super dealloc];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (POPAnimation * animation in _animations) {
        [animation setPaused:YES];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (POPAnimation * animation in _animations) {
        [animation setPaused:NO];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (POPAnimation * animation in _animations) {
        [animation setPaused:NO];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)pop_animationDidStart:(POPAnimation *)anim
{
    [_animations addObject:anim];
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished
{
    [_animations removeObject:anim];
}

@end
