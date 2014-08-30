//
//  BoostsData.m
//  robotz
//
//  Created by Jason Elwood on 9/30/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "BoostsData.h"

@implementation BoostsData

- (id)init
{
    self = [super init];
    if (self) {
        constants = [[Constants alloc] init];
    }
    return self;
}

- (NSMutableDictionary *)getBoostsDataForBoostIndex:(int)boostIndex
{
    if (boostIndex == 0) {
        boostCost = 3000;
        boostImageSmall = @"restoreHealthBoostSmall.png";
        boostImageLarge = @"restoreHealthBoostLarge.png";
        boostType = constants.BOOSTHEALTHREWARD;
        
    } else if (boostIndex == 1) {
        boostCost = 3000;
        boostImageSmall = @"greaterDefenseBoostSmall.png";
        boostImageLarge = @"greaterDefenseBoostLarge.png";
        boostType = constants.BOOSTDEFENSEREWARD;
        
    } else if (boostIndex == 2) {
        boostCost = 5000;
        boostImageSmall = @"greaterRepairBoostSmall.png";
        boostImageLarge = @"greaterRepairBoostLarge.png";
        boostType = constants.BOOSTREPAIRREWARD;
        
    } else if (boostIndex == 3) {
        boostCost = 5000;
        boostImageSmall = @"greaterAttackBoostSmall.png";
        boostImageLarge = @"greaterAttackBoostLarge.png";
        boostType = constants.BOOSTATTACKREWARD;
        
    } else if (boostIndex == 4) {
        boostCost = 7000;
        boostImageSmall = @"resurrectionBoostSmall.png";
        boostImageLarge = @"resurrectionBoostLarge.png";
        boostType = constants.BOOSTRESURRECTIONREWARD;
        
    }
    
    boostsDataDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                      [NSNumber numberWithInt:boostCost], constants.BOOSTCOST,
                      boostImageSmall, constants.BOOSTIMAGESMALL,
                      boostImageLarge, constants.BOOSTIMAGELARGE,
                      boostType, constants.BOOSTTYPE,
                      nil];
    
    return boostsDataDict;
}


@end
