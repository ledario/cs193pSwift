//
//  Deck.h
//  Matchismo
//
//  Created by Dario Vincent on 11/28/13.
//  Copyright (c) 2013 cs193p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

// addCard: atTop:
// add card to the beginning of the deck
//   parameters:
//     card: card to add
//     atTop:
//        true: add card to the beginning
//       false: add card to the end
- (void)addCard:(Card *)card atTop:(BOOL)atTop;

// addCard:
// add card to the end of the deck
//   parameter: card
- (void)addCard:(Card *)card;

// drawRandomCard:
// returns a rand card from the deck
- (Card *)drawRandomCard;

// reset:
// empties the deck of cards
- (void)reset;

@end
