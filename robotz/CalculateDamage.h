//
//  CalculateDamage.h
//  robotz
//
//  Created by Jason Elwood on 10/12/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface CalculateDamage : NSObject
{
    Constants *constants;
}

- (int)calculateAttackWithDamage:(int)damage andDefense:(int)defense andAgility:(int)agility andNumPieces:(int)numPieces opponentBonus:(int)opponentBonus;

@end
