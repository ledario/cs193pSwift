//
//  CardView.h
//  Matchismo
//
//  Created by Dario Vincent on 5/20/14.
//  Copyright (c) 2014 cs193p. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface CardView : UIView

@property (strong, nonatomic) Card *card;
@property (strong, nonatomic) NSString *contents;
@property (nonatomic, getter = isFaceUp) BOOL faceUp;
@property (nonatomic) CGFloat faceCardScaleFactor;

- (CGFloat)cornerScaleFactor;
- (CGFloat)cornerRadius;
- (CGFloat)cornerOffset;

- (void)tapCard:(UITapGestureRecognizer *)gesture;
- (void)pinch:(UIPinchGestureRecognizer *)gesture;

// Override this method to draw specific card for a concrete class
- (void)drawContentsInRect:(CGRect)contentsRect;

- (void)pushContext;
- (void)popContext;


@end
