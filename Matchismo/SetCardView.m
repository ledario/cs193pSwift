//
//  SetCardView.m
//  Matchismo
//
//  Created by Dario Vincent on 5/27/14.
//  Copyright (c) 2014 cs193p. All rights reserved.
//

#import "SetCardView.h"
#import "SetCard.h"

#pragma mark - Properties

@interface SetCardView()
@property (nonatomic) CGFloat faceCardScaleFactor;
@end

@implementation SetCardView

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90

- (CGFloat)faceCardScaleFactor { return DEFAULT_FACE_CARD_SCALE_FACTOR; }

- (void)setCard:(Card *)card
{
    if ([card isKindOfClass:[SetCard class]]) {
        super.card = card;
    }
}

#pragma mark - Drawing

- (void)pushContext
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
}

- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Draw card shape
    [super drawRect:rect];
    
    // Draw card contents
    CGRect imageRect = CGRectInset(self.bounds,
                                   self.bounds.size.width * (1.0 - self.faceCardScaleFactor),
                                   self.bounds.size.height * (1.0 - self.faceCardScaleFactor));
    if (self.faceUp) {
//        [self drawContentsInRect:imageRect];
        [self drawContentsInRect:self.bounds];
    } else {
        [[UIImage imageNamed:@"cardback"] drawInRect:imageRect];
    }
}

#pragma mark - Draw Contents

- (void)drawContentsInRect:(CGRect)contentsRect
{
//    SetCard *setCard = (SetCard *)self.card;
    CGRect symbolRect = CGRectMake(contentsRect.origin.x, contentsRect.origin.y, contentsRect.size.width, contentsRect.size.height/3.0);
    [self drawSquiggleInRect:symbolRect];
}

- (void)drawSquiggleInRect:(CGRect)rect
{
    // Save drawing context
    [self pushContext];
    
    // Draw shape
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, rect.size.height)];
    [path addCurveToPoint:CGPointMake(rect.size.width, 0.0) controlPoint1:CGPointMake(rect.size.width / 6.0, 0.0) controlPoint2:CGPointMake(rect.size.width / 4.0, rect.size.height * 2.0 / 3.0)];
//    [path addLineToPoint:CGPointMake(rect.size.width, 0)];
    [path closePath];
    [[UIColor redColor] setFill];
    [[UIColor blackColor] setStroke];
    [path fill];
    [path stroke];
    
    // Restore drawing context
    [self popContext];
}

@end
