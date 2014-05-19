//
//  Card.m
//  Matchismo
//
//  Created by Dario Vincent on 11/28/13.
//  Copyright (c) 2013 cs193p. All rights reserved.
//

#import "Card.h"

#define MATCH_COUNT 2
#define MATCH_SCORE 1

@implementation Card

- (NSUInteger)matchCount
{
    return MATCH_COUNT;
}

- (NSInteger)match:(NSArray *)otherCards
{
    int score = 0;
    
    // Attempt a match when the other cards plus the current card is up to the matchCount
    if ((otherCards.count + 1) == [self matchCount]) {
        for (Card *card in otherCards) {
            if ([card.contents isEqualToString:self.contents]) {
                score = MATCH_SCORE;
            }
        }
    }
    
    return score;
}

@end
