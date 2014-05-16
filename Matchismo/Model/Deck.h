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

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;
- (void)reset;

@end
