//
//  PlayingForThreeCard.m
//  Matchismo
//
//  Created by Dario Vincent on 12/9/13.
//  Copyright (c) 2013 cs193p. All rights reserved.
//

#import "PlayingForThreeCard.h"

@implementation PlayingForThreeCard

- (int)matchCount
{
    return 3;
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    // Match only when there are 2 other cards
    if ([otherCards count] == 2) {
        
        // Identify candidates
        PlayingCard *candidateOne = [otherCards firstObject];
        PlayingCard *candidateTwo = [otherCards lastObject];
        
        // Match ranks
        if (candidateOne.rank == self.rank && candidateTwo.rank == self.rank) {
            // Match 3 ranks
            // Combinations: 52 * 3 * 2 = 312
            score += 100;
        } else if (candidateOne.rank == self.rank ||
                   candidateTwo.rank == self.rank ||
                   candidateOne.rank == candidateTwo.rank) {
            // Match 2 ranks: 3 combinations
            // Combinations: 52 * 3 * (52 - 2) = 7,800
            score += 4;
        }
        
        // Match suits
        if ([candidateOne.suit isEqualToString:self.suit] &&
            [candidateTwo.suit isEqualToString: self.suit]) {
            // Match 3 suits
            // Combinations: 52 * 12 * 11 = 6,864
            score += 5;
        } else if ([candidateOne.suit isEqualToString:self.suit] ||
                   [candidateTwo.suit isEqualToString:self.suit] ||
                   [candidateOne.suit isEqualToString:candidateTwo.suit]) {
            // Match 2 suits
            // Combinations: 52 * 12 * (52 - 2) = 31,200
            score += 1;
        }

    }
    
    return score;
}

@end
