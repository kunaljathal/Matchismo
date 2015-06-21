//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Kunal Jathal on 1/7/15.
//  Copyright (c) 2015 Kunal Jathal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;

//- (void)pinch:(UIPinchGestureRecognizer *)gesture;
//- (void)tap:(UITapGestureRecognizer *)gesture;

@end
