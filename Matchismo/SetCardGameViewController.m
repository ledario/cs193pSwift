//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Dario Vincent on 2/24/14.
//  Copyright (c) 2014 cs193p. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

- (Deck *)createDeck
{
    Deck *deck = [[SetCardDeck alloc] init];
    return deck;
}

- (void)setCardTitle:(Card *)card forButton:(UIButton *)button {
    NSAttributedString *title = (card) ? [[NSAttributedString alloc] initWithString:card.contents] : nil;
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard *)card;
        title = [self attributedTitleforCard:setCard];
    }
    [button setAttributedTitle:title forState:UIControlStateNormal];
}

- (NSAttributedString *)attributedTitleforCard:(SetCard *)card
{
    //Set symbol
    NSString *cardSymbol = @"?";
    if ([card.symbol isEqualToString:@"diamond"]) {
        cardSymbol = @"▲";
    } else if ([card.symbol isEqualToString:@"squiggle"]){
        cardSymbol = @"◼︎";
    } else if ([card.symbol isEqualToString:@"oval"])
        cardSymbol = @"●";
    
    //set number
    if ([card.number isEqualToString:@"two"]) {
        cardSymbol = [cardSymbol stringByAppendingString:cardSymbol];
    } else if ([card.number isEqualToString:@"three"]) {
        cardSymbol = [[cardSymbol stringByAppendingString:cardSymbol] stringByAppendingString:cardSymbol];
    }
    
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    //set color
    if ([card.color isEqualToString:@"red"]) {
        [attributes setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
    } else if ([card.color isEqualToString:@"green"]) {
        [attributes setObject:[UIColor greenColor] forKey:NSForegroundColorAttributeName];
    } else if ([card.color isEqualToString:@"purple"]) {
        [attributes setObject:[UIColor purpleColor] forKey:NSForegroundColorAttributeName];
    }
    
    //set shading
    if ([card.shading isEqualToString:@"solid"])
        [attributes setObject:@-5 forKey:NSStrokeWidthAttributeName];
    if ([card.shading isEqualToString:@"striped"])
        [attributes addEntriesFromDictionary:@{
                                               NSStrokeWidthAttributeName : @-5,
                                               NSStrokeColorAttributeName : attributes[NSForegroundColorAttributeName],
                                               NSForegroundColorAttributeName : [attributes[NSForegroundColorAttributeName] colorWithAlphaComponent:0.3]
                                               }];
    if ([card.shading isEqualToString:@"open"])
        [attributes setObject:@5 forKey:NSStrokeWidthAttributeName];
    
    return [[NSMutableAttributedString alloc] initWithString:cardSymbol attributes:attributes];
}

@end
