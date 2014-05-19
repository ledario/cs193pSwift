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

/*
 * initWithCardCount: usingDeck:
 * designated initializer to provide a set of cards for the game
 * parameters:
 *   count: cardinal of a subset of deck
 *          number of cards used in the game
 *    deck: complete set of card
 */
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck;

/*
 * chooseCardAtIndex:
 * flip over the card at the given index
 * and execute the rules of the game
 */
- (void)chooseCardAtIndex:(NSUInteger)index;

/*
 * cardAtIndex:
 * return the card at the given index
 */
- (Card *)cardAtIndex:(NSUInteger)index;

@end

