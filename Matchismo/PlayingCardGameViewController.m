//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Dario Vincent on 2/24/14.
//  Copyright (c) 2014 cs193p. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"
#import "PlayingCard.h"

@implementation PlayingCardGameViewController

- (Deck *)createDeck
{
    Deck *deck = [[PlayingCardDeck alloc] init];
    return deck;
}

- (CardView *)createCardViewWithCard:(Card *)card andFrame:(CGRect)frame
{
    return [[PlayingCardView alloc] initWithCard:card andFrame:frame];
}

@end
