//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Dario Vincent on 11/18/13.
//  Copyright (c) 2013 cs193p. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "CardView.h"
#import "Grid.h"

#pragma mark - Properties

#define CARD_COUNT 12
#define CARD_ASPECT_RATIO 0.6

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic, readwrite) NSUInteger cardCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *gridView;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardCount
                                                          usingDeck:[self createDeck]];
    return _game;
}

- (NSUInteger)cardCount
{
    return CARD_COUNT;
}

- (Deck *)createDeck
{
    return nil; // Abstract method to be implemented in concrete class
}

#pragma mark - Actions

- (IBAction)deal:(UIButton *)sender {
    self.game = nil;
    
    [self updateUI];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

#pragma mark - Draw UI

-(void)viewWillLayoutSubviews
{
    [self cleanup];
}

- (void)viewDidLayoutSubviews
{
    [self updateUI];
}

- (void)cleanup
{
    for (CardView *cardView in self.gridView.subviews) {
        [cardView removeFromSuperview];
    }
}

- (void)addCardToGrid:(Grid *)grid atRow:(NSUInteger)row atColumn:(NSUInteger)column
{
    [self.gridView addSubview:[[CardView alloc] initWithFrame:[grid frameOfCellAtRow:row inColumn:column]]];
}

- (void)updateUI
{
    Grid *grid = [[Grid alloc] init];
    grid.size = self.gridView.bounds.size;
    grid.cellAspectRatio = CARD_ASPECT_RATIO;
    grid.minimumNumberOfCells = self.cardCount;
    
    NSUInteger rowCount = grid.rowCount;
    NSUInteger columnCount = grid.columnCount;
    
    NSUInteger cardsRemaining = self.cardCount;
    for (NSUInteger row = 0; row < rowCount && cardsRemaining; row++) {
        for (NSUInteger column = 0; column < columnCount && cardsRemaining; column++) {
            [self addCardToGrid:grid atRow:row atColumn:column];
            cardsRemaining--;
        }
    }
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (void)updateUI_Disabled
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

- (void)setCardTitle:(Card*)card forButton:(UIButton *)button
// Default implementation to be overriden in concrete class
{
    [button setTitle:[self titleForCard:card] forState:UIControlStateNormal];
}

- (NSString *)titleForCard:(Card *)card
{
//    return card.isChosen ? card.contents : @"";
    return card.contents;

}

@end
