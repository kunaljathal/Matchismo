//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Kunal Jathal on 12/8/14.
//  Copyright (c) 2014 Kunal Jathal. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "Grid.h"

@interface CardGameViewController () <UIDynamicAnimatorDelegate>
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray *statusHistory;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusMessage;
@property (strong, nonatomic) NSMutableArray *cardDeckOnScreen;
@property (nonatomic) NSInteger numberOfCardsCurrentlyOnScreen;
@property (strong, nonatomic) Grid *grid;
@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (nonatomic) BOOL startNewGame;
@property (nonatomic) BOOL areCardsPiledUp;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet UIButton *addThreeCardsButton;
@end

@implementation CardGameViewController

#pragma mark - Constants

@dynamic numberOfStartingCards;
@dynamic cardAspectRatio;
#define PhotoDatabaseAvailabilityNotification @"PhotoDatabaseAvailabilityNotification"
#define PhotoDatabaseAvailabilityContext @"Context"


- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:PhotoDatabaseAvailabilityNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // do something
    }];
}

#pragma mark - Properties

- (NSMutableArray *)cardDeckOnScreen
{
    if (!_cardDeckOnScreen)
    {
        _cardDeckOnScreen = [[NSMutableArray alloc] init];
    }
    
    return _cardDeckOnScreen;
}

- (Grid *)grid
{
    if (!_grid)
    {
        _grid = [[Grid alloc] init];

        // Set grid up
        _grid.size = self.gameView.frame.size;
        _grid.minimumNumberOfCells = self.numberOfCardsCurrentlyOnScreen;
        _grid.cellAspectRatio = self.cardAspectRatio;
    }
    
    return _grid;
}

- (CardMatchingGame *)game
{
    if (!_game)
    {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.numberOfStartingCards usingDeck:[self createDeck]];
    }
    
    return _game;
}

- (NSMutableArray *)statusHistory
{
    if (!_statusHistory)
    {
        _statusHistory = [[NSMutableArray alloc] init];
    }
    
    return _statusHistory;
}

- (Deck *)createDeck    // abstract
{
    return nil;
}

- (NSInteger)numberOfCardsCurrentlyOnScreen
{
    if (!_numberOfCardsCurrentlyOnScreen)
    {
        _numberOfCardsCurrentlyOnScreen = self.numberOfStartingCards;
    }
    
    return _numberOfCardsCurrentlyOnScreen;
}


- (UIDynamicAnimator *)animator
{
    if (!_animator)
    {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.gameView];
        _animator.delegate = self;
    }
    
    return _animator;
}

#pragma mark - Gestures

- (IBAction)panGameView:(UIPanGestureRecognizer *)gesture
{
    CGPoint anchorPoint = [gesture locationInView:self.gameView];
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        // Attach all the cards to the point the pan starts on.
        for (UIView *cardView in self.cardDeckOnScreen)
        {
            UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:cardView attachedToAnchor:anchorPoint];
            [self.animator addBehavior:attachment];
        }
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        // Move all cards around according to the point.
        for (UIDynamicBehavior *behaviour in self.animator.behaviors)
        {
            if ([behaviour isKindOfClass:[UIAttachmentBehavior class]])
            {
                ((UIAttachmentBehavior *)behaviour).anchorPoint = anchorPoint;
            }
        }
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        for (UIDynamicBehavior *behaviour in self.animator.behaviors)
        {
            // Unattach all cards from anchor.
            if ([behaviour isKindOfClass:[UIAttachmentBehavior class]])
            {
                [self.animator removeBehavior:behaviour];
            }
        }
    }
}

- (IBAction)pinchGameView:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded))
    {
        // The 'rough' center of the grid.
        CGRect cellFrame = [self.grid frameOfCellAtRow:[self.grid rowCount]/2 inColumn:[self.grid columnCount]/2];
        CGRect centerScreenFrame = CGRectInset(cellFrame, 0.1f * cellFrame.size.width, 0.1f * cellFrame.size.height);

        // Just move all the cards to the center.
        for (UIView *cardView in self.cardDeckOnScreen)
        {
            [UIView animateWithDuration:0.75
                             animations:^{
                                 cardView.frame = centerScreenFrame;
                             } completion:NULL
             ];
        }
        
        self.areCardsPiledUp = YES;
    }
}

- (void)tapCard:(UITapGestureRecognizer *)gesture
{
    [[NSNotificationCenter defaultCenter] postNotificationName:PhotoDatabaseAvailabilityNotification
                                                        object:self
                                                      userInfo:nil];

    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded))
    {
        if (!self.areCardsPiledUp)
        {
            int cardIndex = gesture.view.tag;
            [self.game chooseCardAtIndex:cardIndex];
            [self updateUI];
        }
        else
        {
            // Deal.
            [self drawAllCardsToEmptyGrid];
            self.areCardsPiledUp = NO;
        }
    }
}

