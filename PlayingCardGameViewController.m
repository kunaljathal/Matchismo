//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Kunal Jathal on 12/12/14.
//  Copyright (c) 2014 Kunal Jathal. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardView.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

@synthesize numberOfStartingCards = _numberOfStartingCards;
@synthesize cardAspectRatio = _cardAspectRatio;

- (NSUInteger)numberOfStartingCards
{
    if (!_numberOfStartingCards)
    {
        _numberOfStartingCards = 28;
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
        _cardAspectRatio = 0.6667f;
    }
    
    return _cardAspectRatio;
}

- (void)setCardAspectRatio:(CGFloat)cardAspectRatio
{
    _cardAspectRatio = cardAspectRatio;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (UIView *)createViewForCard:(Card *)card
{
    PlayingCardView *cardView = [[PlayingCardView alloc] init];
    
    if ([card isKindOfClass:[PlayingCard class]])
    {
        PlayingCard *playingCard = (PlayingCard *)card;

        cardView.rank = playingCard.rank;
        cardView.suit = playingCard.suit;
    }
    
    return cardView;
}

- (void)updateView:(UIView *)cardView forCard:(Card *)card
{
    if ([cardView isKindOfClass:[PlayingCardView class]] && [card isKindOfClass:[PlayingCard class]])
    {
        PlayingCardView *playingCardView = (PlayingCardView *)cardView;
        PlayingCard *playingCard = (PlayingCard *)card;
        
        if (playingCardView.faceUp != playingCard.isChosen)
        {
            playingCardView.faceUp = playingCard.isChosen;
            
            [UIView transitionWithView:playingCardView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
                // do nothing
            } completion:^(BOOL finished) {
                // do nothing
            }];
        }
    }
 }

@end
