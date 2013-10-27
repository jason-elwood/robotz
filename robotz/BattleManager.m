//
//  BattleManager.m
//  robotz
//
//  Created by Jason Elwood on 9/25/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

// The BattleManager class, as it's name implies, is the liason for all things "battle".  It initializes the state of a battle and thence forth
// takes care of what should happen during the battle, from the player matching game pieces, using boosts and what the opponent UI is doing.
// It utilizes data from opponentData and playerData and it passes some of this information to the calculateDamage class for processing so
// that results can be determined for a given attack.  It then provides this information to various UI elements so that updates can be displayed.
// It achieves this by sending messages to various delegates.

#import "BattleManager.h"

@implementation BattleManager

@synthesize delegateHud, delegateOpponent, delegateOpponentData, delegatePlayerData, delegateViewController, delegatePuzzle, playerWon, isTurnBasedChallenge, playerHasResurrection, delegateBattleScreen;

+ (id)sharedManager {
    static BattleManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

#pragma mark Turn Based Match methods

- (void)initializeBattleManagerStateMatchWithData:(NSDictionary *)matchData
{
    isTurnBasedChallenge = YES;
    playerWon = NO;
    playerHasResurrection = NO;
    numberOfStarsEarned = 0;
}

#pragma mark End turn Based Match methods

#pragma mark Initializing state

- (void)initializeBattleManagerState:(int)opponentIndexInt
{
    isTurnBasedChallenge = NO;
    playerWon = NO;
    playerHasResurrection = NO;
    numberOfStarsEarned = NO;
    
    calculateDamage = [[CalculateDamage alloc] init];
    opponentsDataClass = [[OpponentsDataClass alloc] init];
    constants = [[Constants alloc] init];
    charLevelData = [[CharLevelData alloc] init];
    characterClassData = [[CharacterClassData alloc] init];
    
    opponentIndex = opponentIndexInt;
    OpponentData *od = [OpponentData sharedManager];
    [od initializeOpponentData:[opponentsDataClass getOpponentData:opponentIndex]];
    
    PlayerData *pd = [PlayerData sharedManager];
    [pd setCurrentHitPoints:[[[pd getRobotData] objectForKey:constants.MAXHITPOINTS] intValue]];
    
    animationComplete = NO;
    expAwarded = od.expAwarded;
    coinsAwarded = od.coinsAwarded;
    NSLog(@"Initializing BattleManager State... coinsAwarded : %d, opponentIndex : %d, bgImage : %@", coinsAwarded, opponentIndex, od.bgImage);
    // This is where we set up the initial state of the battle.
}

#pragma mark Responding to UI requests

- (void)provideOpponentBattleModuleUI
{
    OpponentData *od = [OpponentData sharedManager];
    [delegateOpponent initializeUIWithBgImage:od.bgImage andRobotImage:od.robotImage];
}

- (void)provideBoostsHudUI
{
    NSLog(@"provideBoostsHudUI. boostsArray : %@", boostsArray);
    for (int i = 0; i < [boostsArray count]; i++) {
        [self createBoostButton:[[boostsArray objectAtIndex:i] intValue]];
    }
}

#pragma mark Boost methods

- (void)setBoosts:(NSMutableArray *)boosts
{
    NSLog(@"setBoosts : %@", boosts);
    boostsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [boosts count]; i++) {
        if ([[boosts objectAtIndex:i] isEqualToString:@"Restore Health"]) {
            [boostsArray addObject:[NSNumber numberWithInt:0]];
        }
        if ([[boosts objectAtIndex:i] isEqualToString:@"Greater Defense"]) {
            [boostsArray addObject:[NSNumber numberWithInt:1]];
        }
        if ([[boosts objectAtIndex:i] isEqualToString:@"Greater Agility"]) {
            [boostsArray addObject:[NSNumber numberWithInt:2]];
        }
        if ([[boosts objectAtIndex:i] isEqualToString:@"Greater Attack"]) {
            [boostsArray addObject:[NSNumber numberWithInt:3]];
        }
        if ([[boosts objectAtIndex:i] isEqualToString:@"Resurrect Robot"]) {
            [boostsArray addObject:[NSNumber numberWithInt:4]];
        }
    }
}

