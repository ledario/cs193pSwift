//
//  PlayingCardView.m
//  SuperCard
//
//  Created by Dario Vincent on 5/19/14.
//  Copyright (c) 2014 cs193p. All rights reserved.
//

#import "PlayingCardView.h"
#import "PlayingCard.h"

@interface CardView()
- (void)drawCardBase;
@end

#pragma mark - Properties

@interface PlayingCardView()
@property (nonatomic) CGFloat faceCardScaleFactor;
@property (nonatomic) CGFloat cornerOffset;
@end

@implementation PlayingCardView

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90

- (CGFloat)faceCardScaleFactor { return DEFAULT_FACE_CARD_SCALE_FACTOR; }

- (CGFloat)cornerOffset { return self.cornerRadius / 3.0; }

#pragma mark - Initialization

// Designated Initializer
- (instancetype)initWithCard:(Card *)card andFrame:(CGRect)frame
{
    self = [super initWithCard:card andFrame:frame];
    if (![card isKindOfClass:[PlayingCard class]]) {
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

- (void)pushContextAndRotateUpsideDown
{
    [self pushContext];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

//- (void)drawCardBase {
//    
//}

- (void)drawCardContent {
    // Draw card shape
    [self drawCardBase];
    
    // Draw card contents
    CGRect imageRect = CGRectInset(self.bounds,
                                   self.bounds.size.width * (1.0 - self.faceCardScaleFactor),
                                   self.bounds.size.height * (1.0 - self.faceCardScaleFactor));
    if (self.faceUp) {
        [self drawContentsInRect:imageRect];
    } else {
        [[UIImage imageNamed:@"cardback"] drawInRect:imageRect];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self drawCardContent];
}

#pragma mark - Draw Contents

- (void)drawContentsInRect:(CGRect)contentsRect
{
    PlayingCard *playingCard = (PlayingCard *)self.card;
    UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", [playingCard rankAsString], playingCard.suit]];
    if (faceImage) {
        [faceImage drawInRect:contentsRect];
    } else {
        [self drawPips];
    }
    [self drawCorners];
}

#pragma mark - Draw Corners

- (void)drawCornersWithText:(NSString *)cornerText
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * self.cornerScaleFactor];
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:cornerText attributes:@{ NSFontAttributeName : cornerFont, NSParagraphStyleAttributeName : paragraphStyle }];
    
    CGRect textBounds;
    textBounds.origin = CGPointMake(self.cornerOffset, self.cornerOffset);
    textBounds.size = [attributedText size];
    [attributedText drawInRect:textBounds];
    
    [self pushContextAndRotateUpsideDown];
    [attributedText drawInRect:textBounds];
    [self popContext];
}

- (void)drawCorners
{
    PlayingCard *playingCard = (PlayingCard *)self.card;    
    [self drawCornersWithText:[NSString stringWithFormat:@"%@\n%@", [playingCard rankAsString], playingCard.suit]];
}

#pragma mark - Draw Pips

#define PIP_HOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270

- (void)drawPips
{
    PlayingCard *playingCard = (PlayingCard *)self.card;
    if ((playingCard.rank == 1) || (playingCard.rank == 5) || (playingCard.rank == 9) || (playingCard.rank == 3)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    if ((playingCard.rank == 6) || (playingCard.rank == 7) || (playingCard.rank == 8)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    if ((playingCard.rank == 2) || (playingCard.rank == 3) || (playingCard.rank == 7) || (playingCard.rank == 8) || (playingCard.rank == 10)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:PIP_VOFFSET2_PERCENTAGE
                        mirroredVertically:(playingCard.rank != 7)];
    }
    if ((playingCard.rank == 4) || (playingCard.rank == 5) || (playingCard.rank == 6) || (playingCard.rank == 7) || (playingCard.rank == 8) || (playingCard.rank == 9) || (playingCard.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET3_PERCENTAGE
                        mirroredVertically:YES];
    }
    if ((playingCard.rank == 9) || (playingCard.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET1_PERCENTAGE
                        mirroredVertically:YES];
    }
}

#define PIP_FONT_SCALE_FACTOR 0.012

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                          upsideDown:(BOOL)upsideDown
{
    PlayingCard *playingCard = (PlayingCard *)self.card;
    if (upsideDown) [self pushContextAndRotateUpsideDown];
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    UIFont *pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    pipFont = [pipFont fontWithSize:[pipFont pointSize] * self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
    NSAttributedString *attributedSuit = [[NSAttributedString alloc] initWithString:playingCard.suit attributes:@{ NSFontAttributeName : pipFont }];
    CGSize pipSize = [attributedSuit size];
    CGPoint pipOrigin = CGPointMake(
                                    middle.x-pipSize.width/2.0-hoffset*self.bounds.size.width,
                                    middle.y-pipSize.height/2.0-voffset*self.bounds.size.height
                                    );
    [attributedSuit drawAtPoint:pipOrigin];
    if (hoffset) {
        pipOrigin.x += hoffset*2.0*self.bounds.size.width;
        [attributedSuit drawAtPoint:pipOrigin];
    }
    if (upsideDown) [self popContext];
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                  mirroredVertically:(BOOL)mirroredVertically
{
    [self drawPipsWithHorizontalOffset:hoffset
                        verticalOffset:voffset
                            upsideDown:NO];
    if (mirroredVertically) {
        [self drawPipsWithHorizontalOffset:hoffset
                            verticalOffset:voffset
                                upsideDown:YES];
    }
}

@end
