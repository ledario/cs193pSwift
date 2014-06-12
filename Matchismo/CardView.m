//
//  CardView.m
//  Matchismo
//
//  Created by Dario Vincent on 5/20/14.
//  Copyright (c) 2014 cs193p. All rights reserved.
//

#import "CardView.h"

#pragma mark - Properties

@interface CardView()
@property (weak, nonatomic,readwrite) Card *card;
@property (nonatomic, readwrite) CGFloat cornerRadius;
@property (nonatomic, readwrite) CGFloat cornerScaleFactor;
@end

@implementation CardView

- (BOOL)isFaceUp
{
    return self.card.isChosen;
}

- (void)setFaceUp:(BOOL)faceUp
{
    self.card.chosen = faceUp;
}

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }

- (CGFloat)cornerRadius { return CORNER_RADIUS * self.cornerScaleFactor; }

#pragma mark - Initialization

- (void)setUp
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setUp];
}

// Override
// Disable the inherited designated initializer
- (id)initWithFrame:(CGRect)frame
{
    return nil;
}

// Designated Initializer
- (instancetype)initWithCard:(Card *)card andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.card = card;
        [self setUp];
    }
    return self;
}

#pragma mark - Gesture Handling

- (void)tapCard:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        __weak CardView *weakSelf = self;        
        [UIView transitionWithView:self
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{ [weakSelf.delegate cardViewWillFlip:weakSelf]; }
                        completion:^(BOOL finished){ [weakSelf.delegate cardViewHasFlipped:weakSelf]; }
         ];
    }
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawCardBase
{
    // Drawing card shape
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    // Keep contents within card shape
    [roundedRect addClip];
    // Card background color
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    // Card edge color
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self drawCardBase];
}

@end
