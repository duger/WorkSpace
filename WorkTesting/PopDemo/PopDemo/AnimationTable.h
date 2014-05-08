//
//  AnimationTable.h
//  PopDemo
//
//  Created by 张永峰 on 5/6/14.
//  Copyright (c) 2014 zhangyongfeng. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    AnimationType_Flip,
    AnimationType_ShakerH,
    AnimationType_ShakerV,
    AnimationType_Scale,
} AnimationType;



@interface AnimationTable : UITableView


@property (nonatomic,assign) AnimationType type;

- (void)showCellAnimation:(BOOL)dismiss;

@end
