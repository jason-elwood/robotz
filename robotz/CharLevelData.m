//
//  CharLevelData.m
//  robotz
//
//  Created by Jason Elwood on 9/29/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "CharLevelData.h"

@implementation CharLevelData
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        constants = [[Constants alloc] init];
        levelDataDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)initializeData:(int)levelIndex andRobotType:(int)robotType
{
    NSLog(@"initializing data for robot type : %d of level : %d.", robotType, levelIndex);
    if (levelIndex == 1) {
        expToLevel = 100;
        playersMaxHitPoints = 100;
    } else if (levelIndex == 2) {
        expToLevel = 200;
        playersMaxHitPoints = 150;
    } else if (levelIndex == 3) {
        expToLevel = 400;
        playersMaxHitPoints = 200;
    } else if (levelIndex == 4) {
        expToLevel = 800;
        playersMaxHitPoints = 250;
    } else if (levelIndex == 5) {
        expToLevel = 1600;
        playersMaxHitPoints = 300;
    } else if (levelIndex == 6) {
        expToLevel = 3200;
        playersMaxHitPoints = 350;
    } else if (levelIndex == 7) {
        expToLevel = 6400;
        playersMaxHitPoints = 400;
    } else if (levelIndex == 8) {
        expToLevel = 12800;
        playersMaxHitPoints = 450;
    } else if (levelIndex == 9) {
        expToLevel = 25600;
        playersMaxHitPoints = 500;
    } else if (levelIndex == 10) {
        expToLevel = 100000;
        playersMaxHitPoints = 550;
    }
    
    [delegate setPlayersMaxHitPoints:playersMaxHitPoints];
    
    if (robotType == 0) {
        damageBonus = 5;
        defenseBonus = 4;
        agilityBonus = 1;
        repairBonus = 2;
    } else if (robotType == 1) {
        damageBonus = 2;
        defenseBonus = 5;
        agilityBonus = 4;
        repairBonus = 1;
    }else if (robotType == 2) {
        damageBonus = 2;
        defenseBonus = 1;
        agilityBonus = 5;
        repairBonus = 4;
    }else if (robotType == 3) {
        damageBonus = 2;
        defenseBonus = 1;
        agilityBonus = 5;
        repairBonus = 4;
    }
}

- (NSMutableDictionary *)getLevelDataForLevel:(int)level andRobotType:(int)robotType
{
    [self initializeData:level andRobotType:robotType];
    
    levelDataDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                     [NSNumber numberWithInt:expToLevel], constants.EXPERIENCETOLEVEL,
                     [NSNumber numberWithInt:playersMaxHitPoints], constants.MAXHITPOINTS,
                     [NSNumber numberWithInt:damageBonus], constants.DAMAGE,
                     [NSNumber numberWithInt:defenseBonus], constants.DEFENSE,
                     [NSNumber numberWithInt:agilityBonus], constants.AGILITY,
                     [NSNumber numberWithInt:repairBonus], constants.REPAIR,
                    nil];
    
    return levelDataDict;
}

@end
