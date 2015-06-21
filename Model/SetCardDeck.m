//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Kunal Jathal on 1/4/15.
//  Copyright (c) 2015 Kunal Jathal. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        for (NSString *shape in [SetCard validShapes])
        {
            for (NSUInteger number = 1; number <= [SetCard maxNumber]; number++)
            {
                for (NSString *color in [SetCard validColors])
                {
                    for (NSString *shading in [SetCard validShadings])
                    {
                        SetCard *card = [[SetCard alloc] init];
                        card.number = number;
                        card.shape = shape;
                        card.shading = shading;
                        card.color = color;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    
    return self;
}


@end
