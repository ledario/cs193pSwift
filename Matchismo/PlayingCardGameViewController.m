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

- (CardView *)createCardViewWithFrame:(CGRect)frame
{
    return [[PlayingCardView alloc] initWithFrame:frame];
}

- (void)drawCardView:(CardView *)cardView ForCard:(Card *)card
{
    if ([cardView isKindOfClass:[PlayingCardView class]] && [card isKindOfClass:[PlayingCard class]]) {
        PlayingCardView *playingCardView = (PlayingCardView *)cardView;
        if ([playingCardView.card isKindOfClass:[PlayingCard class]] && [card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCardFromView = (PlayingCard *)playingCardView.card;
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardFromView.suit = playingCard.suit;
            playingCardFromView.rank = playingCard.rank;
        }
    }
}
@end
