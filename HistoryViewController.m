//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Kunal Jathal on 1/7/15.
//  Copyright (c) 2015 Kunal Jathal. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *historyTextView;

@end

@implementation HistoryViewController

- (void) setStatusMessageHistory:(NSArray *)statusMessageHistory
{
    _statusMessageHistory = statusMessageHistory;
    if (self.view.window)
    {
        [self updateUI];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void) updateUI
{
    NSMutableAttributedString *finalMessage = [[NSMutableAttributedString alloc] init];
    int i = 1;
    
    for (NSAttributedString *status in self.statusMessageHistory)
    {
        [finalMessage appendAttributedString:[[NSAttributedString alloc] initWithString:[[NSString alloc]initWithFormat:@"%2d: ", i++]]];
        [finalMessage appendAttributedString:status];
        [finalMessage appendAttributedString:[[NSAttributedString alloc]initWithString:@"\n\n"]];
    }
        
    UIFont *font = [self.historyTextView.textStorage attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    [finalMessage addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, finalMessage.length)];
    self.historyTextView.attributedText = finalMessage;
}


@end
