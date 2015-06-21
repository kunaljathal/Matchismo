//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Kunal Jathal on 12/8/14.
//  Copyright (c) 2014 Kunal Jathal. All rights reserved.
//
// Abstract Class. Must implement methods as described below.

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

// The one thing I've seen is that... if you want to let your parent class know that there are functions that it can search for in its child classes, that are going to be defined, then make them public... apparently. That's what this protected bs seems to be about.

// protected
// for sub classes

- (Deck *)createDeck;   // abstract
- (UIView *)createViewForCard:(Card *)card;
- (void)updateView:(UIView *)cardView forCard:(Card *)card;

- (void)updateUI;

@property (nonatomic) NSUInteger numberOfStartingCards;
@property (nonatomic) CGFloat cardAspectRatio;

@end
