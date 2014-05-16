//
//  SetCard.m
//  Matchismo
//
//  Created by Dario Vincent on 2/19/14.
//  Copyright (c) 2014 cs193p. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (int)matchCount
{
    return 3;
}

- (NSString *)contents
{
    return [NSString stringWithFormat:@"%@ %@ %@ %@", self.number, self.symbol, self.shading, self.color];
}

@synthesize number = _number;

+ (NSArray *)validNumbers
{
    return @[@"one",@"two",@"three"];
}

- (void)setNumber:(NSString *)number
{
    if ([[SetCard validNumbers] containsObject:number]) {
        _number = number;
    }
}

- (NSString *)number
{
    return _number ? _number : @"?";
}

@synthesize symbol = _symbol;

+ (NSArray *)validSymbols
{
    return @[@"diamond",@"squiggle",@"oval"];
}

- (void)setSymbol:(NSString *)symbol
{
    if ([[SetCard validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
}

- (NSString *)symbol
{
    return _symbol ? _symbol : @"?";
}

@synthesize shading = _shading;

+ (NSArray *)validShadings
{
    return @[@"solid",@"striped",@"open"];
}

- (void)setShading:(NSString *)shading
{
    if ([[SetCard validShadings] containsObject:shading]) {
        _shading = shading;
    }
}

- (NSString *)shading
{
    return _shading ? _shading : @"?";
}

@synthesize color = _color;

+ (NSArray *)validColors
{
    return @[@"red",@"green",@"purple"];
}

- (void)setColor:(NSString *)color
{
    if ([[SetCard validColors] containsObject:color]) {
        _color = color;
    }
}

- (NSString *)color
{
    return _color ? _color : @"?";
}

- (int)match:(NSArray *)otherCards
{
    int numberScore = 0;
    int symbolScore = 0;
    int shadingScore = 0;
    int colorScore = 0;
        
    // Match only when there are 2 other cards
    if ([otherCards count] == 2) {
        
        // Identify candidates
        SetCard *candidateOne = [otherCards firstObject];
        SetCard *candidateTwo = [otherCards lastObject];
        
        // Match number
        if (([candidateOne.number isEqualToString:self.number] &&
             [candidateTwo.number isEqualToString:self.number]) ||
            (![candidateOne.number isEqualToString:self.number] &&
             ![candidateTwo.number isEqualToString:self.number] &&
             ![candidateOne.number isEqualToString:candidateTwo.number])) {
            numberScore = 1;
        }
        
        // Match symbol
        if ((candidateOne.symbol == self.symbol &&
             candidateTwo.symbol == self.symbol) ||
            (candidateOne.symbol != self.symbol &&
             candidateTwo.symbol != self.symbol &&
             candidateOne.symbol != candidateTwo.symbol)) {
                symbolScore = 1;
        }
        
        // Match shading
        if ((candidateOne.shading == self.shading &&
             candidateTwo.shading == self.shading) ||
            (candidateOne.shading != self.shading &&
             candidateTwo.shading != self.shading &&
             candidateOne.shading != candidateTwo.shading)) {
                shadingScore = 1;
        }
        
        // Match color
        if ((candidateOne.color == self.color &&
             candidateTwo.color == self.color) ||
            (candidateOne.color != self.color &&
             candidateTwo.color != self.color &&
             candidateOne.color != candidateTwo.color)) {
                colorScore = 1;
        }
        
    }
    // Combinations: 1080 unique sets
//    if (numberScore == 1 && symbolScore == 0 && shadingScore == 0 && colorScore == 0) {
//    }
//    } else {
//        
        return numberScore * symbolScore * shadingScore * colorScore * 1080;
//    }
}

@end
