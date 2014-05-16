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

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
