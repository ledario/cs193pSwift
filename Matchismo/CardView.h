//
//  CardView.h
//  Matchismo
//
//  Created by Dario Vincent on 5/20/14.
//  Copyright (c) 2014 cs193p. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView

@property (strong, nonatomic) NSString *content;
@property (nonatomic) BOOL faceUp;
@property (nonatomic) CGFloat faceCardScaleFactor;

- (CGFloat)cornerScaleFactor;
- (CGFloat)cornerRadius;
- (CGFloat)cornerOffset;

- (void)pushContext;
- (void)popContext;

- (void)setUp;

@end
