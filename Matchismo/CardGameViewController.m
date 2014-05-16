//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Dario Vincent on 11/18/13.
//  Copyright (c) 2013 cs193p. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "GameHistoryViewController.h"

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *instantPlayDescription;
@end

@implementation CardGameViewController

- (IBAction)deal:(UIButton *)sender {
    self.game = nil;
    
    [self updateUI];
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    return _game;
}

- (Deck *)createDeck
{
    return nil; // Abstract method to be implemented in concrete class
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (NSAttributedString *)playDescriptionText
{
    // Build description string of the list of cards in the play
    NSMutableAttributedString *playDescriptionText = [[NSMutableAttributedString alloc] init];
    
    // For each card in play
    for (int i=0; i<self.game.cardsInPlay.count; i++) {
        // Initialize a separator for when multiple card values
        NSAttributedString *separator = [[NSAttributedString alloc] initWithString:
                                         ((i == (self.game.cardsInPlay.count - 1)) ? @"" : @", ")];
        // Add each card to the description
        [playDescriptionText appendAttributedString:[self attributedTitleforCard:
                                                   (Card *)self.game.cardsInPlay[i]]];
        // Add separator to description
        [playDescriptionText appendAttributedString:separator];
    }
    if (playDescriptionText.length != 0) {
        // Description for a successful match attempt
        if ([self.game.matchPlay isEqualToString:@"success"]) {
            [playDescriptionText insertAttributedString:[[NSAttributedString alloc] initWithString:@"Matched "] atIndex:0];
            [playDescriptionText appendAttributedString:[[NSAttributedString alloc]
                                                       initWithString:[NSString stringWithFormat:
                                                                       @" for %d points.",
                                                                       self.game.playScore]]];
        // Description of a failed match attempt
        } else if ([self.game.matchPlay isEqualToString:@"fail"]) {
            [playDescriptionText appendAttributedString:[[NSAttributedString alloc]
                                                       initWithString:[NSString stringWithFormat:
                                                                       @" don't match. %d-point penalty!",
                                                                       self.game.playScore]]];
        // Default description of play when there is no match attempt
        } else {
            [playDescriptionText appendAttributedString:[[NSAttributedString alloc] initWithString:@"Flipped up "]];
        }
    }
    
    return playDescriptionText;
}

- (NSAttributedString *)playDescriptionText:(NSDictionary *)historyEntry
{
    // Build description string of the list of cards in the play
    NSMutableAttributedString *playDescriptionText = [[NSMutableAttributedString alloc] init];
    
    // For each card in play
    NSArray *cardsInPlay = nil;
    if ([[historyEntry objectForKey:@"cardsInPlay"] isKindOfClass:[NSArray class]]) {
        cardsInPlay = (NSArray *)historyEntry[@"cardsInPlay"];
    }
    for (int i=0; i<cardsInPlay.count; i++) {
    //for (int i=0; i<self.game.cardsInPlay.count; i++) {
        // Initialize a separator for when multiple card values
        NSAttributedString *separator = [[NSAttributedString alloc] initWithString:
                                         ((i == (cardsInPlay.count - 1)) ? @"" : @", ")];
        // Add each card to the description
        [playDescriptionText appendAttributedString:[self attributedTitleforCard:
                                                     (Card *)cardsInPlay[i]]];
        // Add separator to description
        [playDescriptionText appendAttributedString:separator];
    }
    if (playDescriptionText.length != 0) {
        // Description for a successful match attempt
        if ([self.game.matchPlay isEqualToString:@"success"]) {
            [playDescriptionText insertAttributedString:[[NSAttributedString alloc] initWithString:@"Matched "] atIndex:0];
            [playDescriptionText appendAttributedString:[[NSAttributedString alloc]
                                                         initWithString:[NSString stringWithFormat:
                                                                         @" for %d points.",
                                                                         self.game.playScore]]];
            // Description of a failed match attempt
        } else if ([self.game.matchPlay isEqualToString:@"fail"]) {
            [playDescriptionText appendAttributedString:[[NSAttributedString alloc]
                                                         initWithString:[NSString stringWithFormat:
                                                                         @" don't match. %d-point penalty!",
                                                                         self.game.playScore]]];
            // Default description of play when there is no match attempt
        } else {
            [playDescriptionText appendAttributedString:[[NSAttributedString alloc] initWithString:@" Flipped up "]];
        }
    }
    
    return playDescriptionText;
}

- (NSAttributedString *)gameHistoryText:(NSArray *)gameHistory {
    
    // Build description string of the list of cards in the play
    NSMutableAttributedString *gameHistoryDisplay = [[NSMutableAttributedString alloc] init];;
    NSAttributedString *separator = [[NSAttributedString alloc] initWithString:@"\n" attributes:nil];
    for (int i=0; i<gameHistory.count; i++) {
        if ([gameHistory[i] isKindOfClass:[NSDictionary class]]) {
            [gameHistoryDisplay appendAttributedString:[self playDescriptionText:(NSDictionary *)gameHistory[i]]];
            [gameHistoryDisplay appendAttributedString:separator];
        }
    }
    
    return gameHistoryDisplay;
}

- (void)updateUI
{
    // Update the view with the status of each cards
    for (UIButton *cardButton in self.cardButtons) {
        
        // Identify location of card
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        
        // Reset the card when the game has restarted
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        if (card.isChosen || card.isMatched) {
            [self setCardTitle:card forButton:cardButton];
        } else {
            [self setCardTitle:nil forButton:cardButton];
        }
        
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        
        // Disable cards that have been matched out of the game
        cardButton.enabled = !card.isMatched;
    }
    // Reset the score when the game has restarted - Match-Count switch enabled
    int score = self.game.score;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", score];
    
    // Display game play when game is in progress
    [self instantPlay];
}

- (void)instantPlay
{
    if (self.playDescriptionText.length != 0) {
        // Play description when there is one
//        self.instantPlayDescription.attributedText = [self playDescriptionText];
        self.instantPlayDescription.attributedText = [[self.game.playHistory lastObject] isKindOfClass:[NSDictionary class]] ? [self playDescriptionText:(NSDictionary *)[self.game.playHistory lastObject]] : nil;
    } else {
        // Default display when there are no cards in play
        self.instantPlayDescription.attributedText = [[NSAttributedString alloc] initWithString:@"Chose a card"];
    }
}

- (NSString *)titleForCard:(Card *)card
{
//    return card.isChosen ? card.contents : @"";
    return card.contents;

}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

-(NSAttributedString *)attributedTitleforCard:(Card *)card
// Default implementation to be overriden in concrete class
// The specific class implementation will provide on-screen representation for the value of a card
{
    return [[NSAttributedString alloc] initWithString:[self titleForCard:card]];
}

- (void)setCardTitle:(Card*)card forButton:(UIButton *)button
// Default implementation to be overriden in concrete class
{
    [button setTitle:[self titleForCard:card] forState:UIControlStateNormal];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Game History"]) {
        if ([segue.destinationViewController isKindOfClass:[GameHistoryViewController class]]) {
            GameHistoryViewController *gameHistoryVC = (GameHistoryViewController *)segue.destinationViewController;
            gameHistoryVC.gameHistoryText = [self gameHistoryText:self.game.playHistory];
        }
    }
}

@end
