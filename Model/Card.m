//
//  Card.m
//  Matchismo
//
//  Created by Kunal Jathal on 12/8/14.
//  Copyright (c) 2014 Kunal Jathal. All rights reserved.
//

#import "Card.h"

@interface Card()

@end

@implementation Card


/* This function MATCH basically goes through an array of other cards, and if any of the cards in that array have the same 'contents' as the current card, it sets the score to 1. This particular implementation looks like it'll return a score of 1 if there is a match, regardless of how many matches there are.
*/

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *card in otherCards)
    {
        if ([card.contents isEqualToString:self.contents])
        {
            score = 1;
        }
    }

    return score;
}

@end
