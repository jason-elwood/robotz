//
//  LevelMap.h
//  robotz
//
//  Created by Jason Elwood on 10/14/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceTypes.h"
#import "CategoriesAndRobots.h"
#import "UIView+EasingFunctions.h"
#import "easing.h"
#import "AudioPlayer.h"
#import "Constants.h"
#import "SaveLoadDataDevice.h"
#import "UIView+EasingFunctions.h"
#import "easing.h"
#import "LoadingScreen.h"

@protocol LevelMapProtocol <NSObject>

- (void)closeLevelMapScreen;
- (void)showSelectBoostsScreen:(int)opponentIndex;

@end

@interface LevelMap : UIView
{
    LoadingScreen *loadingScreen;
    Constants *constants;
    CategoriesAndRobots *categoriesAndRobots;
    DeviceTypes *deviceTypes;
    UIView *scrollersContainer;
    UIScrollView *categoryScrollView;
    UIScrollView *robotScrollView;
    
    NSMutableArray *labelsTextArray;
    NSMutableDictionary *planetsAndRobotsDict;
    
    UIButton *backButtonPlanets;
    UIButton *backButtonRobots;
    
    BOOL isTheCurrentChallenger;
    BOOL followingPlanetsLocked;
    
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
    
    UIButton *mercuryButton;
    UIButton *venusButton;
    UIButton *earthButton;
    UIButton *marsButton;
    UIButton *jupiterButton;
    UIButton *saturnButton;
    UIButton *uranusButton;
    UIButton *neptuneButton;
    UIButton *plutoButton;
    
    
    UIButton *okayButton;
    UIButton *nextButton2;
    UIButton *nextButton3;
    
    NSArray *tutorialImages;
    
    int localPlanetIndex;
}

- (void)showTutorialForPlanetIndex:(int)planetIndexInt;

@property (weak) id <LevelMapProtocol>delegate;

@property BOOL showTutorial;

@end
