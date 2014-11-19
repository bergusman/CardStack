//
//  CardStack.m
//  CardStack
//
//  Created by Vitaly Berg on 19/11/14.
//  Copyright (c) 2014 Vitaly Berg. All rights reserved.
//

#import "CardStack.h"

@interface CardStack ()

@property (strong, nonatomic) NSArray *innerCards;
@property (strong, nonatomic) UIDynamicAnimator *dynamicAnimator;
@property (strong, nonatomic) UIAttachmentBehavior *attachment;


@end

@implementation CardStack

#pragma mark - Content

- (void)setCards:(NSArray *)cards {
    _cards = cards;
    
    NSMutableArray *innerCards = [NSMutableArray array];
    for (UIView *card in cards) {
        UIView *innerCard = [[UIView alloc] init];
        innerCard.frame = self.bounds;
        //innerCard.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:innerCard];
        
        [innerCard addSubview:card];
        card.frame = innerCard.bounds;
        card.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
        [innerCard addGestureRecognizer:pan];
        
        innerCard.alpha = 0;
        
        [innerCards addObject:innerCard];
    }
    
    self.innerCards = innerCards;
    
    [self order];
}

- (CGAffineTransform)transformWithLevel:(NSInteger)level {
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformMakeTranslation(0, -15 * level);
    transform = CGAffineTransformScale(transform, 1 - (0.05 * level), 1 - (0.05 * level));
    return transform;
}

- (void)order {
    NSInteger count = 4;
    for (NSInteger i = 0; i < count; i++) {
        NSInteger index = (self.topCard + i) % self.cards.count;
        UIView *innerCard = self.innerCards[index];
        
        innerCard.alpha = 1;
        
        [self sendSubviewToBack:innerCard];
        
        innerCard.bounds = self.bounds;
        innerCard.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        innerCard.transform = [self transformWithLevel:i];
    }
}
/*
 */

- (IBAction)didPan:(UIPanGestureRecognizer *)pan {
    UIView *view = pan.view;
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.dynamicAnimator = [[UIDynamicAnimator alloc] init];
        
        CGPoint p = [pan locationInView:view];
        
        CGPoint c = CGPointMake(view.bounds.size.width / 2, view.bounds.size.height / 2);
        
        self.attachment =  [[UIAttachmentBehavior alloc] initWithItem:view offsetFromCenter:UIOffsetMake(p.x - c.x, p.y - c.y) attachedToAnchor:[pan locationInView:self]];
        
        [self.dynamicAnimator addBehavior:self.attachment];
        
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        
        [self.attachment setAnchorPoint:[pan locationInView:self]];
    } else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        [self.dynamicAnimator removeBehavior:self.attachment];
  
        
        CGPoint v = [pan velocityInView:self];
        
        if (sqrt(v.x * v.x + v.y * v.y) > 300) {
            //[self.dynamicAnimator removeBehavior:self.snap];
            
            UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc] initWithItems:@[view]];
            [item addLinearVelocity:v forItem:view];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self pop];
            });
            
            [self.dynamicAnimator addBehavior:item];
        }
    }
}

/*
- (void)didPan:(UIPanGestureRecognizer *)pan {
    UIView *view = pan.view;
    
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [pan translationInView:self];
        
        CGPoint center = view.center;
        center.y = self.bounds.size.height / 2 + translation.y;
        view.center = center;
        
    } else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        CGPoint velocity = [pan velocityInView:self];
        CGPoint translation = [pan translationInView:self];
        
        if (fabs(velocity.y) > 1500) {
            
            self.dynamicAnimator = [[UIDynamicAnimator alloc] init];
            
            UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] init];
            [itemBehavior addItem:view];
            [itemBehavior addLinearVelocity:CGPointMake(0, velocity.y) forItem:view];
            
            [self.dynamicAnimator addBehavior:itemBehavior];
            
            //self.userInteractionEnabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self pop];
            });
            
            
        } else if (fabs(translation.y) > 100) {
            
            self.dynamicAnimator = [[UIDynamicAnimator alloc] init];
            
            UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[view] mode:UIPushBehaviorModeContinuous];
            pushBehavior.pushDirection = CGVectorMake(0, copysignf(1600, velocity.y));
            
            [self.dynamicAnimator addBehavior:pushBehavior];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self pop];
            });
        } else {
            
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
       
                view.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
            } completion:nil];
            
        }
    }
}
 */

- (void)pop {
    UIView *innerCard = self.innerCards[self.topCard];
    //innerCard.alpha = 0;
    
    [UIView animateWithDuration:0.4 animations:^{
        //innerCard.alpha = 0;
        //innerCard.transform = CGAffineTransformMakeScale(3, 3);
    }];
    
    innerCard = self.innerCards[(self.topCard + 4) % self.cards.count];
    innerCard.transform = [self transformWithLevel:4];
    innerCard.alpha = 0;
    innerCard.bounds = self.bounds;
    innerCard.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    self.topCard = (self.topCard + 1) % self.cards.count;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            [self order];
        }];
        
    });
}

#pragma mark - UIView

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self order];
}

@end
