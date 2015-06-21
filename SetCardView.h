//
//  SetCardView.h
//  Matchismo
//
//  Created by Kunal Jathal on 1/23/15.
//  Copyright (c) 2015 Kunal Jathal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (nonatomic) NSUInteger number;
@property (strong, nonatomic) NSString *shape;
@property (strong ,nonatomic) NSString *shading;
@property (strong, nonatomic) NSString *color;

@property (nonatomic) BOOL chosen;

@end
