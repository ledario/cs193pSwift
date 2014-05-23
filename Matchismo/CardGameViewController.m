//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Dario Vincent on 11/18/13.
//  Copyright (c) 2013 cs193p. All rights reserved.
//

#import "CardGameViewController.h"
//#import "CardView.h"

#pragma mark - Properties

#define CARD_COUNT 12
#define CARD_ASPECT_RATIO 0.6

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) NSUInteger cardCount;
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

// Replace with specific card in concrete class
- (CardView *)drawCardForGrid:(Grid *)grid atRow:(NSUInteger)row atColumn:(NSUInteger)column
{
    CardView *cardView = [[CardView alloc] initWithFrame:[grid frameOfCellAtRow:row inColumn:column]];
    // TODO: check index arithmetic
    Card *card = [self.game cardAtIndex:row*grid.rowCount+column];
    cardView.contents = card.contents;
    return cardView;
}

// Replace with specific card in concrete class
- (void)drawCardView:(CardView *)cardView ForCard:(Card *)card
{
    cardView.contents = @"King of spade";
}

// Replace with specific card in concrete class
- (CardView *)createCardViewWithFrame:(CGRect)frame
{
    return [[CardView alloc] initWithFrame:frame];
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
            //TODO: Check arithmetic
            Card *card = [self.game cardAtIndex:row*grid.rowCount+column];
            CGRect cardViewFrame = [grid frameOfCellAtRow:row inColumn:column];
//            CardView *cardView = [[CardView alloc] initWithFrame:cardViewFrame];
            CardView *cardView = [self createCardViewWithFrame:cardViewFrame];
            [self drawCardView:cardView ForCard:card];
            [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:cardView action:@selector(tapCard:)]];
            [cardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:cardView action:@selector(pinch:)]];
            [self.gridView addSubview:cardView];
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
