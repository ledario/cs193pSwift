//
//  SetCard.h
//  Matchismo
//
//  Created by Dario Vincent on 2/19/14.
//  Copyright (c) 2014 cs193p. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (strong, nonatomic) NSString *color;

+ (NSArray *)validNumbers;
+ (NSArray *)validSymbols;
+ (NSArray *)validShadings;
+ (NSArray *)validColors;

@end