- (void)createBoostButton:(int)boostIndex
{
    NSLog(@"boostIndex : %d", boostIndex);
    if (boostIndex == 0) {
        [delegateHud setBoost:0];
    } else if (boostIndex == 1) {
        [delegateHud setBoost:1];
    } else if (boostIndex == 2) {
        [delegateHud setBoost:2];
    } else if (boostIndex == 3) {
        [delegateHud setBoost:3];
    } else if (boostIndex == 4) {
        [delegateHud setBoost:4];
    }
}

- (void)restoreHealth
{
    NSLog(@"Restoring Health to 50 percent of original.");
    PlayerData *pd = [PlayerData sharedManager];
    int currentHP = [pd getCurrentHitPoints];
    if (currentHP < 0) {
        currentHP = 0;
    }
    NSLog(@"playerData maxhitpoints : %d", [[SaveLoadDataDevice sharedManager] getPlayersMaxHitPoints]);
    int newHP = [[SaveLoadDataDevice sharedManager] getPlayersMaxHitPoints] / 2 + currentHP;
    //int newHP = [[[pd getRobotData] objectForKey:constants.MAXHITPOINTS] intValue] / 2 + currentHP;
    if (newHP > [[SaveLoadDataDevice sharedManager] getPlayersMaxHitPoints]) {
        newHP = [[SaveLoadDataDevice sharedManager] getPlayersMaxHitPoints];
    }
    [pd setCurrentHitPoints:newHP];
    [self updateHudAfterDelay:animationTimer];
    boostsUsed++;
}

- (void)increaseDefense
{
    NSMutableDictionary *pd = [[PlayerData sharedManager] getRobotData];
    NSLog(@"Increasing defense from : %d.", [[pd objectForKey:constants.DEFENSE] intValue]);
    [pd setObject:[NSNumber numberWithInt:[[pd objectForKey:constants.DEFENSE] intValue] * 1.1] forKey:constants.DEFENSE];
    NSLog(@"Increasing defense to : %d.", [[pd objectForKey:constants.DEFENSE] intValue]);
}

- (void)increaseAgility
{
    NSMutableDictionary *pd = [[PlayerData sharedManager] getRobotData];
    NSLog(@"Increasing agility from : %d.", [[pd objectForKey:constants.AGILITY] intValue]);
    [pd setObject:[NSNumber numberWithInt:[[pd objectForKey:constants.AGILITY] intValue] * 1.1] forKey:constants.AGILITY];
    NSLog(@"Increasing agility to : %d.", [[pd objectForKey:constants.AGILITY] intValue]);
}

- (void)increaseAttack
{
    NSMutableDictionary *pd = [[PlayerData sharedManager] getRobotData];
    NSLog(@"Increasing damage from : %d.", [[pd objectForKey:constants.DAMAGE] intValue]);
    [pd setObject:[NSNumber numberWithInt:[[pd objectForKey:constants.DAMAGE] intValue] * 1.1] forKey:constants.DAMAGE];
    NSLog(@"Increasing damage to : %d.", [[pd objectForKey:constants.DAMAGE] intValue]);
}

- (void)resurrect
{
    NSLog(@"Resurrecting player");
}

- (void)enableResurrection
{
    NSLog(@"Ability to resurrect enabled.");
    playerHasResurrection = YES;
}

#pragma mark Start Player and Opponent battle methods

- (void)playerMakesMoveWithPieceType:(int)pieceType numberOfPieces:(int)numPieces
{
    NSMutableDictionary *pd = [[PlayerData sharedManager] getRobotData];
    OpponentData *od = [OpponentData sharedManager];
    
    [self updatePlayersMoveWithDamage:[calculateDamage calculateAttackWithDamage:[[pd objectForKey:constants.DAMAGE] intValue] andDefense:od.defense andAgility:od.agility andNumPieces:numPieces opponentBonus:0]];
    
    [self lockPuzzleControl];
}

