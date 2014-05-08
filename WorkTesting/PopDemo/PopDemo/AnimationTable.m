//
//  AnimationTable.m
//  PopDemo
//
//  Created by 张永峰 on 5/6/14.
//  Copyright (c) 2014 zhangyongfeng. All rights reserved.
//

#import "AnimationTable.h"
#import "Pop/POP.h"

@interface AnimationTable ()
{
    AnimationType _type;
}
@property (nonatomic,assign) SEL currentAniAction;
@property (nonatomic,retain) NSMutableSet * currentAnimations;
@property (nonatomic,retain) UIRotationGestureRecognizer * rotationGest;
@property (nonatomic,retain) UIPanGestureRecognizer * panGest;
@property (nonatomic,assign) CGPoint first;
@end

@implementation AnimationTable


#pragma mark  ovewrite tableview

- (void)dealloc
{
    [_currentAnimations release];
    [_rotationGest release];
    [_panGest release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        _type = AnimationType_ShakerH;
        _currentAniAction = @selector(showAnimationShakerH:);
        self.currentAnimations = [NSMutableSet set];
        _rotationGest = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationAction:)];
        [self addGestureRecognizer:_rotationGest];
        _panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        _panGest.enabled = NO;
        [self addGestureRecognizer:_panGest];
    }
    return self;
}


- (void)reloadData
{
    [super reloadData];
    [self showCellAnimation:NO];
}




- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [super reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    
}


- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [super reloadSections:sections withRowAnimation:animation];
}

- (void)setType:(AnimationType)type
{
    if (type == _type) {
        return;
    }
    _type = type;
    switch (_type) {
        case AnimationType_Flip:
            _currentAniAction = @selector(showAnimationFlip:);
            break;
        case AnimationType_ShakerH:
            _currentAniAction = @selector(showAnimationShakerH:);
            break;
        case AnimationType_ShakerV:
            _currentAniAction = @selector(showAnimationShakerV:);
            break;
        case AnimationType_Scale:
            _currentAniAction = @selector(showAnimationScale:);
            break;
        default:
            break;
    }
}

#pragma mark instance menthod
- (void)panAction:(UIPanGestureRecognizer *)pan
{
    CGPoint touchPoint = [pan locationInView:self];
    if (pan.state == UIGestureRecognizerStateBegan) {
        _first = touchPoint;
    }else if (pan.state == UIGestureRecognizerStateChanged){
        NSIndexPath  * selecePath = [self indexPathForRowAtPoint:touchPoint];
        CGFloat selectrow = selecePath.row;
        NSArray * allPath = [[self indexPathsForVisibleRows] retain];
        CGFloat widthgap = touchPoint.x - _first.x;
        for (NSIndexPath * path in allPath) {
            CGFloat pathrow = path.row;
            POPBasicAnimation * panAni = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerTranslationX];
            panAni.additive = NO;
            CGFloat scale = 1.0f/(fabsf(selectrow - pathrow)/2.0+1);
            panAni.toValue = [NSNumber numberWithFloat:widthgap*scale];
            UITableViewCell * cell = [self cellForRowAtIndexPath:path];
            [cell.layer pop_addAnimation:panAni forKey:@"panani"];
        }
        [allPath release];
    }else if(pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateFailed){
        NSArray * cells = [[self visibleCells] retain];
        for (UITableViewCell * cell in cells) {
            POPSpringAnimation * sppan = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationX];
            sppan.toValue = [NSNumber numberWithFloat:0];
            [cell.layer pop_addAnimation:sppan forKey:@"panani"];
        }
        pan.enabled = NO;
        [cells release];
    }
}
- (void)rotationAction:(UIRotationGestureRecognizer *)gest
{
    NSArray * cells = [[self visibleCells] retain];
    int count = [cells count];
    if (gest.state == UIGestureRecognizerStateChanged) {
        CGFloat gap = gest.rotation/(CGFloat)count;
        for (int index = 0; index < count; index ++) {
            UITableViewCell * cell  = [cells objectAtIndex:index];
            POPBasicAnimation * rotation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
            rotation.removedOnCompletion = YES;
            rotation.completionBlock = ^(POPAnimation * pop ,BOOL finished){
            };
            
            rotation.additive = NO;
            CGFloat param = gap*(1+index);
            CGFloat value = fabsf(param) - M_PI_2 >= 0 ? (M_PI_2)*(fabsf(param)/param) :gap*(1+index);
            rotation.toValue = [NSNumber numberWithFloat:value];
            [cell.layer pop_addAnimation:rotation forKey:@"cellanimatiomflip"];
        }
    }else if(gest.state == UIGestureRecognizerStateEnded || gest.state == UIGestureRecognizerStateCancelled || gest.state == UIGestureRecognizerStateFailed){
        for (int index = 0; index < count; index ++) {
            UITableViewCell * cell  = [cells objectAtIndex:index];
            POPSpringAnimation * rotation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
            rotation.completionBlock = ^(POPAnimation * pop ,BOOL finished){
                [_currentAnimations removeObject:rotation];
            };
            rotation.additive = NO;
            rotation.toValue = [NSNumber numberWithFloat:0];
            [_currentAnimations addObject:rotation];
            [cell.layer pop_addAnimation:rotation forKey:@"cellanimatiomflip"];
        }
        
    }else {
//        for (int index = 0; index < count; index ++) {
//            UITableViewCell * cell  = [cells objectAtIndex:index];
//            [cell.layer pop_removeAllAnimations];
//        }
    }
    
    
    [cells release];
}

