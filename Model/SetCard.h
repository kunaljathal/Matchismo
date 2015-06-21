//
//  SetCard.h
//  Matchismo
//
//  Created by Kunal Jathal on 1/4/15.
//  Copyright (c) 2015 Kunal Jathal. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSString *shape;
@property (nonatomic) NSUInteger number;
@property (strong, nonatomic) NSString *shading;
@property (strong, nonatomic) NSString *color;

+ (NSArray *)validShapes;
+ (NSArray *)validColors;
+ (NSUInteger)maxNumber;
+ (NSArray *)validShadings;

@end
