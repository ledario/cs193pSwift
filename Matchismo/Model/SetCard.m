//
//  SetCard.m
//  Matchismo
//
//  Created by Dario Vincent on 2/19/14.
//  Copyright (c) 2014 cs193p. All rights reserved.
//

#import "SetCard.h"

#define MATCH_COUNT 3
#define MATCH_SCORE_COMPLETE 4
#define MATCH_SCORE_PARTIAL 1

@implementation SetCard

- (NSUInteger)matchCount
{
    return MATCH_COUNT;
}

- (NSString *)contents
{
    return [NSString stringWithFormat:@"%d %@ %@ %@", (int)self.number, self.symbol, self.shading, self.color];
}

@synthesize number = _number;

+ (NSArray *)validNumbers
{
    return @[@1,@2,@3];
}

+ (NSUInteger)maxNumber
{
    return [[self validNumbers] count];
}

- (void)setNumber:(NSUInteger)number
{
    if ([[SetCard validNumbers] containsObject:[NSNumber numberWithUnsignedInteger:number]]) {
        _number = number;
    }
}

- (NSUInteger)number
{
    return _number ? _number : 0;
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

- (NSInteger)match:(NSArray *)otherCards
{
    NSInteger numberScore = 0;
    NSInteger symbolScore = 0;
    NSInteger shadingScore = 0;
    NSInteger colorScore = 0;
        
    // Match only when there are 2 other cards
    if ([otherCards count] == 2) {
        
        // Identify candidates
        SetCard *candidateOne = [otherCards firstObject];
        SetCard *candidateTwo = [otherCards lastObject];
        
        // Match number
        if ((candidateOne.number == self.number &&
             candidateTwo.number == self.number) ||
            (!(candidateOne.number == self.number) &&
             !(candidateTwo.number == self.number) &&
             !(candidateOne.number == candidateTwo.number))) {
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
    return numberScore * symbolScore * shadingScore * colorScore * 1080;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[SetCard class]]) {
        return (self.number == ((SetCard *)object).number)
            && [self.symbol isEqualToString:((SetCard *)object).symbol]
            && [self.shading isEqualToString:((SetCard *)object).shading]
            && [self.color isEqualToString:((SetCard *)object).color];
    } else {
        return NO;
    }
}

@end
