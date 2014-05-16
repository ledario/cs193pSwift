//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Dario Vincent on 12/8/13.
//  Copyright (c) 2013 cs193p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#include "Card.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSInteger playScore;

/*
 * Values for matchPlay are:
 *         nil : match in progress
 *   @"success": successful match
 *      @"fail": failed match
 */
@property (nonatomic, readonly) NSString *matchPlay;
@property (nonatomic, readonly) NSArray *cardsInPlay;

/*
 * History of matchPlay
 * each play is saved into a 2 dimensional array
 */
@property (nonatomic, readonly) NSArray *playHistory;

@end

