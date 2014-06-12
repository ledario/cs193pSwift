//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Dario Vincent on 11/18/13.
//  Copyright (c) 2013 cs193p. All rights reserved.
//

#import "CardGameViewController.h"
#import "Grid.h"
#import "Matchismo-Swift.h"

#pragma mark - Properties

#define CARD_COUNT 8
#define CARD_ASPECT_RATIO 0.6

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) CardMathingGame *gameSwift;
@property (nonatomic) NSUInteger cardCount;
@property (strong, nonatomic) NSArray *listOfCardsSelected;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *gridView;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardCount
                                                          usingDeck:[self createDeck]];
    return _game;
}

- (CardMathingGame *)gameSwift {
    if (!_gameSwift) _gameSwift = [[CardMathingGame alloc] initWithCardCount:self.cardCount
                                                          usingDeck:[self createDeck]];
    return _gameSwift;
}

- (NSUInteger)cardCount {
    return _cardCount = CARD_COUNT;
}


#pragma mark - Actions

- (IBAction)reset:(UIButton *)sender {
    self.game = nil;
    [self cleanup];
    [self updateUI];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}


#pragma mark - Utility methods

- (Deck *)createDeck {
    return nil; // Abstract method to be implemented in concrete class
}

- (NSArray *)listOfSelectedCards {
    NSMutableArray *listOfSelectedCards = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < self.cardCount; index++) {
        Card *card = [self.game cardAtIndex:index];
        if (card.isChosen) {
            [listOfSelectedCards addObject:card];
        }
    }
    return [listOfSelectedCards copy];
}


#pragma mark - Delegate callback

- (void)cardViewWillFlip:(CardView *)cardView {
    self.listOfCardsSelected = [self listOfSelectedCards];
    Card *card = (Card *)cardView.card;
    [self.game chooseCard:card];
}

- (void)cardViewHasFlipped:(CardView *)cardViewSender {
    
    NSMutableArray *listOfCardViews = [[NSMutableArray alloc] init];
    
    for (id cardView in self.gridView.subviews) {
        if ([cardView isKindOfClass:[CardView class]]) {
            Card *card = ((CardView *)cardView).card;
            if ([self.listOfCardsSelected containsObject:card]) {
                [listOfCardViews addObject:cardView];
            }
        }
    }

    [listOfCardViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
//        [UIView animateWithDuration:3
//                              delay:3
//                            options:UIViewAnimationOptionLayoutSubviews
//                         animations:^{
//                             [UIView transitionWithView:obj
//                                               duration:0
//                                                options:UIViewAnimationOptionTransitionCrossDissolve
//                                             animations:^{}
//                                             completion:^(BOOL finished){}];
//                         }
//                         completion:^(BOOL finished){}];

        [UIView transitionWithView:obj
                          duration:3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{}
                        completion:^(BOOL finished){}];

        [obj setNeedsDisplay];
    }];
    
}


#pragma mark - Draw UI

-(void)viewWillLayoutSubviews {
    [self cleanup];
}

- (void)viewDidLayoutSubviews {
    [self updateUI];
}

- (void)cleanup {
    for (CardView *cardView in self.gridView.subviews) {
        [cardView removeFromSuperview];
    }
}

// Replace with specific card in concrete class
- (CardView *)createCardViewWithCard:(Card *)card andFrame:(CGRect)frame {
    return nil; // Abstract method to be implemented in concrete class
}

- (void)updateUI {
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
            CardView *cardView = [self createCardViewWithCard:card andFrame:cardViewFrame];
            cardView.delegate = self;
            [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:cardView action:@selector(tapCard:)]];
            [self.gridView addSubview:cardView];
            cardsRemaining--;
        }
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

@end