#pragma mark - Card To Grid Functions

- (UIView *)createCardView:(Card *)card
{
    // Create the card view, add gesture support
    UIView *cardView = [self createViewForCard:card];
    [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)]];

    // Set the initial frame to be outside the view. Get any cell as reference for the card size.
    CGRect cellFrame = [self.grid frameOfCellAtRow:0 inColumn:0];
    cardView.frame = CGRectMake(self.gameView.frame.origin.x + self.gameView.frame.size.width,
                                self.gameView.frame.origin.y + (0.5f * self.gameView.frame.size.height),
                                0.9f * cellFrame.size.width,
                                0.9f * cellFrame.size.height);
    
    // We now have a brand new card view, out of game view, and ready to be animated into position.
    [self.gameView addSubview:cardView];
    return cardView;
}


- (void)drawAllCardsToEmptyGrid
{
    if ([self.grid inputsAreValid])
    {
        if (self.startNewGame)
        {
            // For a new game, we need to create the views
            for (int cardCounter = 0; cardCounter < [self.game numberOfDealtCards]; cardCounter++)
            {
                Card *card = [self.game cardAtIndex:cardCounter];
                UIView *cardView = [self createCardView:card];
                cardView.tag = cardCounter;
                [self.cardDeckOnScreen addObject:cardView];
            }
        }
        
        [self animateCardViewIntoGrid:self.cardDeckOnScreen startingAt:0];
        
        self.numberOfCardsCurrentlyOnScreen = [self.cardDeckOnScreen count];
    }
}

- (IBAction)addThreeCards:(UIButton *)sender
{
    NSMutableArray *cardViewsToAdd = [[NSMutableArray alloc] init];
    NSInteger startingTag = [self.game numberOfDealtCards];
    
    for (int cardCount = 0; cardCount < 3; cardCount++)
    {
        // Draw a random card from the deck
        Card *card = [self.game drawNewCard];

        if (card)
        {
            UIView *cardView = [self createCardView:card];
            [cardViewsToAdd addObject:cardView];
            cardView.tag = startingTag;
            startingTag++;
//            [self.cardDeckOnScreen addObject:cardView];
        }
    }
    
    if (![cardViewsToAdd count])
    {
        self.statusMessage.text = @"No more cards left!";
        self.addThreeCardsButton.enabled = NO;
        
        // Fade out the statusMessage Text
        [UIView animateWithDuration:2.0 animations:^{
            self.statusMessage.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.statusMessage.text = @"";
            self.statusMessage.alpha = 1.0;
        }];
    }
    
    // We want to first rearrange the grid. Only after that animation is over, do we want to animate the new views in.
    self.grid.minimumNumberOfCells = self.numberOfCardsCurrentlyOnScreen + [cardViewsToAdd count];

    [self.cardDeckOnScreen addObjectsFromArray:cardViewsToAdd];
    if (![self reArrangeCardsToGrid])
    {
        [self animateCardViewIntoGrid:cardViewsToAdd startingAt:self.numberOfCardsCurrentlyOnScreen];
        self.numberOfCardsCurrentlyOnScreen = [self.cardDeckOnScreen count];
    }
}

-(void)animateCardViewIntoGrid:(NSMutableArray *)cardViewsToAnimate startingAt:(NSInteger)startingPosition
{
    // The only thing we need to know is WHERE to animate the card to.
    for (int cardCounter = 0, numerator = startingPosition; cardCounter < [cardViewsToAnimate count]; cardCounter++, numerator++)
    {
        UIView *cardView = cardViewsToAnimate[cardCounter];
        
        int row = (int) numerator / [self.grid columnCount];
        int col = numerator % [self.grid columnCount];
        
        CGRect cellFrame = [self.grid frameOfCellAtRow:row inColumn:col];
        CGRect frame = CGRectInset(cellFrame, 0.1f * cellFrame.size.width, 0.1f * cellFrame.size.height);
        
        [UIView animateWithDuration:0.75
                              delay:1.5 * cardCounter/[cardViewsToAnimate count]
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             cardView.frame = frame;
                         } completion:^(BOOL finished){
                             [self.gameView addSubview:cardView];
                         }
         ];
    }
}

