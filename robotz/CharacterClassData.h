//
//  CharacterClassData.h
//  robotz
//
//  Created by Jason Elwood on 9/18/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface CharacterClassData : NSObject
{
    Constants *constants;
    NSMutableDictionary *charClassDict;
    NSString *className;
    NSString *classDesc;
    NSString *robotImageName;
    NSString *backgroundImageName;
    NSNumber *damage;
    NSNumber *defense;
    NSNumber *repair;
    NSNumber *agility;
    NSNumber *charClassType;
    NSNumber *maxHitPoints;
    NSNumber *hitPoints;
}

- (NSArray *)getImages;
- (NSMutableDictionary *)getCharClassData:(int)classIndex;

@end
