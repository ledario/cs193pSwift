//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Dario Vincent on 11/18/13.
//  Copyright (c) 2013 cs193p. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
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


@end
