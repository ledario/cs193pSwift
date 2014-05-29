//
//  CardView.h
//  Matchismo
//
//  Created by Dario Vincent on 5/20/14.
//  Copyright (c) 2014 cs193p. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@class CardView;

@protocol CardViewDelegate <NSObject>
@optional
- (void)cardHasBeenFlipped:(CardView *)cardView;
@end

@interface CardView : UIView

@property (nonatomic, assign) id delegate;

@property (weak, nonatomic) Card *card;
@property (nonatomic, getter = isFaceUp) BOOL faceUp;
@property (nonatomic,readonly) CGFloat cornerRadius;
@property (nonatomic, readonly) CGFloat cornerScaleFactor;

- (void)tapCard:(UITapGestureRecognizer *)gesture;

@end