- (void)resetCells:(NSArray *)cells
{
    for (UITableViewCell * cell in cells) {
        cell.layer.transform = CATransform3DIdentity;
        cell.transform = CGAffineTransformIdentity;
    }
}

//横向反弹
- (void)showAnimationShakerH:(BOOL)dismiss
{
    NSArray * cells = [[self visibleCells] retain];
    CGFloat halfwith = self.frame.size.width/2.0f;
    CGFloat count = [cells count];
    for (int cellIndex = 0; cellIndex < [cells count]; cellIndex ++) {
        UITableViewCell * cell = [cells objectAtIndex:cellIndex];
        POPSpringAnimation * springAni = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
        springAni.completionBlock = ^(POPAnimation *anim, BOOL finished){
            [_currentAnimations removeObject:anim];
        };
        springAni.additive = NO;
        CGPoint center = [cell center];
        if (!dismiss) {
            center.x = halfwith;
            springAni.toValue = [NSValue valueWithCGPoint:center];
            center.x += (cellIndex+1)*halfwith;
            springAni.fromValue = [NSValue valueWithCGPoint:center];
        }else{
            center.x += (cellIndex+1)*halfwith;
            springAni.toValue = [NSValue valueWithCGPoint:center];
        }
        springAni.springBounciness = 10.0f/count*(cellIndex+1);
        springAni.springSpeed = (20.f/count) * (cellIndex +1)*0.2;
        [_currentAnimations addObject:springAni];
        [cell.layer pop_addAnimation:springAni forKey:@"cellanimationshakerh"];
    }
    [cells release];
}

//垂直抖动
- (void)showAnimationShakerV:(BOOL)dismiss
{
    NSArray * cells = [[self visibleCells] retain];
    NSInteger count = [cells count];
    for (int index = 0; index < count; index ++) {
        UITableViewCell * cell = [cells objectAtIndex:index];
        POPSpringAnimation * springAni = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
        springAni.completionBlock = ^(POPAnimation *anim, BOOL finished){
            [_currentAnimations removeObject:anim];
        };
        springAni.additive = NO;
        CGFloat celly = cell.center.y;
        if (!dismiss) {
            springAni.toValue = [NSNumber numberWithFloat:0];
            springAni.fromValue = [NSNumber numberWithFloat:(count + 1 - index)*celly];
        }else{
            springAni.fromValue = [NSNumber numberWithFloat:0];
            springAni.toValue = [NSNumber numberWithFloat:(count + 1 - index)*celly];
        }
        springAni.springSpeed = 0.5*(count + 1 - index);
        [_currentAnimations addObject:springAni];
        [cell.layer pop_addAnimation:springAni forKey:@"cellanimationshakerv"];
    }
    
    [cells release];
}
//翻转

