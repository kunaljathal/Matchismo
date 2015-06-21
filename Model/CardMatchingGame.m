//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Kunal Jathal on 12/10/14.
//  Copyright (c) 2014 Kunal Jathal. All rights reserved.
//

// The GRAND DADDY class of the Matching Game logic.

#import "CardMatchingGame.h"


// Keeps track of the scores, last chosen cards, and an array of cards which is basically the code version of the actual deck of cards that you see on screen.


@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Card

@property (nonatomic, strong) NSArray *lastChosenCards;
@property (nonatomic, readwrite) NSInteger lastScore;

@property (nonatomic, strong) Deck *deck;

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards)
    {
        _cards = [[NSMutableArray alloc] init];
    }
    
    return _cards;
}

// Kind of unnecessary, because the mode is set by the controller, and the controller uses the UI Labels, which are always 2 or 3. Also, the mode is only ever 'gotten' by the model itself.
- (NSUInteger)mode
{
    Card *card = [self.cards firstObject];
    if (_mode != card.mode)
    {
        _mode = card.mode;
    }
    
    return _mode;
}

/* Initializer of game. Creates a deck of playing cards with the number of cards as specified by the controller, along with the kind of deck specified by the controller. Remember that the DECK passed here contains ALL the possible cards i.e. it is a FULL deck of whatever card type. For the game, we want to only draw X number of cards from the entire deck, where X is the number dealt on screen.
 */
- (instancetype) initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self)
    {
        _deck = deck;
        
        for (int i = 0; i < count; i++)
        {
            Card *card = [deck drawRandomCard];
            if (card)
            {
                [self.cards addObject:card];
            }
            else
            {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

// Point bs. Should probably go on top.
static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;


/* The heart of the logic. When a card is chosen, we go through the entire list of cards on screen, see if any other are chosen, and calculate a scoring if necessary (if the right number are chosen), or continue to let the user choose, or unchoose the card if the card was already chosen.
 */
- (void) chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched)
    {
        if(card.isChosen)
        {
            card.chosen = NO;
        }
        else
        {
            // Create array of other cards since we may store more than 1
            NSMutableArray *otherCards = [NSMutableArray array];
            
            // match against other card(s)
            for (Card *otherCard in self.cards)
            {
                if (otherCard.isChosen && !otherCard.isMatched)
                {
                    [otherCards addObject:otherCard];
                }
            }
            
            self.lastScore = 0;
            self.lastChosenCards = [otherCards arrayByAddingObject:card];
            
            if ([otherCards count] + 1 == self.mode)
            {
                // If/when the number of cards chosen matches the game mode, only then invoke the matching/scoring mechanism
                int matchScore = [card match:otherCards];
                
                // This part's a bit bad design, because matchScore is an actual number calculated by the Playing Card class itself. In my opinion, all the scoring should be done here, but this class unintentionally 'delegates' or outsources some of the score calculation to the playing card game class instead.
                
                if (matchScore)
                {
                    self.lastScore = matchScore * MATCH_BONUS;
                    card.matched = YES;
                    for (Card *otherCard in otherCards)
                    {
                        otherCard.matched = YES;
                    }
                }
                else
                {
                    self.lastScore = - MISMATCH_PENALTY;
                    for (Card *otherCard in otherCards)
                    {
                        otherCard.chosen = NO;
                    }
                }
            }
            
            self.score+= self.lastScore - COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

- (Card *)drawNewCard
{
    Card *newCard = [self.deck drawRandomCard];
    
    if (newCard)
    {
        [self.cards addObject:newCard];
    }
    
    return newCard;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (NSInteger)numberOfDealtCards
{
    return [self.cards count];
}


@end
