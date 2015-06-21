//
//  PlayingCard.h
//  Matchismo
//
//  Created by Kunal Jathal on 12/10/14.
//  Copyright (c) 2014 Kunal Jathal. All rights reserved.
//


/*
 
 This class PLAYING CARD is essentially the class that holds the card info for the Cards in the Matching Game.
 
 It represents a standard playing card. Therefore it has a suit (hearts, clubs etc.) and a rank (king, queen, etc.). 
 
 The class methods: validSuits is used to see if some other card contains the valid list of suits that a playing card qualifies for. Same logic applies to the max Rank, and the Rank Strings.
 
 */

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;
+ (NSArray *)rankStrings;

@end
