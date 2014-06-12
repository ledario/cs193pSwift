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

#pragma mark - Initialization

// Designated Initializer
- (instancetype)initWithCard:(Card *)card andFrame:(CGRect)frame
{
    self = [super initWithCard:card andFrame:frame];
    if (![card isKindOfClass:[SetCard class]]) {
        self = nil;
    }
    return self;
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
//        [self drawContentsInRect:self.bounds];
        [self drawSymbols];
    } else {
        [[UIImage imageNamed:@"cardback"] drawInRect:imageRect];
    }
}

#pragma mark - Draw Contents

- (void)drawContentsInRect:(CGRect)contentsRect
{
    SetCard *setCard = (SetCard *)self.card;
    
    NSUInteger maxNumber = [SetCard maxNumber];
    NSUInteger cardNumber = setCard.number;
    for (NSUInteger number=0; number < cardNumber; number++) {
        [self pushContext];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, contentsRect.origin.x, contentsRect.origin.y + number * (contentsRect.size.height / cardNumber));
        
        CGRect symbolRect = CGRectMake(contentsRect.origin.x + self.cornerRadius,
                                        contentsRect.origin.y + self.cornerRadius,
                                        contentsRect.size.width - (2 * self.cornerRadius),
                                        (contentsRect.size.height - (2 * self.cornerRadius)) / maxNumber);
        [self drawSquiggleInRect:symbolRect];
        [self popContext];
    }
}

- (void)drawSquiggleInRect:(CGRect)rect
{
//    SetCard *setCard = (SetCard *)self.card;

    // Save drawing context
    [self pushContext];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, self.cornerRadius, self.cornerRadius);

    // Draw shape
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:CGPointMake(0, rect.size.height)];
    
    [path addLineToPoint:CGPointMake(0, rect.size.height * 3/4)];
    
    [path addCurveToPoint:CGPointMake(rect.size.width, 0)
            controlPoint1:CGPointMake(rect.size.width * 2/6, 0)
            controlPoint2:CGPointMake(rect.size.width * 4/6, rect.size.height * 3/4)];
    
    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height * 1/4)];
    
    [path addCurveToPoint:CGPointMake(0, rect.size.height)
            controlPoint1:CGPointMake(rect.size.width * 4/6, rect.size.height)
            controlPoint2:CGPointMake(rect.size.width * 2/6, rect.size.height * 1/4)];

    [path closePath];
    
    [[UIColor redColor] setFill];
    [[UIColor blackColor] setStroke];
    [path fill];
    [path stroke];
    
    // Restore drawing context
    [self popContext];
}

#pragma mark - Borrowed Draw Code

#define SYMBOL_OFFSET 0.2;
#define SYMBOL_LINE_WIDTH 0.02;

- (void)drawSymbols
{
    SetCard *setCard = (SetCard *)self.card;
    [[self uiColor] setStroke];
    CGPoint point = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    if (setCard.number == 1) {
        [self drawSymbolAtPoint:point];
        return;
    }
    CGFloat dx = self.bounds.size.width * SYMBOL_OFFSET;
    if (setCard.number == 2) {
        [self drawSymbolAtPoint:CGPointMake(point.x - dx / 2, point.y)];
        [self drawSymbolAtPoint:CGPointMake(point.x + dx / 2, point.y)];
        return;
    }
    if (setCard.number == 3) {
        [self drawSymbolAtPoint:point];
        [self drawSymbolAtPoint:CGPointMake(point.x - dx, point.y)];
        [self drawSymbolAtPoint:CGPointMake(point.x + dx, point.y)];
        return;
    }
}

- (UIColor *)uiColor
{
    SetCard *setCard = (SetCard *)self.card;
    if ([setCard.color isEqualToString:@"red"]) return [UIColor redColor];
    if ([setCard.color isEqualToString:@"green"]) return [UIColor greenColor];
    if ([setCard.color isEqualToString:@"purple"]) return [UIColor purpleColor];
    return nil;
}

- (void)drawSymbolAtPoint:(CGPoint)point
{
    SetCard *setCard = (SetCard *)self.card;
    
    if ([setCard.symbol isEqualToString:@"oval"])
        [self drawOvalAtPoint:point];
    else if ([setCard.symbol isEqualToString:@"squiggle"])
        [self drawSquiggleAtPoint:point];
    else if ([setCard.symbol isEqualToString:@"diamond"])
        [self drawDiamondAtPoint:point];
}

