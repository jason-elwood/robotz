//
//  CharacterClassData.m
//  robotz
//
//  Created by Jason Elwood on 9/18/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "CharacterClassData.h"

@implementation CharacterClassData

- (void)initializeCharClassData
{
    //NSLog(@"Initializing Class Data");
}

- (NSArray *)getImages
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:[UIImage imageNamed:@"char1.png"]];
    [arr addObject:[UIImage imageNamed:@"char2.png"]];
    [arr addObject:[UIImage imageNamed:@"char3.png"]];
    return (NSArray *)arr;
}

- (NSMutableDictionary *)getCharClassData:(int)classIndex
{
    
    //NSLog(@"classIndex = %d", classIndex);
    constants = [[Constants alloc] init];
    
    if (classIndex == 0) {
        charClassType = [NSNumber numberWithInteger:0];
        className = @"Aggressor";
        classDesc = @"Aggressor's have superior attack and average defense but have little repair and agility.";
        robotImageName = @"robot1.png";
        backgroundImageName = @"background1.png";
        damage = [NSNumber numberWithInt:15];
        defense = [NSNumber numberWithInt:10];
        repair = [NSNumber numberWithInt:7];
        agility = [NSNumber numberWithInt:8];
        hitPoints = [NSNumber numberWithInt:200];
        maxHitPoints = [NSNumber numberWithInt:200];
        
    } else if (classIndex == 1) {
        charClassType = [NSNumber numberWithInteger:1];
        className = @"Defender";
        classDesc = @"Defender's have superior defense and average agility but have little attack and repair.";
        robotImageName = @"robot2.png";
        backgroundImageName = @"background1.png";
        damage = [NSNumber numberWithInt:8];
        defense = [NSNumber numberWithInt:15];
        repair = [NSNumber numberWithInt:7];
        agility = [NSNumber numberWithInt:10];
        hitPoints = [NSNumber numberWithInt:200];
        maxHitPoints = [NSNumber numberWithInt:200];
    } else if (classIndex == 2) {
        charClassType = [NSNumber numberWithInteger:3];
        className = @"Ninja";
        classDesc = @"Ninja's have superior agility and average repair but have little attack and defense.";
        robotImageName = @"robot3.png";
        backgroundImageName = @"background1.png";
        damage = [NSNumber numberWithInt:10];
        defense = [NSNumber numberWithInt:8];
        repair = [NSNumber numberWithInt:7];
        agility = [NSNumber numberWithInt:15];
        hitPoints = [NSNumber numberWithInt:200];
        maxHitPoints = [NSNumber numberWithInt:200];
    } else if (classIndex == 3) {
        charClassType = [NSNumber numberWithInteger:2];
        className = @"Mechanic";
        classDesc = @"Mechanic's have superior repair abilities and average attack but have little defense and agility.";
        robotImageName = @"robot4.png";
        backgroundImageName = @"background1.png";
        damage = [NSNumber numberWithInt:10];
        defense = [NSNumber numberWithInt:7];
        repair = [NSNumber numberWithInt:15];
        agility = [NSNumber numberWithInt:5];
        hitPoints = [NSNumber numberWithInt:200];
        maxHitPoints = [NSNumber numberWithInt:200];
    }
    charClassDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                     charClassType, constants.CHARCLASSTYPE,
                     className, constants.CLASSNAME,
                     classDesc, constants.CLASSDESC,
                     robotImageName, constants.ROBOTIMAGE,
                     backgroundImageName, constants.BACKGROUNDIMAGE,
                     damage, constants.DAMAGE,
                     defense, constants.DEFENSE,
                     repair, constants.REPAIR,
                     agility, constants.AGILITY,
                     hitPoints, constants.HITPOINTS,
                     maxHitPoints, constants.MAXHITPOINTS,
                     nil];
    
    return charClassDict;
}

@end
