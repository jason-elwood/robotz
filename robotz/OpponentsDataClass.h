//
//  OpponentsDataClass.h
//  robotz
//
//  Created by Jason Elwood on 9/23/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface OpponentsDataClass : NSObject
{
    Constants *constants;
    NSMutableDictionary *opponentData;
    NSMutableArray *array;
    
    NSNumber *hitPoints;
    NSNumber *damage;
    NSNumber *defense;
    NSNumber *repair;
    NSNumber *agility;
    NSNumber *expAwarded;
    NSNumber *coinsAwarded;
    NSNumber *opponentIndexInt;
    NSString *className;
    NSString *classDesc;
    NSString *robotImageName;
    NSString *backgroundImageName;
    NSString *robotAvatar;
    NSNumber *robotsLevel;
    NSNumber *pointsFor1Star;
    NSNumber *pointsFor2Stars;
    NSNumber *pointsFor3Stars;
}

- (NSMutableDictionary *)getOpponentData:(int)opponentIndex;

@end
