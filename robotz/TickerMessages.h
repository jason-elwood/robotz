//
//  TickerMessages.h
//  robotz
//
//  Created by Jason Elwood on 10/18/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TickerMessages : NSObject
{
    NSMutableArray *tickerMessages;
}

- (NSString *)getTickerMessage;

@end
