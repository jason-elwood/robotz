//
//  BattleResultsScreen.h
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceTypes.h"
#import "BattleManager.h"
#import "SaveLoadDataDevice.h"
#import "Constants.h"
#import "UIView+EasingFunctions.h"
#import "easing.h"

@protocol BattleResultsScreenProtocol <NSObject>

- (void)closeBattleResultsScreen;
- (void)showBoostUnlockedScreen:(int)level;

@end

@interface BattleResultsScreen : UIView
{
    DeviceTypes *deviceTypes;
    Constants *constants;
    
    UIImageView *goldStarleft;
    UIImageView *goldStarMiddle;
    UIImageView *goldStarRight;
    UIImageView *expBar;
    UIImageView *levelUpTextView;
    
    UILabel *totalCoinsLabel;
    UILabel *gamePiecesClearedLabel;
    UILabel *boostsUsedLabel;
    UILabel *expEarnedLabel;
    UILabel *coinsEarnedLabel;
    UILabel *finalScoreLabel;
    UILabel *levelLabel;
    
    UIButton *continueButton;
    
    int level;
    int scoreIndex;
    int score;
    int remainingXp;
    int expBarIndex;
    int coinsEarned;
    int expToLevel;
    int expBarMaxWidth;
    float currentExperience;
    float expEarned;
    float expBarFrom;
    float expBarTo;
    
    BOOL playerLeveledUp;
    
    NSTimer *finalScoreTimer;
    NSTimer *expBarTimer;
    NSTimer *experienceTimer;
    NSTimer *piecesClearTimer;
    NSTimer *coinsEarnedTimer;
    NSTimer *totalCoinsTimer;
    NSTimer *boostsUsedTimer;
    NSTimer *animateStarsTimer;
    NSTimer *animateLevelUpTimer;
}

@property BOOL boostUnlocked;
@property (weak) id delegate;

@end
