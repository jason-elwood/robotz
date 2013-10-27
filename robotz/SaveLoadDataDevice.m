//
//  SaveLoadDataDevice.m
//  robotz
//
//  Created by Jason Elwood on 9/23/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "SaveLoadDataDevice.h"

@implementation SaveLoadDataDevice

@synthesize charName, thereIsSavedData, delegate, delegateVC;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static SaveLoadDataDevice *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        constants = [[Constants alloc] init];
        charLevelData = [[CharLevelData alloc] init];
        charLevelData.delegate = self;
        prefs = [NSUserDefaults standardUserDefaults];
        thereIsSavedData = NO;
        //[self resetCharacter]; // debug | debug | debug | debug | debug | debug | debug | debug | debug | debug | debug | debug | debug
        [self isThereSavedData];
    }
    return self;
}

- (void)isThereSavedData
{
    if ([prefs objectForKey:constants.PLAYERSNAME] == NULL || [[prefs objectForKey:constants.PLAYERSNAME] isEqualToString:@""]) {
        thereIsSavedData = NO;
        [self initializeOpponentDetails];
        [self setCurrentPlanet:constants.PLANETMERCURY];
    } else {
        thereIsSavedData = YES;
        [self loadPlayerData];
    }
}

- (NSMutableDictionary *)loadPlayerData
{
    int charclasstype = [[prefs objectForKey:constants.CHARCLASSTYPE] intValue];
    int chardamage = [[prefs objectForKey:constants.DAMAGE] intValue];
    int chardefense = [[prefs objectForKey:constants.DEFENSE] intValue];
    int charrepair = [[prefs objectForKey:constants.REPAIR] intValue];
    int charagility = [[prefs objectForKey:constants.AGILITY] intValue];
    int charexperience = [[prefs objectForKey:constants.CURRENTEXPERIENCE] intValue];
    int charexptolevel = [[prefs objectForKey:constants.EXPERIENCETOLEVEL] intValue];
    int playersLevel = [[prefs objectForKey:constants.PLAYERSLEVEL] intValue];
    int playersCoins = [[prefs objectForKey:constants.TOTALCOINS] intValue];
    int playersMaxHP = [[prefs objectForKey:constants.MAXHITPOINTS] intValue];
    int opponentIndex = [[prefs objectForKey:constants.OPPONENTINDEX] intValue];
    charClassDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                     [NSNumber numberWithInt:charclasstype], constants.CHARCLASSTYPE,
                     [prefs objectForKey:constants.CLASSNAME], constants.CLASSNAME,
                     [prefs objectForKey:constants.CLASSDESC], constants.CLASSDESC,
                     [prefs objectForKey:constants.ROBOTIMAGE], constants.ROBOTIMAGE,
                     [prefs objectForKey:constants.BACKGROUNDIMAGE], constants.BACKGROUNDIMAGE,
                     [NSNumber numberWithInt:chardamage], constants.DAMAGE,
                     [NSNumber numberWithInt:chardefense], constants.DEFENSE,
                     [NSNumber numberWithInt:charrepair], constants.REPAIR,
                     [NSNumber numberWithInt:charagility], constants.AGILITY,
                     [NSNumber numberWithInt:charexperience], constants.CURRENTEXPERIENCE,
                     [NSNumber numberWithInt:charexptolevel], constants.EXPERIENCETOLEVEL,
                     [NSNumber numberWithInt:playersLevel], constants.PLAYERSLEVEL,
                     [NSNumber numberWithInt:playersCoins], constants.TOTALCOINS,
                     [NSNumber numberWithInt:playersMaxHP], constants.MAXHITPOINTS,
                     [NSNumber numberWithInt:opponentIndex], constants.OPPONENTINDEX,
                     nil];
    return charClassDict;
}

- (NSMutableDictionary *)getCharData
{
    return [self loadPlayerData];
}

- (int)getPuzzleStartIndexWithPuzzlePiecesLength:(int)numPieces
{
    if ([prefs objectForKey:constants.PUZZLESTARTINDEX] == NULL || [[prefs objectForKey:constants.PUZZLESTARTINDEX] intValue] >= numPieces) {
        [prefs setObject:[NSNumber numberWithInt:0] forKey:constants.PUZZLESTARTINDEX];
    } else {
        int newInt = [[prefs objectForKey:constants.PUZZLESTARTINDEX] intValue] + 1;
        NSNumber *tempNumber = [NSNumber numberWithInt:newInt];
        [prefs setObject:tempNumber forKey:constants.PUZZLESTARTINDEX];
    }
    NSLog(@"getPuzzleStartIndeWithPuzzlePiecesLength = %d", [[prefs objectForKey:constants.PUZZLESTARTINDEX] intValue]);
    return [[prefs objectForKey:constants.PUZZLESTARTINDEX] intValue];
}

