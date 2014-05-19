//
//  Card.h
//  Matchismo
//
//  Created by Dario Vincent on 11/28/13.
//  Copyright (c) 2013 cs193p. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;
@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;

/*
 * matchCount:
 * returns the number of cards
 * needed to make a successful match
 */
- (NSUInteger)matchCount;

/*
 * match:
 * returns the score of a match attempt
 *   return value:
 *     0: match failed
 *     1: match successful
 *   parameter
 *     otherCards: is an array of cards to match with
 */
- (NSInteger)match:(NSArray *)otherCards;

@end
