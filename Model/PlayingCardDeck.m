//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by Kunal Jathal on 12/10/14.
//  Copyright (c) 2014 Kunal Jathal. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck


/*
 In initializing a playing card deck, we first call super init. This gives us the Deck class's init, so we now have the array of cards property that represents the actual (playing card) deck. So, what do we want to do? Simple - create Playing Cards, and keep adding them to the deck. And that's what we do. We go through every rank for each suit, create a playing card, and add it to a random place in the array.
 */

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        for (NSString *suit in [PlayingCard validSuits])
        {
            for (NSUInteger rank = 1; rank <= [PlayingCard maxRank]; rank++)
            {
                PlayingCard *card = [[PlayingCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                [self addCard:card];
            }            
        }
    }
    
    return self;
}

@end