- (void)setCharacterType:(int)charType
{
    [prefs setObject:[NSNumber numberWithInteger:charType] forKey:constants.CHARCLASSTYPE];
}

- (void)setClassName:(NSString *)className
{
    [prefs setObject:className forKey:constants.CLASSNAME];
}

- (void)setClassDesc:(NSString *)classDesc
{
    [prefs setObject:classDesc forKey:constants.CLASSDESC];
}

- (void)setRobotImage:(NSString *)robotImage
{
    [prefs setObject:robotImage forKey:constants.ROBOTIMAGE];
}

- (void)setBackgroundImage:(NSString *)backgroundImage
{
    [prefs setObject:backgroundImage forKey:constants.BACKGROUNDIMAGE];
}

- (void)setDamage:(int)damage
{
    int newDamage = [[prefs objectForKey:constants.DAMAGE] intValue] + damage;
    [prefs setObject:[NSNumber numberWithInteger:newDamage] forKey:constants.DAMAGE];
    NSLog(@"setting damage to : %d", damage);
}

- (void)setDefense:(int)defense
{
    int newDefense = [[prefs objectForKey:constants.DEFENSE] intValue] + defense;
    [prefs setObject:[NSNumber numberWithInteger:newDefense] forKey:constants.DEFENSE];
    NSLog(@"setting damage to : %d", defense);
}

- (void)setRepair:(int)repair
{
    int newRepair = [[prefs objectForKey:constants.REPAIR] intValue] + repair;
    [prefs setObject:[NSNumber numberWithInteger:newRepair] forKey:constants.REPAIR];
    NSLog(@"setting damage to : %d", repair);
}

- (void)setAgility:(int)agility
{
    int newAgility = [[prefs objectForKey:constants.AGILITY] intValue] + agility;
    [prefs setObject:[NSNumber numberWithInteger:newAgility] forKey:constants.AGILITY];
    NSLog(@"setting damage to : %d", agility);
}

- (void)setCurrentExperience:(int)experience
{
    [prefs setObject:[NSNumber numberWithInt:experience] forKey:constants.CURRENTEXPERIENCE];
}

- (void)setExperienceToLevel:(int)experience
{
    [prefs setObject:[NSNumber numberWithInt:experience] forKey:constants.EXPERIENCETOLEVEL];
}

-(void)setCharactersLevel:(int)level
{
    [prefs setObject:[NSNumber numberWithInt:level] forKey:constants.PLAYERSLEVEL];
}

- (void)setPlayersCoins:(int)coins
{
    if (coins == 10000 && [[prefs objectForKey:constants.TOTALCOINS] intValue] > 10000) {
        return;
    }
    [prefs setObject:[NSNumber numberWithInt:coins] forKey:constants.TOTALCOINS];
    [delegate updateCoins:[[prefs objectForKey:constants.TOTALCOINS] intValue]];
}

- (int)getPlayersCoins
{
    return [[prefs objectForKey:constants.TOTALCOINS] intValue];
}

- (void)setPlayersMaxHitPoints:(int)hp
{
    NSLog(@"PlayersMaxHitPoints set to : %d", hp);
    [prefs setObject:[NSNumber numberWithInt:hp] forKey:constants.MAXHITPOINTS];
}

- (int)getPlayersMaxHitPoints
{
    return [[prefs objectForKey:constants.MAXHITPOINTS] intValue];
}

// This array stores the entire history of opponents for the current player
- (void)initializeOpponentDetails
{
    NSMutableArray *opponentDetailsArray = [[NSMutableArray alloc] initWithCapacity:[constants.NUMBEROFOPPONENTS intValue]];
    for (int i = 0; i < [constants.NUMBEROFOPPONENTS intValue]; i++) {
        [opponentDetailsArray addObject:[[NSMutableDictionary alloc] init]];
    }
    [prefs setObject:opponentDetailsArray forKey:constants.OPPONENTDETAILS];
}

