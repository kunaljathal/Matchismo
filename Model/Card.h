//
//  Card.h
//  Matchismo
//
//  Created by Kunal Jathal on 12/8/14.
//  Copyright (c) 2014 Kunal Jathal. All rights reserved.
//

/*
 The CARD class is essentially the parent class that all 'cards' share in common. So basically, all cards - both playing cards and set cards - have certain properties in common. They can both be selected/chosen, and be in a state of being matched. So these 2 properties here aren't physical properties common to both cards, but rather attributes common to both of them. A card, regardless of the game, will also have something ON it i.e. physically. This is the contents.
 
 The 'match' function is essentially the scoring function of the card. Strictly speaking, I believe it's implementation here is unnecessary and it can be abstracted (i.e. made to return nil), since all our cards are either Playing Cards or Set Cards, and they each have their own scoring functions. 

 'Mode' is a bit weird.. basically, all cards can be matched, but the number of maximum cards that you can match depends on the TYPE of card. Playing Cards can be matched to 1 other card, and Set Cards to 2. So that's the info that mode holds. 
 */


#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;

@property (nonatomic) NSUInteger mode;


- (int)match:(NSArray *)otherCards;

@end
