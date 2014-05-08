//
//  PopMainViewController.h
//  PopDemo
//
//  Created by 张永峰 on 4/29/14.
//  Copyright (c) 2014 zhangyongfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopAnimationDefines.h"
@interface PopMainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) UITableView *  list;
@property (nonatomic,retain) NSMutableArray *      animationInfos;
@end