- (void)playerWinsAgainstOpponentDetails:(NSMutableDictionary *)opponentDetails
{
    NSMutableArray *storedArray = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:constants.OPPONENTDETAILS]];// Get the stored opponentDetails array
    int opponentIndexInt = [[opponentDetails objectForKey:constants.OPPONENTINDEXINT] intValue];
    
    if ([[storedArray objectAtIndex:opponentIndexInt] count] != 0) {// We either beat this opponent sometime prior
        NSMutableDictionary *savedOpponent = [storedArray objectAtIndex:[constants.OPPONENTINDEXINT intValue] + 1];// Get the saved data for this opponent
        
        if ([[savedOpponent objectForKey:constants.SCORE] intValue] < [[opponentDetails objectForKey:constants.SCORE] intValue]) {// Is the new score higher
            [storedArray replaceObjectAtIndex:[[opponentDetails objectForKey:constants.OPPONENTINDEXINT] intValue] withObject:opponentDetails];// then replace
        } else {
            return;// otherwise do nothing
        }
        
    } else {// or there was no prior data for this robot saved
        [storedArray replaceObjectAtIndex:[[opponentDetails objectForKey:constants.OPPONENTINDEXINT] intValue] withObject:opponentDetails];// so add it
        
        // If the opponent index excedes the num robots for a given planet, we increase the current planet by 1
        planetArray = [[NSMutableArray alloc] initWithObjects:
                       constants.PLANETMERCURY,
                       constants.PLANETVENUS,
                       constants.PLANETEARTH,
                       constants.PLANETMARS,
                       constants.PLANETJUPITER,
                       constants.PLANETSATURN,
                       constants.PLANETURANUS,
                       constants.PLANETNEPTUNE,
                       constants.PLANETPLUTO,
                       nil];
        
        int oII = [[opponentDetails objectForKey:constants.OPPONENTINDEXINT] intValue];
        if (oII == 2 || oII == 6 || oII == 14 || oII == 24 || oII == 40 || oII == 60 || oII == 100 || oII == 164) {
            NSString *currPlanet = [self getCurrentPlanet];
            int currPlanetIndex = [planetArray indexOfObject:currPlanet];
            [self setCurrentPlanet:[planetArray objectAtIndex:currPlanetIndex + 1]];
            [delegateVC unlockPlanet:currPlanetIndex + 1];
        }
        
        planetArray = nil;
        
    }
    
    [prefs setObject:storedArray forKey:constants.OPPONENTDETAILS];
}

- (NSArray *)getOpponentHistoryDetails
{
    return [prefs objectForKey:constants.OPPONENTDETAILS];
}

- (void)playerWinsAgainstOpponentIndex:(int)opponentIndex
{
    // remove this asap
}

- (void)levelUpWithRemainingXp:(int)remainingXp charClassData:(NSMutableDictionary *)charClassData andLevelData:(NSMutableDictionary *)levelData
{
    int level = [[prefs objectForKey:constants.PLAYERSLEVEL] intValue];
    int newLevel = level + 1;
    NSMutableDictionary *cld = [charLevelData getLevelDataForLevel:newLevel andRobotType:[[SaveLoadDataDevice sharedManager] getCharacterType]];
    [self setCharactersLevel:newLevel];
    [self setCurrentExperience:remainingXp];
    [self setExperienceToLevel:[[cld objectForKey:constants.EXPERIENCETOLEVEL] intValue]];
    [self setPlayersMaxHitPoints:[[cld objectForKey:constants.MAXHITPOINTS] intValue]];
    [self setDamage:[[cld objectForKey:constants.DAMAGE] intValue]];
    [self setDefense:[[cld objectForKey:constants.DEFENSE] intValue]];
    [self setAgility:[[cld objectForKey:constants.AGILITY] intValue]];
    [self setRepair:[[cld objectForKey:constants.REPAIR] intValue]];
}

- (void)setCurrentPlanet:(NSString*)planet
{
    [prefs setValue:planet forKey:constants.CURRENTPLANET];
    NSLog(@"Current Planet = %@", planet);
}

- (void)addResurrection
{
    if ([[prefs objectForKey:constants.RESURRECTIONS] intValue] < 1) {
        [prefs setObject:[NSNumber numberWithInteger:0] forKey:constants.RESURRECTIONS];
    }
    [prefs setObject:[NSNumber numberWithInt:[[prefs objectForKey:constants.RESURRECTIONS] intValue] + 1] forKey:constants.RESURRECTIONS];
    NSLog(@"Adding resurrection to device.  Resurrections : %d", [[prefs objectForKey:constants.RESURRECTIONS] intValue]);
}

- (int)getResurrections
{
    return [[prefs objectForKey:constants.RESURRECTIONS] intValue];
}

- (void)useResurrection
{
    if ([[prefs objectForKey:constants.RESURRECTIONS] intValue] < 1) {
        return;
    }
    [prefs setObject:[NSNumber numberWithInt:[[prefs objectForKey:constants.RESURRECTIONS] intValue] - 1] forKey:constants.RESURRECTIONS];
}

- (NSString *)getCurrentPlanet
{
    return [prefs objectForKey:constants.CURRENTPLANET];
}

- (void)setPlayersName:(NSString *)name
{
    [prefs setObject:name forKey:constants.PLAYERSNAME];
}

