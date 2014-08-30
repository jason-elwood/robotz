//
//  ViewController.h
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
// #import <Tapjoy/Tapjoy.h>
#import "DeviceTypes.h"
#import "SplashScreen.h"
#import "StartScreen.h"
#import "CharacterCreationScreen.h"
#import "BattleResultsScreen.h"
#import "DataBaseRetrieval.h"
#import "MainMenu.h"
#import "BattleScreen.h"
#import "SaveLoadDataDevice.h"
#import "SelectBoostsScreen.h"
#import "AnimationsClass.h"
#import "StoreScreen.h"
#import "BattleManager.h"
#import "AudioPlayer.h"
#import "Constants.h"
#import "UIView+EasingFunctions.h"
#import "easing.h"
#import "SettingsScreen.h"
#import "CreditsScreen.h"
#import "BoostUnlockedScreen.h"
#import "BoostsData.h"
#import "LevelMap.h"
#import "GameMenu.h"
//#import "GCTurnBasedMatchHelper.h"

@interface ViewController : UIViewController <startScreenProtocol, CharacterCreationScreenProtocol, MainMenuProtocol, SelectBoostsProtocol, AnimationsClassBoostsProtocol, StoreScreenProtocol, BattleManagerProtocolViewController, BattleResultsScreenProtocol, BattleScreenProtocol, SettingsScreenProtocol, AudioPlayerProtocol, CreditsScreenProtocol, BoostUnlockedProtocol, LevelMapProtocol, SaveLoadDataDeviceProtocolViewController, GameMenuProtocol/*, GCTurnBasedMatchHelperDelegate, GKTurnBasedMatchmakerViewControllerDelegate*/>
{
    GameMenu *gameMenu;
    LevelMap *levelMapScreen;
    BoostsData *boostsData;
    BoostUnlockedScreen *boostUnlockedScreen;
    CreditsScreen *creditsScreen;
    SettingsScreen *settingsScreen;
    Constants *constants;
    AnimationsClass *animations;
    DeviceTypes *deviceTypes;
    DataBaseRetrieval *dbRetrieval;
    SplashScreen *splashScreen;
    StartScreen *startScreen;
    StoreScreen *storeScreen;
    CharacterCreationScreen *charCreateScreen;
    MainMenu *mainMenu;
    BattleScreen *battleScreen;
    BattleResultsScreen *battleResultsScreen;
    SelectBoostsScreen *selectBoostsScreen;
    UIView *currentView;
    NSString *currentlyPlayingMusic;
    
    NSString *rateAppString;
    NSString *facebookMessageString;
    
    //GKTurnBasedMatch *myMatch;
    
    BOOL characterSaved;
    BOOL playerWon;
    BOOL showTutorial;
    BOOL unlockPlanet;
    int planetIndexLocal;
}

@end
