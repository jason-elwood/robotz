//
//  PlayerData.m
//  robotz
//
//  Created by Jason Elwood on 9/18/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "PlayerData.h"

@implementation PlayerData

@synthesize someProperty, currentCharacterName = _currentCharacterName;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static PlayerData *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        someProperty = @"Default Property Value";
        _currentCharacterName = @"Default";
        //SaveLoadDataDevice *sldd = [SaveLoadDataDevice sharedManager];
        //sldd.delegate = self;
    }
    return self;
}

- (void)setNewRobotData:(NSMutableDictionary *)robotData
{
    newRobotData = robotData;
}

- (void)setRobotData:(NSMutableDictionary *)robotData
{
    newRobotData = robotData;
}

- (NSMutableDictionary *)getRobotData
{
    return newRobotData;
}

- (void)setCurrentHitPoints:(int)hp
{
    hitPoints = hp;
    //NSLog(@"Setting the players hitpoints to : %d", hp);
}

- (int)getCurrentHitPoints
{
    return hitPoints;
}

- (void)setCurrentCharacterName:(NSString *)currentCharacterName
{
    _currentCharacterName = currentCharacterName;
}

- (NSString *)getCurrentCharacterName
{
    return _currentCharacterName;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
