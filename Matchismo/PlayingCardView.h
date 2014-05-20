//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Dario Vincent on 5/19/14.
//  Copyright (c) 2014 cs193p. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
