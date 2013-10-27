
//
//  OpponentData.m
//  robotz
//
//  Created by Jason Elwood on 9/25/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "OpponentData.h"

@implementation OpponentData

@synthesize maxHitPoints, hitPoints, expAwarded, coinsAwarded, attack, bgImage, robotImage, defense, agility, repair, robotAvatar, pointsForOneStar, pointsForThreeStars, pointsForTwoStars, robotLevel, opponentIndexInt;

+ (id)sharedManager {
    static OpponentData *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        constants = [[Constants alloc] init];
    }
    return self;
}

- (void)initializeOpponentData:(NSDictionary *)opponentData
{
    maxHitPoints = [[opponentData objectForKey:constants.HITPOINTS] intValue];
    hitPoints = maxHitPoints;
    expAwarded = [[opponentData objectForKey:constants.EXPERIENCEAWARDED] intValue];
    coinsAwarded = [[opponentData objectForKey:constants.COINSTAWARDED] intValue];
    attack = [[opponentData objectForKey:constants.DAMAGE] intValue];
    defense = [[opponentData objectForKey:constants.DEFENSE] intValue];
    agility = [[opponentData objectForKey:constants.AGILITY] intValue];
    repair = [[opponentData objectForKey:constants.REPAIR] intValue];
    bgImage = [opponentData objectForKey:constants.BACKGROUNDIMAGE];
    robotImage = [opponentData objectForKey:constants.ROBOTIMAGE];
    robotAvatar = [opponentData objectForKey:constants.OPPONENTAVATAR];
    robotLevel = [[opponentData objectForKey:constants.OPPONENTSLEVEL] intValue];
    pointsForOneStar = [[opponentData objectForKey:constants.POINTSFORONESTAR] intValue];
    pointsForTwoStars = [[opponentData objectForKey:constants.POINTSFORTWOSTARS] intValue];
    pointsForThreeStars = [[opponentData objectForKey:constants.POINTSFORTHREESTARS] intValue];
    opponentIndexInt = [[opponentData objectForKey:constants.OPPONENTINDEXINT] intValue];
    
    
    NSLog(@"expAwarded : %d", expAwarded);
    NSLog(@"coinsAwarded : %d", coinsAwarded);
    NSLog(@"bgImage : %@", bgImage);
    NSLog(@"robotImage : %@", robotImage);
    NSLog(@"pointsForOneStar : %d", pointsForOneStar);
}

- (void)opponentTakesDamage:(int)damage
{
    hitPoints -= damage;
}

@end
