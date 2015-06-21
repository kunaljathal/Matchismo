//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Kunal Jathal on 1/4/15.
//  Copyright (c) 2015 Kunal Jathal. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCard.h"
#import "SetCardDeck.h"
#import "SetCardView.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

@synthesize numberOfStartingCards = _numberOfStartingCards;
@synthesize cardAspectRatio = _cardAspectRatio;

- (NSUInteger)numberOfStartingCards
{
    if (!_numberOfStartingCards)
    {
        _numberOfStartingCards = 12;
    }
    
    return _numberOfStartingCards;
}

- (void)setNumberOfStartingCards:(NSUInteger)numberOfStartingCards
{
    _numberOfStartingCards = numberOfStartingCards;
}

- (CGFloat)cardAspectRatio
{
    if (!_cardAspectRatio)
    {
        _cardAspectRatio = 1.0f;
    }
    
    return _cardAspectRatio;
}

- (void)setCardAspectRatio:(CGFloat)cardAspectRatio
{
    _cardAspectRatio = cardAspectRatio;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
}

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (UIView *)createViewForCard:(Card *)card
{
     SetCardView *cardView = [[SetCardView alloc] init];
    
    if ([card isKindOfClass:[SetCard class]])
    {
        SetCard *setCard = (SetCard *)card;
        
        cardView.shape = setCard.shape;
        cardView.color = setCard.color;
        cardView.shading = setCard.shading;
        cardView.number = setCard.number;
    }
    
    return cardView;
}

- (void)updateView:(UIView *)cardView forCard:(Card *)card
{
    if ([cardView isKindOfClass:[SetCardView class]] && [card isKindOfClass:[SetCard class]])
    {
        SetCardView *setCardView = (SetCardView *)cardView;
        SetCard *setCard = (SetCard *)card;
        
        if (setCardView.chosen != setCard.isChosen)
        {
            setCardView.chosen = setCard.isChosen;            
        }
    }
}


- (NSAttributedString *)getAttributedTitle:(Card *)card
{
    return [self titleForCard:card];
}

- (NSAttributedString *)titleForCard:(Card *)card
{
    NSString *shape = @"?";
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    if ([card isKindOfClass:[SetCard class]])
    {
        SetCard *setCard = (SetCard *)card;
        
        // Convert the string shape to the actual shape
        if ([setCard.shape isEqualToString:@"circle"]) shape = @"●";
        if ([setCard.shape isEqualToString:@"triangle"]) shape = @"▲";
        if ([setCard.shape isEqualToString:@"square"]) shape = @"■";
        
        // The 'number' in a set card is simply the number of times the shape appears
        shape = [shape stringByPaddingToLength:setCard.number
                                      withString:shape
                                 startingAtIndex:0];
        
        // Convert the color string to the actual color. Note that we are just adding the color to a dictionary of attributes, that we will later apply to the string. The attribute we are using is simply NSForegroundColorAttributeName.
        if ([setCard.color isEqualToString:@"red"])
            [attributes setObject:[UIColor redColor]
                           forKey:NSForegroundColorAttributeName];
        if ([setCard.color isEqualToString:@"green"])
            [attributes setObject:[UIColor greenColor]
                           forKey:NSForegroundColorAttributeName];
        if ([setCard.color isEqualToString:@"purple"])
            [attributes setObject:[UIColor purpleColor]
                           forKey:NSForegroundColorAttributeName];
        
        // Repeat the process for the shading. Attribute is NSStrokeWidthAttributeName.
        if ([setCard.shading isEqualToString:@"solid"])
            [attributes setObject:@-5
                           forKey:NSStrokeWidthAttributeName];
        if ([setCard.shading isEqualToString:@"striped"])
            [attributes addEntriesFromDictionary:@{
                                                   NSStrokeWidthAttributeName : @-5,
                                                   NSStrokeColorAttributeName : attributes[NSForegroundColorAttributeName],
                                                   NSForegroundColorAttributeName : [attributes[NSForegroundColorAttributeName] colorWithAlphaComponent:0.1]
                                                   }];
        if ([setCard.shading isEqualToString:@"open"])
            [attributes setObject:@5 forKey:NSStrokeWidthAttributeName];
    }
    
    return [[NSMutableAttributedString alloc] initWithString:shape
                                                  attributes:attributes];
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.chosen ? @"setCardSelected" : @"setCard"];
}




@end
