//
//  OpponentData.h
//  robotz
//
//  Created by Jason Elwood on 9/25/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface OpponentData : NSObject
{
    Constants *constants;
    int maxAttack;
    int maxDefense;
    int maxAgility;
    int maxRepair;
}

@property int maxHitPoints;
@property int hitPoints;
@property int expAwarded;
@property int coinsAwarded;
@property int attack;
@property int defense;
@property int agility;
@property int repair;
@property int robotLevel;
@property int pointsForOneStar;
@property int pointsForTwoStars;
@property int pointsForThreeStars;
@property int opponentIndexInt;
@property NSString *bgImage;
@property NSString *robotImage;
@property NSString *robotAvatar;

+ (id)sharedManager;

- (void)initializeOpponentData:(NSDictionary *)opponentData;
- (void)opponentTakesDamage:(int)damage;

@end
