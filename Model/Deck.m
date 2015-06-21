//
//  Deck.m
//  Matchismo
//
//  Created by Kunal Jathal on 12/10/14.
//  Copyright (c) 2014 Kunal Jathal. All rights reserved.
//

#import "Deck.h"


/* A DECK will contain cards. These could be playing cards, or set cards. Public access to this array of cards isn't needed; only access to the *actions* that can be taken on the deck is necessary.

 The card array is initially empty and of type Card, because a) we don't yet know how many cards to initialize the deck with (this has to be told to us by another class, and b) we don't know if the deck should contain playing cards or set cards. Again, this will be told to us by another class ... you guessed it: by the child class that actually creates the deck through it's super init.

*/

@interface Deck()
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@end

@implementation Deck


// CARDS getter
- (NSMutableArray *)cards
{
    if (!_cards) _cards = [ [NSMutableArray alloc] init];
    return _cards;
}

// ADDCARD just adds a card object to the array. atTop adds it to the top.
- (void)addCard:(Card *)card atTop:(BOOL)atTop
{
    if (atTop)
    {
        [self.cards insertObject:card atIndex:0];
    }
    else
    {
        [self.cards addObject:card];
    }
}

- (void) addCard:(Card *)card
{
    [self addCard:card atTop:NO];
}

- (Card *)drawRandomCard
{
    Card *randomCard = nil;
    
    if ([self.cards count])
    {
        unsigned index = arc4random() % [self.cards count];
        randomCard = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    
    return randomCard;
}

@end
