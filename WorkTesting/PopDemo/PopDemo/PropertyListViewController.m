//
//  PropertyListViewController.m
//  PopDemo
//
//  Created by 张永峰 on 4/30/14.
//  Copyright (c) 2014 zhangyongfeng. All rights reserved.
//

#import "PropertyListViewController.h"
#import "PopAnimationDefines.h"
#import "AnimationView.h"
#import "AnimationTable.h"
@interface PropertyListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    AnimationTable *    _propertylist;
    AnimationView *     _animationView;
}
@end

@implementation PropertyListViewController

- (void)dealloc
{
    [_propertys release];
    [_animation release];
    [_animationView release];
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
    // Do any additional setup after loading the view.
    UIBarButtonItem * rightItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(resetAnimationView)];
    UIBarButtonItem * rightItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(showTableAnimation)];

    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightItem1,rightItem2, nil];
    [rightItem1 release];
    [rightItem2 release];
    self.propertys = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PopPropertySet" ofType:@"plist"]];
    _propertylist = [[AnimationTable alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _propertylist.delegate = self;
    _propertylist.dataSource = self;
    [self.view addSubview:_propertylist];
    
    POPSpringAnimation * springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    springAnimation.springSpeed = 0.1;
    springAnimation.springBounciness = 1;
    springAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(200, 20)];
    springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 200)];
    
    POPSpringAnimation * rotation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotation.springSpeed = 0.1;
    rotation.springBounciness = 2;
    rotation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    rotation.toValue = [NSValue valueWithCGPoint:CGPointMake(20, 20)];
    
    _animationView = [[AnimationView alloc] initWithFrame:CGRectMake(200, 150, 60, 60)];
    _animationView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_animationView];
    
    [_animationView.layer pop_addAnimation:springAnimation forKey:@"trans"];
    [_animationView.layer pop_addAnimation:rotation forKey:@"ration2"];
    
}

- (void)resetAnimationView
{
    [_animationView pop_removeAllAnimations];
    [_animationView.layer pop_removeAllAnimations];
    _animationView.layer.transform = CATransform3DIdentity;
    _animationView.alpha = 1;
    _animationView.transform = CGAffineTransformIdentity;
    _animationView.backgroundColor = [UIColor orangeColor];
    _animationView.frame = CGRectMake(200, 150, 60, 60);
//    Class tableClass = NSClassFromString(_animation);
//    id tableAnimation = [(id)tableClass performSelector:@selector(animation) withObject:nil];
//    POPAnimatableProperty * property = [POPAnimatableProperty propertyWithName:kPOPTableViewContentOffset];
//    [tableAnimation performSelector:@selector(setProperty:) withObject:property];
//    [tableAnimation performSelector:@selector(setVelocity:) withObject:[NSValue valueWithCGPoint:CGPointMake(0,150)]];
//    [_propertylist pop_addAnimation:tableAnimation forKey:@"offset"];
//    [_propertylist reloadData];
//    NSArray * cells = [_propertylist visibleCells];
//    int index = 0;
//    for (index = 0; index < [cells count]; index ++) {
//        [self showTabelViewCellAnimationFromIndex:index cell:[cells objectAtIndex:index]];
//    };
    [_propertylist showCellAnimation:NO];
}

- (void)showTableAnimation
{
    NSInteger current = _propertylist.type;
    current ++;
    current %=5;
    [_propertylist setType:current];
    [_propertylist showCellAnimation:NO];
}

- (void)showTabelViewCellAnimationFromIndex:(NSInteger)index cell:(UITableView *)cell
{

    POPSpringAnimation *  _cellAnimation = [POPSpringAnimation animation];
    _cellAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        
    };
    POPAnimatableProperty * cellAniproperty = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
    _cellAnimation.property = cellAniproperty;
    _cellAnimation.removedOnCompletion = YES;
    _cellAnimation.beginTime = index * 1;
    CGPoint cellCenter = cell.center;
    cellCenter.x = 320;
    _cellAnimation.springBounciness = 10;
    _cellAnimation.springSpeed = 2;
    _cellAnimation.fromValue = [NSValue valueWithCGPoint:cellCenter];
    cellCenter.x = _propertylist.frame.size.width/2.0f;
    _cellAnimation.toValue = [NSValue valueWithCGPoint:cellCenter];
    [cell.layer pop_addAnimation:_cellAnimation forKey:@"cellpx"];
}


