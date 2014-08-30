//
//  CharLevelData.h
//  robotz
//
//  Created by Jason Elwood on 9/29/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@protocol charLevelDataProtocol <NSObject>

- (void)setPlayersMaxHitPoints:(int)hp;

@end

@interface CharLevelData : NSObject
{
    NSMutableDictionary *levelDataDict;
    
    Constants *constants;
    
    int expToLevel;
    int playersMaxHitPoints;
    int damageBonus;
    int defenseBonus;
    int agilityBonus;
    int repairBonus;
}

@property (weak) id <charLevelDataProtocol>delegate;

- (NSMutableDictionary *)getLevelDataForLevel:(int)level andRobotType:(int)robotType;

@end
