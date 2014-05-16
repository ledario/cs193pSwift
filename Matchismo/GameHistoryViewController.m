//
//  GameHistoryViewController.m
//  Matchismo
//
//  Created by Dario Vincent on 4/18/14.
//  Copyright (c) 2014 cs193p. All rights reserved.
//

#import "GameHistoryViewController.h"
#import "CardGameViewController.h"

@interface GameHistoryViewController ()

@property (weak, nonatomic) IBOutlet UITextView *gamePlayHistory;

@end

@implementation GameHistoryViewController

-(void)setGameHistoryText:(NSAttributedString *)gameHistoryText
{
    _gameHistoryText = gameHistoryText;
    if (self.view.window) [self updateUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI
{
    self.gamePlayHistory.attributedText = self.gameHistoryText;
}

@end
