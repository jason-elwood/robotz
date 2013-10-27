//
//  BattleManager.h
//  robotz
//
//  Created by Jason Elwood on 9/25/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerData.h"
#import "OpponentData.h"
#import "OpponentsDataClass.h"
#import "Constants.h"
#import "CharacterClassData.h"
#import "CharLevelData.h"
#import "CalculateDamage.h"

@protocol BattleManagerProtocolBattleScreen <NSObject>

- (void)playerAttacked;

@end

@protocol BattleManagerProtocolPuzzle <NSObject>

- (void)lockPlayerControls;
- (void)unlockPlayerControls;
- (void)opponentAttack:(int)attackType;

@end

@protocol BattleManagerProtocolHud <NSObject>

- (void)setBoost:(int)boostButtonIndex;
- (void)updatePlayersMove:(int)damage;
- (void)updateScore:(int)score;
- (void)scoreIncrementValue:(int)points;
- (void)updatePlayerTotalHp:(float)total currentHp:(float)current;
- (void)updateOpponentTotalHp:(float)total currentHp:(float)current;
- (void)showDamageToPlayer:(int)playerDamage;
- (void)showDamageToOpponent:(int)opponentDamage;
- (void)resurrectionUsed;

@end

@protocol BattleManagerProtocolOpponent <NSObject>

- (void)opponentDefeated;
- (void)initializeUIWithBgImage:(NSString *)bg andRobotImage:(NSString *)robot;
- (void)updatePlayersMove:(int)damage;
- (void)updateOpponentsMove:(int)type;
- (void)updateScore:(int)score;
- (void)scoreIncrementValue:(int)points;
- (void)updatePlayerTotalHp:(float)total currentHp:(float)current;
- (void)updateOpponentTotalHp:(float)total currentHp:(float)current;

@end

@protocol BattleManagerProtocolOpponentData <NSObject>

- (void)updatePlayersMove:(int)damage;
- (void)updateScore:(int)score;
- (void)scoreIncrementValue:(int)points;
- (void)updatePlayerTotalHp:(float)total currentHp:(float)current;
- (void)updateOpponentTotalHp:(float)total currentHp:(float)current;

@end

@protocol BattleManagerProtocolPlayerData <NSObject>

- (void)updatePlayersMove:(int)damage;
- (void)updateScore:(int)score;
- (void)scoreIncrementValue:(int)points;
- (void)updatePlayerTotalHp:(float)total currentHp:(float)current;
- (void)updateOpponentTotalHp:(float)total currentHp:(float)current;

@end

@protocol BattleManagerProtocolViewController <NSObject>

- (void)battleEndedPlayerWins;
- (void)battleEndedPlayerLost;

@end

@interface BattleManager : NSObject
{
    CalculateDamage *calculateDamage;
    OpponentsDataClass *opponentsDataClass;
    Constants *constants;
    CharacterClassData *characterClassData;
    CharLevelData *charLevelData;
    int score;
    int expAwarded;
    int coinsAwarded;
    int opponentIndex;
    int gamePiecesCleared;
    int multipliers;
    int boostsUsed;
    int numberOfStarsEarned;
    BOOL animationComplete;
    NSTimer *animationTimer;
    
    NSMutableArray *boostsArray;
    
}

+ (id)sharedManager;
@property (weak) id delegateHud;
@property (weak) id delegateOpponent;
@property (weak) id delegatePlayerData;
@property (weak) id delegateOpponentData;
@property (weak) id delegateViewController;
@property (weak) id delegatePuzzle;
@property (weak) id delegateBattleScreen;

@property BOOL isTurnBasedChallenge;
@property BOOL playerWon;
@property BOOL playerHasResurrection;

- (void)initializeBattleManagerState:(int)opponentIndex;
- (void)playerMakesMoveWithPieceType:(int)pieceType numberOfPieces:(int)numPieces;
- (void)opponentMakesMoveWithPieceType:(int)pieceType numberOfPieces:(int)numPieces;
- (void)incrementScore:(int)score;
- (void)animationsEnded;
- (void)opponentAnimationsEnded;
- (int)getScore;
- (void)resetScore;
- (void)resetBoostsUsed;
- (void)resetGamePiecesCleared;
- (int)getExpAwarded;
- (int)getCoinsAwarded;
- (int)getGamePiecesCleared;
- (int)getBoostsUsed;
- (void)provideOpponentBattleModuleUI;
- (void)provideBoostsHudUI;
- (void)levelUpWithLevel:(int)level andRemainingXp:(int)remainingXp;
- (void)setBoosts:(NSMutableArray *)boosts;
- (void)restoreHealth;
- (void)increaseDefense;
- (void)increaseAgility;
- (void)increaseAttack;
- (void)resurrect;
- (void)incrementGamePiecesCleared:(int)pieces;
- (void)enableResurrection;
- (void)unlockPuzzleControl;
- (void)initializeBattleManagerStateMatchWithData:(NSDictionary *)matchData;
- (void)battleEndedPlayerLost;
- (void)playerUsesPurchasedResurrection;
- (void)playerTakesDamage;
- (int)getNumberStarsEarned;

@end
