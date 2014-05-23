//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Dario Vincent on 11/18/13.
//  Copyright (c) 2013 cs193p. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"
#import "Deck.h"
#import "Grid.h"
#import "CardView.h"

@interface CardGameViewController : UIViewController

//@property (strong, nonatomic, readonly) CardMatchingGame *game;
//@property (nonatomic, readonly) NSUInteger cardCount;

// Abstract method to be implemented in concrete class
- (Deck *)createDeck;
- (void)drawCardView:(CardView *)cardView ForCard:(Card *)card;
- (CardView *)createCardViewWithFrame:(CGRect)frame;

@end
