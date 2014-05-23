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

//@interface PlayingCardGameViewController ()
//
//@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck
{
    Deck *deck = [[PlayingCardDeck alloc] init];
    return deck;
}

// Replace with specific card in concrete class
//- (void)addCardToView:(UIView *)gridView withGrid:(Grid *)grid atRow:(NSUInteger)row atColumn:(NSUInteger)column
//{    
//    [gridView addSubview:[[PlayingCardView alloc] initWithFrame:[grid frameOfCellAtRow:row inColumn:column]]];
//    
//}

// Replace with specific card in concrete class
//- (CardView *)drawCardForGrid:(Grid *)grid atRow:(NSUInteger)row atColumn:(NSUInteger)column
//{
//    return [[PlayingCardView alloc] initWithFrame:[grid frameOfCellAtRow:row inColumn:column]];
//}

// Replace with specific card in concrete class
//- (PlayingCardView *)drawCardForGrid:(Grid *)grid atRow:(NSUInteger)row atColumn:(NSUInteger)column
//{
//    PlayingCardView *playingCardView = [[PlayingCardView alloc] initWithFrame:[grid frameOfCellAtRow:row inColumn:column]];
//    
//    // TODO: check index arithmetic
//    PlayingCard *playingCard = (PlayingCard *)[self.game cardAtIndex:row*grid.rowCount+column];
//    
//    playingCardView.suit = playingCard.suit;
//    playingCardView.rank = playingCard.rank;
//    
//    return playingCardView;
//}

- (CardView *)createCardViewWithFrame:(CGRect)frame
{
    return [[PlayingCardView alloc] initWithFrame:frame];
}

- (void)drawCardView:(CardView *)cardView ForCard:(Card *)card
{
    if ([cardView isKindOfClass:[PlayingCardView class]]) {
//    ((PlayingCardView *)cardView).suit = ((PlayingCard *)card).suit;
//    ((PlayingCardView *)cardView).rank = ((PlayingCard *)card).rank;
        ((PlayingCardView *)cardView).suit = @"♠";
        ((PlayingCardView *)cardView).rank = 13;
    }
}
@end
