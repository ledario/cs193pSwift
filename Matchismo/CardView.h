//
//  CardView.h
//  Matchismo
//
//  Created by Dario Vincent on 5/20/14.
//  Copyright (c) 2014 cs193p. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView

@property (strong, nonatomic) NSString *contents;
@property (nonatomic) BOOL faceUp;
@property (nonatomic) CGFloat faceCardScaleFactor;

- (void)tapCard:(UITapGestureRecognizer *)gesture;
- (void)pinch:(UIPinchGestureRecognizer *)gesture;

// Override this method to draw specific card for a concrete class
- (void)drawContentsInRect:(CGRect)contentsRect;

- (void)pushContext;
- (void)popContext;

- (CGFloat)cornerScaleFactor;
- (CGFloat)cornerRadius;
- (CGFloat)cornerOffset;

@end
