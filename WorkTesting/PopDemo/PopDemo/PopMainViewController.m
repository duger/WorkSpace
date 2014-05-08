//
//  PopMainViewController.m
//  PopDemo
//
//  Created by 张永峰 on 4/29/14.
//  Copyright (c) 2014 zhangyongfeng. All rights reserved.
//
#import "PopMainViewController.h"
#import "PropertyListViewController.h"
#import "POP.h"
#import "CoreAnimationViewController.h"
#define BLUECOLOR [UIColor colorWithRed:0 green:174/255.0 blue:255.0/255.0f alpha:1]
@interface PopMainViewController ()
{
    UIView *        _animationView ;
    UIButton *      _playBtn;
}
@end

@implementation PopMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    [_animationView release];
    [_list release];
    [_playBtn release];
    [_animationInfos release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    _animationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    _animationView.backgroundColor = BLUECOLOR;
//    _animationView.layer.shadowColor = [[UIColor orangeColor] CGColor];
//    _animationView.layer.shadowOpacity = 1.0f;
//    _animationView.layer.shadowOffset = CGSizeMake(0, 1);
//    _animationView.opaque = YES;
//    _animationView.center = self.view.center;
//    [self.view addSubview:_animationView];
    self.title = @"PopAnimation";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.animationInfos = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PopAnimationSet" ofType:@"plist"]]];
    NSDictionary * cainfo = [NSDictionary dictionaryWithObjectsAndKeys:@"Coreanimation",POPINFO_KEY_ANIMATIONNAME, nil];
    [_animationInfos addObject:cainfo];
    CGRect frame = self.view.frame;
    _playBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _playBtn.frame = CGRectMake(110,frame.size.height - 80, 100, 50);
    _playBtn.backgroundColor = BLUECOLOR;
    _playBtn.layer.cornerRadius = 3;
    [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(playBtnAtion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playBtn];
    
    _list = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _list.delegate = self;
    _list.dataSource = self;
    [self.view addSubview:_list];
    
}

- (void)playBtnAtion
{
//    POPDecayAnimation * springAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerTranslationX];
//    springAnimation.removedOnCompletion = YES;
//    springAnimation.velocity = [NSNumber numberWithFloat:-100];
//    [_animationView.layer pop_addAnimation:springAnimation forKey:@"pop"];
    
    POPBasicAnimation * popBasicAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBounds];
    popBasicAnimation.removedOnCompletion = YES;
    popBasicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    popBasicAnimation.duration = 3;
    popBasicAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 300, 300)];
    [_animationView.layer pop_addAnimation:popBasicAnimation forKey:@"12"];
    
//    POPSpringAnimation * springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
//    springAnimation.removedOnCompletion = YES;
////    springAnimation.velocity = [NSNumber numberWithFloat:1.0f];
////    POPAnimatableProperty * property = [POPAnimatableProperty propertyWithName:kPOPLayerBounds initializer:^(POPMutableAnimatableProperty *prop) {
////        
////    }];
//    springAnimation.springBounciness = 20;
//    springAnimation.springSpeed = 1.5;
//    springAnimation.additive = NO;
//    springAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
//        NSLog(@" 完成 %@  %@",NSStringFromClass([anim class]),NSStringFromCGRect(_animationView.frame));
//    };
//    springAnimation.velocity = [NSValue valueWithCGRect:CGRectMake(0, 0, 450, 450)];
//    
//    springAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 100, 100)];
//    springAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 300, 300)];
//    [_animationView.layer pop_addAnimation:springAnimation forKey:@"spring"];
    
    
}

#pragma mark tableview

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellInd = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellInd];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellInd] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary * info = [_animationInfos objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [info valueForKey:POPINFO_KEY_ANIMATIONNAME];
    cell.detailTextLabel.text = [info valueForKey:POPINFO_KEY_PROPERTYNAME];
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_animationInfos count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row !=2) {
        NSDictionary * animationinfo = [_animationInfos objectAtIndex:indexPath.row];
        
        PropertyListViewController * proMVC = [[PropertyListViewController alloc] init];
        proMVC.title = [animationinfo valueForKey:POPINFO_KEY_ANIMATIONNAME];
        proMVC.animation = [animationinfo valueForKey:POPINFO_KEY_CLASSNAME];
        [self.navigationController pushViewController:proMVC animated:YES];
        [proMVC release];
    }else{
        CoreAnimationViewController * coreAnimationVC = [[CoreAnimationViewController alloc] init];
        [self.navigationController pushViewController:coreAnimationVC animated:YES];
        [coreAnimationVC release];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
