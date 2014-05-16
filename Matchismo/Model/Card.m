//
//  Card.m
//  Matchismo
//
//  Created by Dario Vincent on 11/28/13.
//  Copyright (c) 2013 cs193p. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)matchCount
{
    return 1;
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if (otherCards.count == [self matchCount]) {
        for (Card *card in otherCards) {
            if ([card.contents isEqualToString:self.contents]) {
                score = 1;
            }
        }
    }
    
    return score;
}

@end
