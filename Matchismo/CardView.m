//
//  CardView.m
//  Matchismo
//
//  Created by Dario Vincent on 5/20/14.
//  Copyright (c) 2014 cs193p. All rights reserved.
//

#import "CardView.h"


//@interface CardView()
//@property (nonatomic) CGFloat faceCardScaleFactor;
//@end

@implementation CardView

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

#pragma mark - Properties

// The following setter and getter synchronize the value
// of cardView.faceUp with that of cardView.card.chosen
//@synthesize faceUp = _faceUp;

- (BOOL)isFaceUp
{
    return self.card.isChosen;
}

- (void)setFaceUp:(BOOL)faceUp
{
    self.card.chosen = faceUp;
}

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90

- (CGFloat)faceCardScaleFactor
{
    if (!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    return _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor
{
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

#pragma mark - Gesture Handling

- (void)tapCard:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.faceUp = !self.isFaceUp;
    }
    [self setNeedsDisplay];
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if (self.faceUp && (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded)) {
        self.faceCardScaleFactor *= gesture.scale;
        gesture.scale = 1.0;
    }
}

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];

    CGRect imageRect = CGRectInset(self.bounds,
                                   self.bounds.size.width * (1.0 - self.faceCardScaleFactor),
                                   self.bounds.size.height * (1.0 - self.faceCardScaleFactor));
    if (self.faceUp) {
        [self drawContentsInRect:imageRect];
    } else {
        [[UIImage imageNamed:@"cardback"] drawInRect:imageRect];
    }
    
}

- (void)pushContext
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
}

- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

// Override this method to draw specific card for a concrete class
- (void)drawContentsInRect:(CGRect)contentsRect
{
    // Default implementation using attributed string to render contents
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *contentsFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    contentsFont = [contentsFont fontWithSize:contentsFont.pointSize * self.faceCardScaleFactor];
    
    NSAttributedString *contentsAttributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", self.card.contents] attributes:@{ NSFontAttributeName : contentsFont, NSParagraphStyleAttributeName : paragraphStyle }];
    
    [self pushContext];
    [contentsAttributedText drawInRect:contentsRect];
    [self popContext];
}

@end
