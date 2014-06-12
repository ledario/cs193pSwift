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
#import "CardView.h"

@interface CardGameViewController : UIViewController <CardViewDelegate>

// Abstract method to be implemented in concrete class
- (Deck *)createDeck;

// Abstract method to be implemented in concrete class
//- (CardView *)createCardViewWithFrame:(CGRect)frame;
- (CardView *)createCardViewWithCard:(Card *)card andFrame:(CGRect)frame;

@end
