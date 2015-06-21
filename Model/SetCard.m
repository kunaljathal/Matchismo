//
//  SetCard.m
//  Matchismo
//
//  Created by Kunal Jathal on 1/4/15.
//  Copyright (c) 2015 Kunal Jathal. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

static const int MAX_NUMBER = 3;

// When a Set Card is initialized, set it's mode.
- (id)init
{
    self = [super init];
    
    if (self) {
        self.mode = 3;
    }
    
    return self;
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    // Only compute a score if the correct number of cards have been chosen
    if ([otherCards count] == self.mode - 1)
    {
        // Create mutable arrays for all attributes
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        NSMutableArray *shapes = [[NSMutableArray alloc] init];
        NSMutableArray *shadings = [[NSMutableArray alloc] init];
        NSMutableArray *numbers = [[NSMutableArray alloc] init];
        
        // Add the current card's attributes to their respective arrays
        [colors addObject:self.color];
        [shapes addObject:self.shape];
        [shadings addObject:self.shading];
        [numbers addObject:@(self.number)];
        
        // Go through each card in the otherCards array...
        for (id otherCard in otherCards)
        {
            if ([otherCard isKindOfClass:[SetCard class]])
            {
                SetCard *otherSetCard = (SetCard *)otherCard;
                
                if (![colors containsObject:otherSetCard.color])
                    [colors addObject:otherSetCard.color];
                
                if (![shapes containsObject:otherSetCard.shape])
                    [shapes addObject:otherSetCard.shape];
                
                if (![shadings containsObject:otherSetCard.shading])
                    [shadings addObject:otherSetCard.shading];
                
                if (![numbers containsObject:@(otherSetCard.number)])
                    [numbers addObject:@(otherSetCard.number)];
                
                // Some fucking bullshit. Let me know if you figure it out.
                
                if (([colors count] == 1 || [colors count] == self.mode)
                    && ([shapes count] == 1 || [shapes count] == self.mode)
                    && ([shadings count] == 1 || [shadings count] == self.mode)
                    && ([numbers count] == 1 || [numbers count] == self.mode))
                {
                    score = 4;
                }
            }
        }
    }
    
    return score;
}

- (NSString *)contents
{
    return [NSString stringWithFormat:@"%@:%@:%@:%d", self.shape, self.color, self.shading, self.number];
}

+ (NSArray *)validShapes
{
    return @[@"oval", @"squiggle", @"diamond"];
}

+ (NSArray *)validColors
{
    return @[@"red", @"green", @"purple"];
}

+ (NSUInteger)maxNumber
{
    return MAX_NUMBER;
}

+ (NSArray *)validShadings
{
    return @[@"solid", @"striped", @"open"];
}

@synthesize color = _color, shape = _shape, shading = _shading;

- (NSString *)color
{
    return _color ? _color : @"?";
}

- (void)setColor:(NSString *)color
{
    if ([[SetCard validColors] containsObject:color]) _color = color;
}

- (NSString *)shape
{
    return _shape ? _shape : @"?";
}

- (void)setshape:(NSString *)shape
{
    if ([[SetCard validShapes] containsObject:shape]) _shape = shape;
}

- (NSString *)shading
{
    return _shading ? _shading : @"?";
}

- (void)setShading:(NSString *)shading
{
    if ([[SetCard validShadings] containsObject:shading]) _shading = shading;
}

- (void)setNumber:(NSUInteger)number
{
    if (number <= [SetCard maxNumber]) _number = number;
}

@end
