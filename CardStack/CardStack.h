//
//  CardStack.h
//  CardStack
//
//  Created by Vitaly Berg on 19/11/14.
//  Copyright (c) 2014 Vitaly Berg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardStack : UIView

@property (strong, nonatomic) NSArray *cards;
@property (assign, nonatomic) NSInteger topCard;

- (void)pop;

@end