#pragma mark tableview

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 150;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView * animationHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
//    animationHeader.backgroundColor = [UIColor whiteColor];
//    if (!_animationView) {
//        _animationView = [[AnimationView alloc] initWithFrame:CGRectMake(100, 15, 120, 120)];
//        _animationView.backgroundColor = [UIColor orangeColor];
//    }
//    
//    [animationHeader addSubview:_animationView];
//    return [animationHeader autorelease];
//}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CGRect frame = cell.frame;
//    frame.origin.x = 320;
//    cell.frame = frame;
//    NSLog(@"%@",NSStringFromCGRect(cell.frame));
//    cell.alpha = 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellindentifier = @"pcell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellindentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellindentifier] autorelease];
    }
    NSDictionary * info = [_propertys objectAtIndex:indexPath.row];
    cell.textLabel.text = [info valueForKey:POPINFO_KEY_PROPERTYNAME];
    cell.detailTextLabel.text = [info valueForKey:POPINFO_KEY_ANIMATIONNAME];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_propertys count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * selectinfo = [_propertys objectAtIndex:indexPath.row];
    if (_animation) {
        Class animationClass = NSClassFromString(_animation);
        POPPropertyAnimation * animation = [(id)animationClass performSelector:@selector(animation) withObject:nil];
        animation.removedOnCompletion = YES;
        Class class = NSClassFromString(@"POPAnimatableProperty");
        if ([class isSubclassOfClass:[POPAnimatableProperty class]]) {
            POPAnimatableProperty * proproperty = [POPAnimatableProperty propertyWithName:[selectinfo valueForKey:POPINFO_KEY_PROPERTYNAME]];
            NSString * valueClassString = [selectinfo valueForKey:POPINFO_KEY_VALUECLASS];
            NSString * fromvalue = [selectinfo valueForKey:POPINFO_KEY_FROMVALUE];
            NSString * tovalue = [selectinfo valueForKey:POPINFO_KEY_TOVALUE];
            id fromobj = nil;
            id toobj = nil;
            if ([valueClassString isEqualToString:@"UIColor"]) {
                
                UIColor * fromColor =[self colorFromHexString:fromvalue]?_animationView.backgroundColor : [self colorFromHexString:fromvalue];
                fromobj = (id)fromColor.CGColor;
                toobj = (id)[self colorFromHexString:tovalue].CGColor;
            }else if ([valueClassString isEqualToString:@"CGSize"]){
                CGSize fromSize = _animationView.frame.size;
                if ([fromvalue length] && fromvalue) {
                    fromSize = CGSizeFromString(fromvalue);
                }
                fromobj = [NSValue valueWithCGSize:fromSize];
                toobj = [NSValue valueWithCGSize:CGSizeFromString(fromvalue)];
            }else if ([valueClassString isEqualToString:@"CGRect"]){
                CGRect fromRect = _animationView.frame;
                if (fromvalue && [fromvalue length] > 0) {
                    fromRect = CGRectFromString(fromvalue);
                }
                fromobj = [NSValue valueWithCGRect:fromRect];
                toobj = [NSValue valueWithCGRect:CGRectFromString(tovalue)];
            }else if ([valueClassString isEqualToString:@"CGPoint"]){
                CGPoint fromPoint = _animationView.center;
                if (fromvalue && [fromvalue length] > 0) {
                    fromPoint = CGPointFromString(fromvalue);
                }
                fromobj = [NSValue valueWithCGPoint:fromPoint];
                toobj = [NSValue valueWithCGPoint:CGPointFromString(tovalue)];
            }
            else {
                fromobj = [NSNumber numberWithFloat:[fromvalue floatValue]];
                toobj = [NSNumber numberWithFloat:[tovalue floatValue]];
            }
            if ([animation isKindOfClass:[POPSpringAnimation class]]) {
                POPSpringAnimation * spring = (POPSpringAnimation*)animation;
//                [spring setVelocity:toobj];
                [spring setSpringSpeed:0.1];
                [spring setSpringBounciness:10];
                [spring setDynamicsFriction:1];
                [spring setDynamicsMass:1];
                [spring setDynamicsTension:1];
                animation.fromValue = fromobj;
                animation.toValue = toobj;
            }else if ([animation isKindOfClass:[POPDecayAnimation class]]){
                POPDecayAnimation * decay = (POPDecayAnimation *)animation;
                //通过设置 velocity 和减速 实现
                decay.velocity = toobj;
                decay.deceleration = 0.998;
            }
            animation.property = proproperty;
            
            animation.delegate = _animationView;
            [_animationView.layer pop_addAnimation:animation forKey:valueClassString];
        }
    }
}



- (UIColor *)colorFromHexString:(NSString *)hexSting
{

    if ([hexSting length] != 6) {
        return nil;
    }
    UIColor * color = nil;

    NSScanner * scanner = [NSScanner scannerWithString:hexSting];
    [scanner setScanLocation:4];
    unsigned  b = 0;
    [scanner scanHexInt:&b];
    [scanner setScanLocation:2];
    unsigned  g = 0;
    [scanner scanHexInt:&g];
    [scanner setScanLocation:0];
    unsigned  r = 0;
    [scanner scanHexInt:&r];
    color = [UIColor colorWithRed:(r/(256*256))/255.0 green:g/255.0/255.0 blue:b/255.0 alpha:1];
    
    return color;
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
