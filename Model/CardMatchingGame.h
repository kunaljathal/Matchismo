//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Kunal Jathal on 12/10/14.
//  Copyright (c) 2014 Kunal Jathal. All rights reserved.
//

/*
 
 The fucking brains of the Matching Game. The actual, fucking GAME class. So when you start a NEW matching game, you're essentially creating a new instance of this class.
 
 Great, so what does the game model need? Remember - it needs to be UI independent, so there are NO OUTLETS connected to this class! However, we do have the following:
 
 a) An initializer. So you need to essentially initialize the model with a deck of cards. How many cards, and what kind of cards? The CONTROLLER will let us know.
 
 b) So, what does the matching game involve? Basically selecting cards. Every time we touch a card on the screen, the controller lets the model know that a card has been chosen. Which public method can it call for that? chooseCardAtIndex. And every time a card is chosen, this model - the card matching game class - needs to go through all the other fucking cards and compute a score. 
 
    The cardAtIndex method is a public method that the controller uses to choose certain cards when it needs to update the UI, and this class uses it too as a small helper wrapper method.

 c) The model holds a list of the most recent score as well as an array of the last chosen cards, because the controller needs to display status messages in the UI and keep a history of this information, so it asks the model for it from time to time.
 
 d) The mode is whether the matching game model should be calculating the score based on a 2 card matching game or a 3 card matching game.
 */



#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (Card *)drawNewCard;

- (NSInteger)numberOfDealtCards;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) NSUInteger mode;

@property (nonatomic, readonly) NSArray *lastChosenCards;
@property (nonatomic, readonly) NSInteger lastScore;

@end
