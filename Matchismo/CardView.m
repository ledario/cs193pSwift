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
// Designated initializer
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) [self setUp];
    return self;
}

#pragma mark - Gesture Handling

- (void)tapCard:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.delegate cardHasBeenFlipped:self];
    }
    [self setNeedsDisplay];
}

#pragma mark - Drawing

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
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
    
    // Override drawRect:
    // in subclass to draw specific card content
}

@end
