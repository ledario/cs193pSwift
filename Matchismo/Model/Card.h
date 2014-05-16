//
//  Card.h
//  Matchismo
//
//  Created by Dario Vincent on 11/28/13.
//  Copyright (c) 2013 cs193p. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;

- (int)matchCount;
- (int)match:(NSArray *)otherCards;

@end