- (void)opponentMakesMoveWithPieceType:(int)pieceType numberOfPieces:(int)numPieces
{
    OpponentData *od = [OpponentData sharedManager];
    NSMutableDictionary *pd = [[PlayerData sharedManager] getRobotData];
    
    [self updateOpponentMoveWithDamage:[calculateDamage calculateAttackWithDamage:[[pd objectForKey:constants.DAMAGE] intValue] andDefense:[[pd objectForKey:constants.DEFENSE] intValue] andAgility:[[pd objectForKey:constants.AGILITY] intValue] andNumPieces:0 opponentBonus:od.opponentIndexInt]];
}

- (void)updatePlayersMoveWithDamage:(int)damage
{
    NSLog(@"players damage = %d", damage);
    animationComplete = NO;
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.5];
    NSTimer *updatePlayersMoveTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(updateOpponentModuleAfterDelay:) userInfo:[NSNumber numberWithInt:damage] repeats:NO];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: updatePlayersMoveTimer forMode: NSDefaultRunLoopMode];
    
    [self lockPuzzleControl];
    [delegateHud showDamageToOpponent:damage];
}

- (void)updateOpponentMoveWithDamage:(int)damage
{
    NSLog(@"opponents damage = %d", damage);
    PlayerData *pd = [PlayerData sharedManager];
    [pd setCurrentHitPoints:[pd getCurrentHitPoints] - damage];
    [delegatePuzzle opponentAttack:damage];
    [delegateOpponent updateOpponentsMove:0];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.5];
    animationTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(updateHudAfterDelay:) userInfo:nil repeats:NO];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: animationTimer forMode: NSDefaultRunLoopMode];
    [delegateHud showDamageToPlayer:damage];
}

- (void)playerTakesDamage
{
    [delegateBattleScreen playerAttacked];
}

    #pragma mark End Player and Opponent move methods

- (void)updateHudAfterDelay:(NSTimer *)timer
{
    PlayerData *pd = [PlayerData sharedManager];
    
    if ([pd getCurrentHitPoints] <= 0) {
        [delegateHud updatePlayerTotalHp:[[[pd getRobotData] objectForKey:constants.MAXHITPOINTS] intValue] currentHp:0];
        [self battleEndedPlayerLost];
        return;
    }
    
    NSLog(@"maxhitpoints : %d. currenthitpoints : %d", [[SaveLoadDataDevice sharedManager] getPlayersMaxHitPoints], [pd getCurrentHitPoints]);
    [delegateHud updatePlayerTotalHp:[[SaveLoadDataDevice sharedManager] getPlayersMaxHitPoints] currentHp:[pd getCurrentHitPoints]];
    
    [animationTimer invalidate];
    animationTimer = nil;
}

- (void)updateOpponentModuleAfterDelay:(NSTimer *)timer
{
    int damage = [[timer userInfo] intValue];
    
    OpponentData *od = [OpponentData sharedManager];
    [od opponentTakesDamage:damage];
    [delegateHud updateOpponentTotalHp:od.maxHitPoints currentHp:od.hitPoints];
    [delegateOpponent updatePlayersMove:damage];
    
    [timer invalidate];
    timer = nil;
}

- (void)lockPuzzleControl
{
    [delegatePuzzle lockPlayerControls];
}

- (void)unlockPuzzleControl
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.5];
    NSTimer *unlockPuzzleTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(unlockPuzzleControlAfterDelay:) userInfo:nil repeats:NO];
    NSRunLoop *unlockPuzzleRunner = [NSRunLoop currentRunLoop];
    [unlockPuzzleRunner addTimer: unlockPuzzleTimer forMode: NSDefaultRunLoopMode];
    
    
}

- (void)unlockPuzzleControlAfterDelay:(NSTimer *)timer
{
    [timer invalidate];
    timer = nil;
    [delegatePuzzle unlockPlayerControls];
}

- (void)incrementScore:(int)points
{
    score += points;
    [delegateHud updateScore:score];
    [delegateHud scoreIncrementValue:points];
}

- (void)incrementGamePiecesCleared:(int)pieces
{
    gamePiecesCleared += pieces;
}

- (void)incrementBoostUsed:(int)boost
{
    boostsUsed += boost;
}

