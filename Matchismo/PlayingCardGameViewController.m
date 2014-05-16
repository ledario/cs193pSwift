//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Dario Vincent on 2/24/14.
//  Copyright (c) 2014 cs193p. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck
{
    Deck *deck = [[PlayingCardDeck alloc] init];
    return deck;
}

@end
