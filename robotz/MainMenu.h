//
//  MainMenu.h
//  robotz
//
//  Created by Jason Elwood on 9/19/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+EasingFunctions.h"
#import "easing.h"
#import "PlayerData.h"
#import "SaveLoadDataDevice.h"
#import "Constants.h"
#import "LoadingScreen.h"
#import "AnimationsClass.h"
#import "CharacterClassData.h"
#import "DeviceTypes.h"
#import "AudioPlayer.h"
#import "TickerMessages.h"
//#import "GCTurnBasedMatchHelper.h"

@protocol MainMenuProtocol <NSObject>

- (void)showSettingsScreen;
- (void)showStoreScreen;
- (void)showLevelMapScreen;
//- (void)authenticateUserForMatch;

@end

@interface MainMenu : UIView
{
    TickerMessages *tickerMessage;
    DeviceTypes *deviceTypes;
    LoadingScreen *loadingScreen;
    CharacterClassData *charClassData;
    NSMutableDictionary *playerDataDict;
    Constants *constants;
    AnimationsClass *animations;
    NSMutableDictionary *charDataDictionary;
    
    UIView *topView;
    UIView *bottomView;
    
    UILabel *messageLabel;
    
    UILabel *charClassLabel;
    
    UILabel *attackLabel;
    UILabel *defenseLabel;
    UILabel *repairLabel;
    UILabel *agilityLabel;
    
    UILabel *attackValue;
    UILabel *defenseValue;
    UILabel *repairValue;
    UILabel *agilityValue;
    
    UILabel *playerNameLabel;
    UILabel *playerLevelLabel;
    
    UIImageView *tutImageView;
    UIButton *nextButton;
    
    UIView *tut1Container;
    UIView *tut2Container;
    UIView *tut3Container;
    UIView *blackBG;
    
    UIView *charSelectContainer;
    UIButton *swipeButton;
    
    UIImageView *tut1ImageView;
    UIImageView *tut2ImageView;
    UIImageView *tut3ImageView;
    UIImageView *nameRobotPopupView;
    UIImageView *handImageView;
    UIImageView *swipeToChooseView;
    
    UIButton *okayButton;
    UIButton *nextButton2;
    UIButton *nextButton3;
    
    NSArray *tutorialImages;
}

@property (weak) id delegate;

@property BOOL showTutorial;

@end
