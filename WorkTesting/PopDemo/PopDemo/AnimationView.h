//
//  AnimationView.h
//  PopDemo
//
//  Created by 张永峰 on 5/3/14.
//  Copyright (c) 2014 zhangyongfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POPAnimation.h"
@interface AnimationView : UIView <POPAnimationDelegate>

@property (nonatomic,retain) NSMutableArray * animations;



@end
