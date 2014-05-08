#import "AttachmentView.h"

@implementation AttachmentView

- (id)init {
    self = [super init];
    if (self) {
        [self addGravity];
    }
    return self;
}

- (void)addGravity {
    theAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
//    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[ballView]];
//    [theAnimator addBehavior:gravityBehaviour];
    UIImage *image1 = [UIImage imageNamed:@"navi_over_dial_ppointer"];
    UIImageView<UIDynamicItem> *imageVC = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    imageVC.transform = CGAffineTransformMakeRotation(M_PI);
    imageVC.center = CGPointMake(30, 4);
    UIImageView<UIDynamicItem> *imageVC1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    imageVC.transform = CGAffineTransformMakeRotation(0.0);
    imageVC.center = CGPointMake(30, 4);
    UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:ballView attachedToAnchor:CGPointMake(100, 0)];
//    UIAttachmentBehavior *attachmentB = [[UIAttachmentBehavior alloc]initWithItem:imageVC1 attachedToItem:imageVC];
    UIAttachmentBehavior *attachmentB = [[UIAttachmentBehavior alloc]initWithItem:<#(id<UIDynamicItem>)#> offsetFromCenter:<#(UIOffset)#> attachedToItem:<#(id<UIDynamicItem>)#> offsetFromCenter:<#(UIOffset)#>];
    [attachmentBehavior setLength:30];
    [attachmentBehavior setDamping:0.1];
    [attachmentBehavior setFrequency:5];
    
    [attachmentB setLength:30];
    [attachmentB setDamping:0.1];
    [attachmentB setFrequency:5];
    [theAnimator addBehavior:attachmentB];

}
@end