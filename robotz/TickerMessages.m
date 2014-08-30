//
//  TickerMessages.m
//  robotz
//
//  Created by Jason Elwood on 10/18/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "TickerMessages.h"

@implementation TickerMessages

- (id)init
{
    self = [super init];
    if (self) {
        tickerMessages = [[NSMutableArray alloc] initWithObjects:
                          @"Use 'Boosts' to improve your chance of winning tough battles.",
                          @"The Agility boost increases your chance to dodge by 10%.",
                          @"You can delete your character and start over from the Settings menu.",
                          @"The more match combinations you get, the more damage you do to opponents.",
                          @"If you need help, go to the Help screen from the Settings menu.",
                          @"In future updates of Robotz you will be able to challenge your friends!",
                          @"The higher your Agility, the better chance you have at dodging attacks.",
                          @"The Defense boost reduces the amount of damage you take by 10%.",
                          @"The Health boost returns 50% of your max health to you.",
                          @"More 'Boosts' unlock as you level up.",
                          @"More coins are available from the Shop menu.",
                          @"You can turn sounds and sound fx off/on from the Settings menu.",
                          @"Use the Health boost when you are below 50%.",
                          @"Resurrections bring your robot back to life with 50% health.",
                          @"Sharing Robotz on your Facebook page from the shop menu earns you free coins.",
                          nil];
    }
    return self;
}

- (NSString *)getTickerMessage
{
    return [self randomMessage:[self randomIntBetween:0 and:[tickerMessages count] - 1]];
}

- (NSString *)randomMessage:(int)messageIndex
{
    return [tickerMessages objectAtIndex:messageIndex];
}

-(NSInteger)randomIntBetween:(NSInteger)min and:(NSInteger)max {
    return (NSInteger)(min + arc4random_uniform(max + 1 - min));
}

@end
