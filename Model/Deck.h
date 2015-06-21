//
//  Deck.h
//  Matchismo
//
//  Created by Kunal Jathal on 12/10/14.
//  Copyright (c) 2014 Kunal Jathal. All rights reserved.
//

/*
 The DECK class is the parent class of a standard deck of cards. It contains properties that all decks, regardless of the kinds of cards they are made up of, have in common. 
 
 In terms of the actions that can be performed on a deck regardless of the kind of card it is made up of, that includes adding a card, adding a card to the top of the deck, and taking a random card out of the deck.
 */



#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;
- (Card *)drawRandomCard;

@end

