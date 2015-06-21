//
//  PlayingCard.m
//  Matchismo
//
//  Created by Kunal Jathal on 12/10/14.
//  Copyright (c) 2014 Kunal Jathal. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard


// When a Playing Card is initialized, set it's mode.
- (id)init
{
    self = [super init];
    
    if (self) {
        self.mode = 2;
    }
    
    return self;
}


/*
 The MATCH method here is the scoring system for a playing card in the match game. It basically goes through an array of other cards passed to it, and checks certain conditions to determine how the score should be calculated. This is also where the logic of checking if there are 1 or 2 other cards to be matched up against, resides.
 */
- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    // Only compute a score if the correct number of cards have been chosen
    if ([otherCards count] == self.mode - 1)
    {
        for (Card *card in otherCards)
        {
            if ([card isKindOfClass:[PlayingCard class]])
            {
                PlayingCard *otherCard = (PlayingCard *)card;
                if ([self.suit isEqualToString:otherCard.suit])
                {
                    score += 1;
                }
                else if (self.rank == otherCard.rank)
                {
                    score += 4;
                }
            }
        }
    }
    
    return score;
}


// CONTENTS returns a concatenated string of suit+rank of the playing card
- (NSString *) contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit; // because we provide setter AND getter


// VALID SUITS returns the list of valid suits
+ (NSArray *)validSuits
{
    return @[@"♥", @"♦", @"♠", @"♣"];
}


// SUIT setter
- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit])
    {
        _suit = suit;
    }
}

// SUIT getter
- (NSString *) suit
{
    return _suit ? _suit : @"?";
}


// Class method that returns all the possible ranks in an array of strings
+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

// Class method that returns the maximum rank possible
+ (NSUInteger)maxRank
{
    return [[self rankStrings] count] - 1;
}

// RANK setter
- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank])
    {
        _rank = rank;
    }
}

@end
