//
//  PlayerHudModule.h
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BattleManager.h"
#import "DeviceTypes.h"
#import "BoostsData.h"
#import "Constants.h"
#import "AnimationsClass.h"
#import "PointBurst.h"
#import "UIView+EasingFunctions.h"
#import "easing.h"
#import "AudioPlayer.h"
#import "THLabel.h"
#import "SaveLoadDataDevice.h"

@protocol PlayerHudModuleProtocol <NSObject>

- (void)showTheGameMenu;

@end

@interface PlayerHudModule : UIView <BattleManagerProtocolHud>
{
    DeviceTypes *deviceTypes;
    BoostsData *boostsData;
    Constants *constants;
    AnimationsClass *animations;
    
    NSMutableArray *boostsArray;
    
    int numBuffsUsed;
    
    UILabel *pointsLabel;
    THLabel *scoreLabel;
    THLabel *playersCurrentMaxHealthLabel;
    THLabel *opponentCurrentMaxHealthLabel;
    THLabel *numResurrectionsLabel;
    UIImageView *playerHpBar;
    UIImageView *opponentHpBar;
    UIImageView *healthBoostButtonBgImageView;
    UIImageView *defenseBoostIconImageView;
    UIImageView *repairBoostIconImageView;
    UIImageView *resurrectionBoostImageView;
    UIImageView *attackBoostIconImageView;
    
    UIImageView *resurrectionRobotView;
    
    int opponentHpBar100PercentWidth;
    int playerHpBar100PercentWidth;
    
    CGPoint boost1Pos;
    CGPoint boost2Pos;
    CGPoint boost3Pos;
    
    UIButton *boostFullHealth;
    UIButton *boostResurrection;
    UIButton *menuButton;
    // boost button 3
    // boost button 4
    // boost button 5
}

@property (weak) id <PlayerHudModuleProtocol>delegate;

- (void)updateResurrections;

@end
