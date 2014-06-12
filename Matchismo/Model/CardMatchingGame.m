//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Dario Vincent on 12/8/13.
//  Copyright (c) 2013 cs193p. All rights reserved.
//

#import "CardMatchingGame.h"

//#define MATCH_SUCCESS @"success"
//#define MATCH_FAIL @"fail"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSInteger playScore;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index<[self.cards count]) ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (NSMutableArray *)listOfChosenCards
{
    // Return a list of cards that are chosen and but not matched out of game
    NSMutableArray *listOfChosenCards = [[NSMutableArray alloc] init];
    for (Card *card in self.cards) {
        if (card.isChosen && !card.isMatched) {
            [listOfChosenCards addObject:card];
        }
    }
    return [listOfChosenCards mutableCopy];
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
    // Identify chosen card at given location
    Card *card = [self cardAtIndex:index];
    
    [self chooseCard:card];
}

- (void)chooseCard:(Card *)card
{
    // Work only on cards not yet matched
    if (!card.isMatched) {
        
        // Keep a running list of other cards chosen for match
        NSMutableArray *listOfOtherChosenCards = [self listOfChosenCards];
        
        // If this card is already chosen
        if (card.isChosen) {
            // If this card is the only one already chosen then flip it over
            if (listOfOtherChosenCards.count == 1) {
                // Remove from chosen list - flip card over
                card.chosen = NO;
            }
            // This card is not already chosen
        } else {
            // Initialize play history variables
            // Mark chosen and decrease score (cost of choosing)
            card.chosen = YES;
            self.playScore = COST_TO_CHOOSE;
            self.score -= self.playScore;
            
            // If there are enough other cards selected for match
            if (listOfOtherChosenCards.count == [card matchCount] - 1) {
                // Match cards
                NSUInteger matchScore = [card match:listOfOtherChosenCards];
                if (matchScore) {
                    // Match successful - increase score - update play status
                    self.playScore = matchScore * MATCH_BONUS;
                    self.score += self.playScore;
                    for (Card *otherCard in listOfOtherChosenCards) {
                        // Mark all cards matched out of game
                        otherCard.matched = YES;
                        card.matched = YES;
                    }
                } else {
                    // Match failed - decrease score - update play status
                    self.playScore = MISMATCH_PENALTY;
                    self.score -= self.playScore;
                    for (Card *otherCard in listOfOtherChosenCards) {
                        // Remove other cards from list of cards chosen for match
                        otherCard.chosen = NO;
                    }
                }
            }
        }
    }
}

@end
