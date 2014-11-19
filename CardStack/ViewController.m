//
//  ViewController.m
//  CardStack
//
//  Created by Vitaly Berg on 19/11/14.
//  Copyright (c) 2014 Vitaly Berg. All rights reserved.
//

#import "ViewController.h"

#import "CardStack.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet CardStack *cardStack;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *cards = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 10; i++) {
        UIView *card = [[UIView alloc] init];
        card.backgroundColor = [UIColor colorWithHue:(1.0 / i) saturation:1 brightness:1 alpha:1];
        [cards addObject:card];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = [NSString stringWithFormat:@"%ld", i];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:30];
        [card addSubview:label];
        
        card.layer.cornerRadius = 5;
        
        card.layer.shadowOpacity = 0.2;
    }
    
    self.cardStack.cards = cards;
}

- (IBAction)popAction:(id)sender {
    [self.cardStack pop];
}

@end
