//
//  CalculateDamage.m
//  robotz
//
//  Created by Jason Elwood on 10/12/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "CalculateDamage.h"

@implementation CalculateDamage

- (id)init
{
    self = [super init];
    if (self) {
        constants = [[Constants alloc] init];
    }
    return self;
}

- (int)calculateAttackWithDamage:(int)damage andDefense:(int)defense andAgility:(int)agility andNumPieces:(int)numPieces opponentBonus:(int)opponentBonus
{
    // Get defense and make any changes here if desired.
    int trueDefense = defense;
    // Get a random number for damage from damage / 2 and damage.
    int trueDamage = [self randomIntBetween:damage / 2 and:damage];
    
    // Subtract defense from damage.
    trueDamage = trueDamage - trueDefense;
    
    // if damage is a negative number then get a random number from baseAttack / 2 and baseAttack.
    if (trueDamage <= 0) {
        trueDamage = [self randomIntBetween:[constants.BASEATTACK intValue] / 2 and:[constants.BASEATTACK intValue]];
    // if damage is greater than 0 then just add baseAttack to damage.
    } else {
        trueDamage = trueDamage + [constants.BASEATTACK intValue];
    }
    
    if (opponentBonus != 0) {
        trueDamage = [self randomIntBetween:damage / 1.4 and:damage] + [constants.BASEATTACK intValue] + numPieces + (opponentBonus / 2) - defense;
    } else {
        trueDamage = [self randomIntBetween:damage / 1.8 and:damage] + [constants.BASEATTACK intValue] + numPieces + (opponentBonus / 2) - defense;
    }
    
    
    // check for a '50' by getting a random number agility times.  If we get a 50 back then the player dodges and takes 0 damage.
    for (int i = 0; i < agility; i++) {
        if ([self randomIntBetween:1 and:100] == 50) {
            trueDamage = 0;
        }
    }
    NSLog(@"damage : %d, defense : %d, agility : %d, numPieces : %d, opponentBonus : %d.", damage, defense, agility, numPieces, opponentBonus);
    
    NSLog(@"trueDamage : %d", trueDamage);
    
    return trueDamage;
}

-(NSInteger)randomIntBetween:(NSInteger)min and:(NSInteger)max {
    return (NSInteger)(min + arc4random_uniform(max + 1 - min));
}

@end