- (BOOL)reArrangeCardsToGrid
{
    BOOL didCardsNeedReArranging = NO;
    
    // We need to rearrange the cards in the grid.
    int cardIndex = 0, currentCol = 0, currentRow = 0;
    
    // Basically go through each cardView, and see if it's in the correct cell.
    while (cardIndex < self.numberOfCardsCurrentlyOnScreen)
    {
        UIView *cardView = self.cardDeckOnScreen[cardIndex];
        
        CGRect cellFrame = [self.grid frameOfCellAtRow:currentRow inColumn:currentCol];
        CGPoint cellCenter = [self.grid centerOfCellAtRow:currentRow inColumn:currentCol];
        
        CGPoint frameCenter = CGPointMake(((cardView.frame.origin.x) + (cardView.frame.size.width/2)), ((cardView.frame.origin.y) + (cardView.frame.size.height/2)));
        
        BOOL doesCurrentCardViewContainCellCenter = (CGPointEqualToPoint(cellCenter, frameCenter));
        
        if (!doesCurrentCardViewContainCellCenter)
        {
            didCardsNeedReArranging = YES;
            
            // We found a card that needs to be moved. Get it's new frame.
            CGRect newFrame = CGRectInset(cellFrame, 0.1f * cellFrame.size.width, 0.1f * cellFrame.size.height);
            
            [UIView animateWithDuration:0.5 delay:(1.0 * (cardIndex/self.numberOfCardsCurrentlyOnScreen)) options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
                cardView.frame = newFrame;
            }completion:^(BOOL finished) {
                if (finished)
                {
                    if (cardIndex == self.numberOfCardsCurrentlyOnScreen - 1)
                    {
                        NSInteger numberOfCardsThatShouldBeOnScreen = [self.cardDeckOnScreen count];
                        if (numberOfCardsThatShouldBeOnScreen > self.numberOfCardsCurrentlyOnScreen)
                        {
                            [self animateCardViewIntoGrid:[[NSMutableArray alloc] initWithArray:[self.cardDeckOnScreen subarrayWithRange:NSMakeRange(cardIndex + 1, numberOfCardsThatShouldBeOnScreen - self.numberOfCardsCurrentlyOnScreen)]] startingAt:cardIndex + 1];
                            self.numberOfCardsCurrentlyOnScreen = [self.cardDeckOnScreen count];
                        }
                    }
                }
                
            }];
        }
        
        cardIndex++;
        currentRow = (int) cardIndex/[self.grid columnCount];
        currentCol = cardIndex % [self.grid columnCount];
    }
    
    return didCardsNeedReArranging;
}


#pragma mark - Update UI

- (void)updateUI
{
    if (!self.startNewGame)
    {
        // We're in the middle of a game, so go through the current array of card Views on screen, and call UpdateView on each. UpdateView will do the following for those cards applicable:
        //  1) Flip any cards that have been chosen but not matched
        //  2) Unlfip any cards that have been unmatched and hence unchosen.
        
        [self.cardDeckOnScreen enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIView *cardView, NSUInteger index, BOOL *stop) {
            Card *card = [self.game cardAtIndex:cardView.tag];
            [self updateView:cardView forCard:card];
            
            // This part fades out the unmatched cards.
            if (card.isMatched) {
                [self.cardDeckOnScreen removeObjectAtIndex:index];
                [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
                    cardView.alpha = 0.0;
                }completion:^(BOOL finished) {
                    if (finished)
                    {
                        [cardView removeFromSuperview];
                    }
                }];
            }
        }];

        // Get the new number of cards that should be on screen now, so we can rearrange cards in the grid if necessary.
        NSInteger numberOfCardsThatShouldBeOnScreen = [self.cardDeckOnScreen count];
        
        if (numberOfCardsThatShouldBeOnScreen < self.numberOfCardsCurrentlyOnScreen)
        {
            // Rearrange cards in grid.
            self.numberOfCardsCurrentlyOnScreen = numberOfCardsThatShouldBeOnScreen;
            [self reArrangeCardsToGrid];
        }
    }
    else
    {
        // This is the animation that animates all the cards out of the screen
        for (UIView *cardView in self.cardDeckOnScreen)
        {
            [UIView animateWithDuration:0.5
                             animations:^{
                                 cardView.frame = CGRectMake(cardView.frame.origin.x - self.gameView.bounds.size.width,
                                                             cardView.frame.origin.y,
                                                             cardView.frame.size.width,
                                                             cardView.frame.size.height);
                             } completion:^(BOOL finished) {
                                 [cardView removeFromSuperview];
                             }];
        }

        [self.cardDeckOnScreen removeAllObjects];
        [self drawAllCardsToEmptyGrid];
        self.startNewGame = NO;
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

#pragma mark - Initialization

- (IBAction)newGame
{
    // Make a new deck & update the UI
    self.game = nil;
    self.startNewGame = YES;
    self.statusHistory = nil;
    self.animator = nil;
    self.numberOfCardsCurrentlyOnScreen = 0;
    self.areCardsPiledUp = NO;
    self.addThreeCardsButton.enabled = YES;
    self.grid = nil;
    [self updateUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.startNewGame = YES;
    [self updateUI];
}

#pragma mark - Abstract

- (UIView *)createViewForCard:(Card *)card;
{
    return nil;
}

- (void)updateView:(UIView *)cardView forCard:(Card *)card
{
    // abstract
}


@end