- (NSString *)getPlayersName
{
    return [prefs objectForKey:constants.PLAYERSNAME];
}

- (void)resetDamage
{
    NSLog(@"reset damage");
    [prefs setObject:[NSNumber numberWithInt:0] forKey:constants.DAMAGE];
}

- (void)resetDefense
{
    [prefs setObject:[NSNumber numberWithInt:0] forKey:constants.DEFENSE];
}

- (void)resetAgility
{
    [prefs setObject:[NSNumber numberWithInt:0] forKey:constants.AGILITY];
}

- (void)resetRepair
{
    [prefs setObject:[NSNumber numberWithInt:0] forKey:constants.REPAIR];
}

- (void)resetCharacter
{
    NSLog(@"reset character");
    [self initializeOpponentDetails];
    [self hideRateMyAppForever:0];
    [self setCharactersLevel:1];
    [self setExperienceToLevel:0];
    [self setCurrentExperience:0];
    [self resetDamage];
    [self resetDefense];
    [self resetAgility];
    [self resetRepair];
    [self setCurrentDate:[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                          [NSNumber numberWithInt:0], constants.YEAR, [NSNumber numberWithInt:0], constants.MONTH, [NSNumber numberWithInt:0], constants.DAY, nil]];
    //[self setPlayersCoins:10000];  // Comment this out when go live.
    [self setCurrentPlanet:constants.PLANETMERCURY];
    [self setPlayersName:@""];
    thereIsSavedData = NO;
}

- (int)getCharacterType
{
    if ([prefs objectForKey:constants.CHARCLASSTYPE] == NULL) {
        return -1;
    } else {
        return [[prefs objectForKey:constants.CHARCLASSTYPE] intValue];
    }
}

- (BOOL)getMusicOn
{
    return [[prefs objectForKey:constants.MUSICISON] intValue];
    NSLog(@"getMusicOn : %d", [[prefs objectForKey:constants.MUSICISON] intValue]);
}

- (BOOL)getSoundFxOn
{
    return [[prefs objectForKey:constants.SOUNDFXISON] intValue];
}

- (void)setMusicOn:(BOOL)musicOn
{
    NSNumber *isOn = [NSNumber numberWithInt:musicOn];
    [prefs setObject:isOn forKey:constants.MUSICISON];
    NSLog(@"setMusicOn prefs : %d", [[prefs objectForKey:constants.MUSICISON] intValue]);
}

- (void)setSoundFxOn:(BOOL)soundFxOn
{
    NSNumber *isOn = [NSNumber numberWithInt:soundFxOn];
    [prefs setObject:isOn forKey:constants.SOUNDFXISON];
}

- (BOOL)hideRateMyAppForever:(NSNumber *)hide
{
    if ([hide intValue] != -1) {
        [prefs setObject:hide forKey:constants.HIDERATEMYAPPFOREVER];
    }
    
    if ([[prefs objectForKey:constants.HIDERATEMYAPPFOREVER] intValue] == 0) {
        return NO;
    }
    return YES;
}

- (int)getNumberOfLogins
{
    NSLog(@"number of logins : %d", [[prefs objectForKey:constants.NUMBEROFLOGINS] intValue]);
    if ([[prefs objectForKey:constants.NUMBEROFLOGINS] intValue] > 1000) {
        [prefs setObject:[NSNumber numberWithInteger:1] forKey:constants.NUMBEROFLOGINS];
    }
    return [[prefs objectForKey:constants.NUMBEROFLOGINS] intValue];
}

- (void)incrementNumberOfLogins
{
    if (![prefs objectForKey:constants.NUMBEROFLOGINS]) {
        [prefs setObject:[NSNumber numberWithInt:1] forKey:constants.NUMBEROFLOGINS];
        return;
    }
    int newLoginNumber = [[prefs objectForKey:constants.NUMBEROFLOGINS] intValue] +1;
    [prefs setObject:[NSNumber numberWithInt:newLoginNumber] forKey:constants.NUMBEROFLOGINS];
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

- (void)setCurrentDate:(NSMutableDictionary *)date
{
    [prefs setObject:[date objectForKey:constants.YEAR] forKey:constants.YEAR];
    [prefs setObject:[date objectForKey:constants.MONTH] forKey:constants.MONTH];
    [prefs setObject:[date objectForKey:constants.DAY] forKey:constants.DAY];
}

- (NSMutableDictionary *)getSavedDate
{
    NSMutableDictionary *dateDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     [prefs objectForKey:constants.YEAR], constants.YEAR,
                                     [prefs objectForKey:constants.MONTH], constants.MONTH,
                                     [prefs objectForKey:constants.DAY], constants.DAY,
                                     nil];
    return dateDict;
}

@end
