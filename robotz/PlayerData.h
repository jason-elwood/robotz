//
//  PlayerData.h
//  robotz
//
//  Created by Jason Elwood on 9/18/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SaveLoadDataDevice.h"

@interface PlayerData : NSObject 
{
    NSString *someProperty;
    NSMutableDictionary *newRobotData;
    
    int hitPoints;
}

@property (nonatomic, retain) NSString *someProperty;
@property (nonatomic, retain) NSString *currentCharacterName;

+ (id)sharedManager;
- (void)setCurrentCharacterName:(NSString *)currentCharacterName;
- (NSString *)getCurrentCharacterName;
- (void)setNewRobotData:(NSDictionary *)robotData;
- (void)setRobotData:(NSMutableDictionary *)robotData;
- (NSMutableDictionary *)getRobotData;
- (void)setCurrentHitPoints:(int)hp;
- (int)getCurrentHitPoints;

@end
