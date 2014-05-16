//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Dario Vincent on 11/18/13.
//  Copyright (c) 2013 cs193p. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

- (Deck *)createDeck;

-(NSAttributedString *)playDescriptionText:(NSDictionary *)historyEntry;

@end