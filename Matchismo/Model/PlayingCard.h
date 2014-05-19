//
//  PlayingCard.h
//  Matchismo
//
//  Created by Dario Vincent on 11/28/13.
//  Copyright (c) 2013 cs193p. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

// Override
// - (NSUInteger)matchCount;
// - (NSInteger)match:(NSArray *)otherCards
// - (NSString *)contents

// validSuits:
// array of strings representing the set of valid suits
+ (NSArray *)validSuits;

// maxRank:
// the upper value for the number representing rank values
+ (NSUInteger)maxRank;

@end
