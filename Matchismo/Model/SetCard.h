//
//  SetCard.h
//  Matchismo
//
//  Created by Dario Vincent on 2/19/14.
//  Copyright (c) 2014 cs193p. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger number;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (strong, nonatomic) NSString *color;

// Override
// - (NSUInteger)matchCount;
// - (NSInteger)match:(NSArray *)otherCards
// - (NSString *)contents

// validNumbers:
// array of number representing the set of valid numbers
//   {1,2,3}: valid numbers
//         0: not a valid value number
+ (NSArray *)validNumbers;

// validSymbols:
// array of strings representing the set of valid symbols
//   {"diamond","squiggle","oval"}: set of valid symbols
//                             "?": not a valid string for symbol
+ (NSArray *)validSymbols;

// validShadings:
// array of strings representing the set of valid shadings
//   {"solid","striped","open"}: set of valid shadings
//                          "?": not a valid string for shade
+ (NSArray *)validShadings;

// validColors:
// array of strings representing the set of valid colors
//   {"red","green","purple"}: set of valid colors
//   "?": not a valid string for color
+ (NSArray *)validColors;

// maxRank:
// the upper value for the number representing rank values
+ (NSUInteger)maxNumber;

@end
