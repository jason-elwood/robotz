//
//  BattleScreen.h
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleModule.h"
#import "OpponentBattleModule.h"
#import "PlayerHudModule.h"
#import "BattleManager.h"
#import "LoadingScreen.h"
#import "DeviceTypes.h"
#import "UIView+EasingFunctions.h"
#import "easing.h"
#import "EncouragingWords.h"
#import "AnimationsClass.h"
#import "Constants.h"
#import "AudioPlayer.h"
#import "InAppPurchaseManager.h"

@protocol BattleScreenProtocol <NSObject>

- (void)showResultsScreen;
- (void)endTutorial;
- (void)showGameMenu;

@end

@interface BattleScreen : UIView <PuzzleModuleProtocol, PlayerHudModuleProtocol, InAppPurchaseManagerProtocolBattleScreen, BattleManagerProtocolBattleScreen>
{
    InAppPurchaseManager *inAppPurchaseManager;
    Constants *constants;
    AnimationsClass *animations;
    DeviceTypes *deviceTypes;
    LoadingScreen *loadingScreen;
    PuzzleModule *puzzleModule;
    OpponentBattleModule *opponentBattleModule;
    PlayerHudModule *hud;
    UIImageView *youWonGraphic;
    UIImageView *getRepairsGraphic;
    UIView *resultView;
    UIImageView *resultGraphic;
    UIImageView *noMoreMatchesGraphic;
    UIImageView *tutOverlayGraphic;
    
    UIView *bgAlpha;
    
    BOOL playerWon;
    BOOL animatingMessage;
    
    NSTimer *resetMessageTimer;
    
    UIView *tut1Container;
    UIView *tut2Container;
    UIView *tut3Container;
    UIView *blackBG;
    
    UIView *charSelectContainer;
    UIButton *swipeButton;
    UIButton *keepPlayingButton;
    
    UIImageView *tut1ImageView;
    UIImageView *tut2ImageView;
    UIImageView *tut3ImageView;
    UIImageView *nameRobotPopupView;
    UIImageView *handImageView;
    UIImageView *swipeToChooseView;
    
    UIButton *okayButton;
    UIButton *nextButton;
    UIButton *nextButton2;
    UIButton *nextButton3;
    
    UIActivityIndicatorView *paymentProgressView;
    UILabel *paymentProgressLabel;
    
    NSArray *tutorialImages;
}

@property (weak) id <BattleScreenProtocol>delegate;
@property BOOL showTutorial;

- (void)startAnimationOutPlayerWon:(BOOL)playerWon;

@end
