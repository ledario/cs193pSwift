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
@property (nonatomic, readwrite) NSString *matchPlay;
@property (nonatomic, readwrite) NSArray *cardsInPlay; // of Card
@property (nonatomic, strong) NSMutableArray *cardsInPlayMutable; // of Card
@property (nonatomic, readwrite) NSArray *playHistory;
@property (nonatomic, strong) NSMutableArray *mutablePlayHistory;
//@property (nonatomic, strong) NSDictionary *playResult;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)cardsInPlayMutable
{
    if (!_cardsInPlayMutable) _cardsInPlayMutable = [[NSMutableArray alloc] init];
    return _cardsInPlayMutable;
}

- (NSMutableArray *)mutablePlayHistory
{
    if (!_mutablePlayHistory) _mutablePlayHistory = [[NSMutableArray alloc] init];
    return _mutablePlayHistory;
}

- (NSArray *)playHistory
{
//    return [self.mutablePlayHistory copy];
    return self.mutablePlayHistory;
}

- (NSArray *)cardsInPlay
{
    return [self.cardsInPlayMutable copy];
}

- (void)setMatchPlay:(NSString *)matchPlay
{
    if ([matchPlay isEqualToString:@"success"] ||
        [matchPlay isEqualToString:@"fail"]) {
        _matchPlay = matchPlay;
    } else {
        _matchPlay = nil;
    }
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
    // Reset move description
    self.matchPlay = nil;
    self.cardsInPlayMutable = nil;
    
    // Identify chosen card at given location
    Card *card = [self cardAtIndex:index];
    
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
            NSString *matchPlay = @"";
            NSMutableArray *cardsInPlayMutable = [[NSMutableArray alloc] init];
            // Mark chosen and decrease score (cost of choosing)
            card.chosen = YES;
            self.playScore = COST_TO_CHOOSE;
            self.score -= self.playScore;

            // Add this card to the play
            [self.cardsInPlayMutable addObject:card];
            [cardsInPlayMutable addObject:card];

            // If there are enough other cards selected for match
            if (listOfOtherChosenCards.count == [card matchCount] - 1) {
                // Match cards
                int matchScore = [card match:listOfOtherChosenCards];
                if (matchScore) {
                    // Match successful - increase score - update play status
                    self.playScore = matchScore * MATCH_BONUS;
                    self.score += self.playScore;
                    self.matchPlay = @"success";
                    matchPlay = @"success";
                    for (Card *otherCard in listOfOtherChosenCards) {
                        // Mark all cards matched out of game
                        otherCard.matched = YES;
                        card.matched = YES;
                    }
                } else {
                    // Match failed - decrease score - update play status
                    self.playScore = MISMATCH_PENALTY;
                    self.score -= self.playScore;
                    self.matchPlay = @"fail";
                    matchPlay = @"fail";
                    for (Card *otherCard in listOfOtherChosenCards) {
                        // Remove other cards from list of cards chosen for match
                            otherCard.chosen = NO;
                    }
                }
                
                // Add other selected cards to the play
                for (Card *otherCardInPlay in listOfOtherChosenCards) {
                    [self.cardsInPlayMutable addObject:otherCardInPlay];
                    [cardsInPlayMutable addObject:otherCardInPlay]; 
                }
            }
            // Add the last play to the game history
            NSDictionary *historyEntry = @{@"matchPlay" : matchPlay,
                                           @"cardsInPlay" : [cardsInPlayMutable copy]};
            [self.mutablePlayHistory addObject:historyEntry];
        }
    }
}


@end