- (void)levelUpWithLevel:(int)level andRemainingXp:(int)remainingXp
{
    NSLog(@"Battle Manager handling the level up.");
    SaveLoadDataDevice *sldd = [SaveLoadDataDevice sharedManager];
    //[sldd playerWinsAgainstOpponentIndex:opponentIndex];
    [sldd levelUpWithRemainingXp:remainingXp charClassData:[characterClassData getCharClassData:level] andLevelData:[charLevelData getLevelDataForLevel:level andRobotType:[sldd getCharacterType]]];
}

- (void)battleEndedPlayerLost
{
    if (playerHasResurrection) {
        NSLog(@"Resurrect player. playerHasResurrection : %d", playerHasResurrection);
        [self restoreHealth];
        playerHasResurrection = NO;
        NSLog(@"Resurrect player. playerHasResurrection : %d", playerHasResurrection);
        // Show a dope resurrection animation...
        [delegateHud resurrectionUsed];
        [self lockPuzzleControl];
        return;
    }
    playerWon = NO;
    [delegateViewController battleEndedPlayerLost];
}

- (void)playerUsesPurchasedResurrection
{
    [self restoreHealth];
    playerHasResurrection = NO;
    [delegateHud resurrectionUsed];
    [self lockPuzzleControl];
}

- (void)battleEndedPlayerWon
{
    NSLog(@"battleEndedPlayerWon!");
    
    // Add matches results to tempDict and send them to sldd.
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    OpponentData *od = [OpponentData sharedManager];
    [tempDict setObject:[NSNumber numberWithInt:od.opponentIndexInt] forKey:constants.OPPONENTINDEXINT];     // set the opponents index
    [tempDict setObject:[NSNumber numberWithInt:score] forKey:constants.SCORE];                              // set the score
    [tempDict setObject:[NSNumber numberWithInt:od.robotLevel] forKey:constants.OPPONENTSLEVEL];             // set opponents level
    [tempDict setObject:od.robotAvatar forKey:constants.OPPONENTAVATAR];                                     // set opponents avatar
    [tempDict setObject:[NSNumber numberWithInt:[self awardStars]] forKey:constants.NUMBEROFSTARSEARNED];    // set number of stars earned
    // ******************************************************
    
    playerWon = YES;
    SaveLoadDataDevice *sldd = [SaveLoadDataDevice sharedManager];
    [sldd playerWinsAgainstOpponentDetails:tempDict];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.5];
    NSTimer *battleOverTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(informViewControllerOfResult:) userInfo:nil repeats:NO];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: battleOverTimer forMode: NSDefaultRunLoopMode];
    [delegateOpponent opponentDefeated];
    
    tempDict = nil;
}

- (int)awardStars
{
    OpponentData *od = [OpponentData sharedManager];
    if (score >= od.pointsForOneStar) {
        numberOfStarsEarned++;
    }
    if (score >= od.pointsForTwoStars) {
        numberOfStarsEarned++;
    }
    if (score >= od.pointsForThreeStars) {
        numberOfStarsEarned++;
    }
    return numberOfStarsEarned;
}

- (int)getNumberStarsEarned
{
    return numberOfStarsEarned;
}

- (void)informViewControllerOfResult:(NSTimer *)timer
{
    [delegateViewController battleEndedPlayerWins];
    [timer invalidate];
    timer = nil;
}

- (void)animationsEnded
{
    [self battleEndedPlayerWon];
}

- (void)opponentAnimationsEnded
{
    [self unlockPuzzleControl];
}

- (int)getScore
{
    return score;
}

- (int)getExpAwarded
{
    return expAwarded;
}

- (int)getCoinsAwarded
{
    return coinsAwarded;
}

- (int)getGamePiecesCleared
{
    return gamePiecesCleared;
}

- (int)getBoostsUsed
{
    return boostsUsed;
}

- (void)resetScore
{
    score = 0;
}

- (void)resetBoostsUsed
{
    boostsUsed = 0;
}

- (void)resetGamePiecesCleared
{
    gamePiecesCleared = 0;
}

@end