#define OVAL_WIDTH 0.12
#define OVAL_HEIGHT 0.4
- (void)drawOvalAtPoint:(CGPoint)point;
{
    CGFloat dx = self.bounds.size.width * OVAL_WIDTH / 2;
    CGFloat dy = self.bounds.size.height * OVAL_HEIGHT / 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x - dx, point.y - dy, 2 * dx, 2 * dy)
                                                    cornerRadius:dx];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [self shadePath:path];
    [path stroke];
}

#define SQUIGGLE_WIDTH 0.12
#define SQUIGGLE_HEIGHT 0.3
#define SQUIGGLE_FACTOR 0.8
- (void)drawSquiggleAtPoint:(CGPoint)point;
{
    CGFloat dx = self.bounds.size.width * SQUIGGLE_WIDTH / 2;
    CGFloat dy = self.bounds.size.height * SQUIGGLE_HEIGHT / 2;
    CGFloat dsqx = dx * SQUIGGLE_FACTOR;
    CGFloat dsqy = dy * SQUIGGLE_FACTOR;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(point.x - dx, point.y - dy)];
    [path addQuadCurveToPoint:CGPointMake(point.x + dx, point.y - dy)
                 controlPoint:CGPointMake(point.x - dsqx, point.y - dy - dsqy)];
    [path addCurveToPoint:CGPointMake(point.x + dx, point.y + dy)
            controlPoint1:CGPointMake(point.x + dx + dsqx, point.y - dy + dsqy)
            controlPoint2:CGPointMake(point.x + dx - dsqx, point.y + dy - dsqy)];
    [path addQuadCurveToPoint:CGPointMake(point.x - dx, point.y + dy)
                 controlPoint:CGPointMake(point.x + dsqx, point.y + dy + dsqy)];
    [path addCurveToPoint:CGPointMake(point.x - dx, point.y - dy)
            controlPoint1:CGPointMake(point.x - dx - dsqx, point.y + dy - dsqy)
            controlPoint2:CGPointMake(point.x - dx + dsqx, point.y - dy + dsqy)];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [self shadePath:path];
    [path stroke];
}

#define DIAMOND_WIDTH 0.15
#define DIAMOND_HEIGHT 0.4
- (void)drawDiamondAtPoint:(CGPoint)point;
{
    CGFloat dx = self.bounds.size.width * DIAMOND_WIDTH / 2;
    CGFloat dy = self.bounds.size.height * DIAMOND_HEIGHT / 2;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(point.x, point.y - dy)];
    [path addLineToPoint:CGPointMake(point.x + dx, point.y)];
    [path addLineToPoint:CGPointMake(point.x, point.y + dy)];
    [path addLineToPoint:CGPointMake(point.x - dx, point.y)];
    [path closePath];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [self shadePath:path];
    [path stroke];
}

#define STRIPES_OFFSET 0.06
#define STRIPES_ANGLE 5
- (void)shadePath:(UIBezierPath *)path
{
        SetCard *setCard = (SetCard *)self.card;

    if ([setCard.shading isEqualToString:@"solid"]) {
        [[self uiColor] setFill];
        [path fill];
    } else if ([setCard.shading isEqualToString:@"striped"]) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        [path addClip];
        UIBezierPath *stripes = [[UIBezierPath alloc] init];
        CGPoint start = self.bounds.origin;
        CGPoint end = start;
        CGFloat dy = self.bounds.size.height * STRIPES_OFFSET;
        end.x += self.bounds.size.width;
        start.y += dy * STRIPES_ANGLE;
        for (int i = 0; i < 1 / STRIPES_OFFSET; i++) {
            [stripes moveToPoint:start];
            [stripes addLineToPoint:end];
            start.y += dy;
            end.y += dy;
        }
        stripes.lineWidth = self.bounds.size.width / 2 * SYMBOL_LINE_WIDTH;
        [stripes stroke];
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
    } else if ([setCard.shading isEqualToString:@"open"]) {
        [[UIColor clearColor] setFill];
    }
}
@end
