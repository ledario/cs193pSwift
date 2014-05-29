//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Dario Vincent on 11/18/13.
//  Copyright (c) 2013 cs193p. All rights reserved.
//

#import "CardGameViewController.h"
#import "Grid.h"

#pragma mark - Properties

#define CARD_COUNT 1
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
    return _cardCount = CARD_COUNT;
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

#pragma mark - Delegate callback

- (void)cardHasBeenFlipped:(CardView *)cardView
{
    Card *card = (Card *)cardView.card;
    card.chosen = !card.isChosen;
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
// TODO: replacement implementation with "return nil;"
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
            Card *card = [self.game cardAtIndex:row*grid.columnCount+column];
            CGRect cardViewFrame = [grid frameOfCellAtRow:row inColumn:column];
            CardView *cardView = [self createCardViewWithFrame:cardViewFrame];
            cardView.delegate = self;
            cardView.card = card;
            [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:cardView action:@selector(tapCard:)]];
            [self.gridView addSubview:cardView];
            cardsRemaining--;
        }
    }
}

@end
