//
//  SaveLoadDataDevice.h
//  robotz
//
//  Created by Jason Elwood on 9/23/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "CharLevelData.h"

@protocol SaveLoadDataDeviceProtocol <NSObject>

- (void)updateCoins:(int)coins;

@end

@protocol SaveLoadDataDeviceProtocolViewController <NSObject>

- (void)unlockPlanet:(int)planetIndex;

@end

@interface SaveLoadDataDevice : NSObject <charLevelDataProtocol>
{
    NSUserDefaults *prefs;
    CharLevelData *charLevelData;
    Constants *constants;
    NSMutableDictionary *charClassDict;
    NSMutableArray *planetArray;
    
    int currentLevel;
}

@property (nonatomic, retain) NSString *charName;
@property BOOL thereIsSavedData;
@property (weak) id <SaveLoadDataDeviceProtocol>delegate;
@property (weak) id <SaveLoadDataDeviceProtocolViewController>delegateVC;

+ (id)sharedManager;

- (int)getPuzzleStartIndexWithPuzzlePiecesLength:(int)numPieces;
- (void)setCharacterType:(int)charType;
- (int)getCharacterType;
- (void)setClassName:(NSString *)className;
- (void)setClassDesc:(NSString *)classDesc;
- (void)setRobotImage:(NSString *)robotImage;
- (void)setBackgroundImage:(NSString *)backgroundImage;
- (void)setDamage:(int)damage;
- (void)setDefense:(int)defense;
- (void)setRepair:(int)repair;
- (void)setAgility:(int)agility;
- (NSMutableDictionary *)loadPlayerData;
- (NSMutableDictionary *)getCharData;
- (void)setCurrentExperience:(int)experience;
- (void)setExperienceToLevel:(int)experience;
- (void)setCharactersLevel:(int)level;
- (void)levelUpWithRemainingXp:(int)remainingXp charClassData:(NSMutableDictionary *)charClassData andLevelData:(NSMutableDictionary *)levelData;
- (void)playerWinsAgainstOpponentIndex:(int)opponentIndex;
- (NSArray *)getOpponentHistoryDetails;
- (void)playerWinsAgainstOpponentDetails:(NSMutableDictionary *)opponentDetails;
- (void)resetCharacter;
- (void)setPlayersCoins:(int)coins;
- (void)setPlayersMaxHitPoints:(int)hp;
- (void)setMusicOn:(BOOL)musicOn;
- (void)setSoundFxOn:(BOOL)soundFxOn;
- (BOOL)getMusicOn;
- (BOOL)getSoundFxOn;
- (BOOL)hideRateMyAppForever:(NSNumber *)hide;
- (int)getNumberOfLogins;
- (void)incrementNumberOfLogins;
- (void)setCurrentDate:(NSMutableDictionary *)date;
- (NSMutableDictionary *)getSavedDate;
- (void)setCurrentPlanet:(NSString*)planet;
- (NSString *)getCurrentPlanet;
- (void)setPlayersName:(NSString *)name;
- (NSString *)getPlayersName;
- (void)addResurrection;
- (int)getResurrections;
- (void)useResurrection;
- (int)getPlayersMaxHitPoints;
- (int)getPlayersCoins;

@end