- (void)showAnimationFlip:(BOOL)dismiss
{
    NSArray * cells = [[self visibleCells] retain];
    NSInteger count = [cells count];
    for (int index = 0; index < count; index ++) {
        UITableViewCell * cell = [cells objectAtIndex:index];
        POPSpringAnimation * springAni = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
        springAni.completionBlock = ^(POPAnimation *anim, BOOL finished){
            [_currentAnimations removeObject:anim];
        };
        cell.layer.transform = CATransform3DIdentity;
        springAni.additive = NO;
        if (!dismiss) {
            springAni.fromValue = [NSNumber numberWithFloat:M_PI_2*(index+1)];
            springAni.toValue = [NSNumber numberWithFloat:0];
        }else{
            
        }
        springAni.springBounciness = 20.0F/((index +1)/2.0f);
        springAni.springSpeed = 0.02*(index +1);
        [_currentAnimations addObject:springAni];
        [cell.layer pop_addAnimation:springAni forKey:@"cellanimatiomflip"];
    }
    [cells release];
}
//缩放
- (void)showAnimationScale:(BOOL)dismiss
{
    
    NSArray * cells = [[self visibleCells] retain];
    NSInteger count = [cells count];
    for (int index = 0; index < count; index ++) {
        UITableViewCell * cell = [cells objectAtIndex:index];
        POPSpringAnimation * springAni = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleX];
        springAni.completionBlock = ^(POPAnimation *anim, BOOL finished){
            [_currentAnimations removeObject:anim];
        };
        cell.layer.transform = CATransform3DIdentity;
        springAni.additive = NO;
        if (!dismiss) {
            springAni.fromValue = [NSNumber numberWithFloat:1.0/(CGFloat)count*index/4.0f];
            springAni.toValue = [NSNumber numberWithFloat:1];
        }else{
            springAni.fromValue = [NSNumber numberWithFloat:1];
            springAni.toValue = [NSNumber numberWithFloat:0];
        }
        springAni.springBounciness = 20.0f/(index/4.0 +1);
        springAni.springSpeed = 0.03*(index +1);
        [_currentAnimations addObject:springAni];
        [cell.layer pop_addAnimation:springAni forKey:@"cellanimatiomscale"];
    }
    [cells release];
}

- (void)showCellAnimation:(BOOL)dismiss
{
    NSMethodSignature *sig= [[AnimationTable class] instanceMethodSignatureForSelector:_currentAniAction];
    NSInvocation * invoker = [NSInvocation invocationWithMethodSignature:sig];
    [invoker setSelector:_currentAniAction];
    [invoker setTarget:self];
    [invoker setArgument:&dismiss atIndex:2];
    [invoker retainArguments];
    [invoker invoke];
}

- (void)changePanEnable:(NSNumber *)enable
{
    _panGest.enabled = [enable boolValue];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray * animations = [_currentAnimations allObjects];
    for (POPAnimation * animation in animations) {
        animation.paused = YES;
    }
    [self performSelector:@selector(changePanEnable:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.3];
    [super touchesBegan:touches withEvent:event];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSArray * animations = [_currentAnimations allObjects];
    for (POPAnimation * animation in animations) {
        animation.paused = NO;
    }
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changePanEnable:) object:[NSNumber numberWithBool:YES]];
//    [self performSelector:@selector(changePanEnable:) withObject:[NSNumber numberWithBool:NO]];
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self showCellAnimation:YES];
//    [self performSelector:@selector(changePanEnable:) withObject:[NSNumber numberWithBool:YES]];
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray * animations = [_currentAnimations allObjects];
    for (POPAnimation * animation in animations) {
        animation.paused = NO;
    }
    [super touchesEnded:touches withEvent:event];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changePanEnable:) object:[NSNumber numberWithBool:YES]];
//    [self performSelector:@selector(changePanEnable:) withObject:[NSNumber numberWithBool:NO]];
}

@end
