//
//  CoreAnimationViewController.m
//  PopDemo
//
//  Created by 张永峰 on 5/7/14.
//  Copyright (c) 2014 zhangyongfeng. All rights reserved.
//

#import "CoreAnimationViewController.h"

@interface CoreAnimationViewController ()
@property (nonatomic,retain) CALayer * image;
@end

@implementation CoreAnimationViewController

- (void)dealloc
{
    [_image release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone
        ;
    }
    _image = [[CALayer layer] retain];
    _image.contentsScale = [[UIScreen mainScreen] scale];
    UIImage * image = [UIImage imageNamed:@"u=1320376490,958232654&fm=23&gp=0.jpg"];
    _image.contents = (id)[image CGImage];
    CGRect bound = _image.bounds;
    bound.size = CGSizeMake(300, 300);
    _image.position = CGPointMake(160, 150);
    _image.bounds = bound;
    [self.view.layer addSublayer:_image];
    
//    _image.contentsRect = CGRectMake(0.5, 0.0, 0.5, 0.5);
    
    UIButton * play = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    play.frame = CGRectMake(100, 390, 120, 40);
    [play setTitle:@"play" forState:UIControlStateNormal];
    play.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:play];
    [play addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)playAction
{
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:5.0f]
                     forKey:kCATransactionAnimationDuration];
//    _image.zPosition = 200.0;
//    _image.opacity = 0.0;
    _image.contentsCenter = CGRectMake(0.,0.2,0.8,0.8);
    [CATransaction commit];

}

- (void)showFromRightToLeft
{
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"contentsRect"];
    animation.removedOnCompletion = YES;
    animation.duration = 2.f;
    animation.fromValue = [NSValue valueWithCGRect:CGRectMake(1, 1, 0, 0)];
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 1, 1)];
    [_image addAnimation:animation forKey:@"contenrect"];
}

- (void)changeCorner
{
    _image.borderColor = [[UIColor orangeColor] CGColor];
    _image.borderWidth = 1;
    _image.cornerRadius = 10;
    _image.masksToBounds = YES;
}

- (void)changContenGv
{
    _image.contentsGravity = kCAGravityRight;
}

- (void)changPositionZ
{
    _image.zPosition = 1.5f;
}

- (void)changePosition
{
    _image.position = CGPointMake(0, 0);
}

- (void)changeContentRect
{
    _image.contentsRect = CGRectMake(0, 0, 0.5, 0.5);
}

- (void)changeContentCeter
{
    _image.contentsCenter = CGRectMake(0.5, 0.5, 0.5, 0.5);
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
