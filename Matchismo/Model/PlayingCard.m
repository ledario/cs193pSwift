//
//  PlayingCard.m
//  Matchismo
//
//  Created by Dario Vincent on 11/28/13.
//  Copyright (c) 2013 cs193p. All rights reserved.
//

#import "PlayingCard.h"

#define MATCH_COUNT 2
#define MATCH_SCORE_COMPLETE 4
#define MATCH_SCORE_PARTIAL 1

@implementation PlayingCard

- (NSUInteger)matchCount
{
    return MATCH_COUNT;
}

- (NSInteger)match:(NSArray *)otherCards
{
    NSInteger score = 0;
    
    if ((otherCards.count + 1) == [self matchCount]) {
        PlayingCard *otherCard = [otherCards firstObject];
        if (otherCard.rank == self.rank) {
            score = MATCH_SCORE_COMPLETE;
        } else if ([otherCard.suit isEqualToString:self.suit]) {
            score = MATCH_SCORE_PARTIAL;
        }
    }
    
    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

+ (NSArray *)validSuits
{
    return @[@"♠",@"♣",@"♥",@"♦"];
}

@synthesize suit = _suit;

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",
             @"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank
{
    return [[self rankStrings] count]-1;
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
