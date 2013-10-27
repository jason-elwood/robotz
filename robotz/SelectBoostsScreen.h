//
//  SelectBoostsScreen.h
//  robotz
//
//  Created by Jason Elwood on 9/24/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceTypes.h"
#import "BoostsData.h"
#import "Constants.h"
#import "PlayerData.h"
#import "BattleManager.h"
#import "AudioPlayer.h"
#import "SaveLoadDataDevice.h"
#import "UIView+EasingFunctions.h"
#import "easing.h"

@protocol SelectBoostsProtocol <NSObject>

- (void)hideSelectBoostsScreen;
- (void)playSinglePlayer:(int)opponentIndex;
- (void)showStoreScreen;

@end

@interface SelectBoostsScreen : UIView <SaveLoadDataDeviceProtocol>
{
    DeviceTypes *deviceTypes;
    BoostsData *boostsData;
    Constants *constants;
    int opponentIndex;
    int boostOneCost;
    int boostTwoCost;
    int boostThreeCost;
    int boostFourCost;
    int boostFiveCost;
    int numBoostsSelected;
    
    int accumBoostCost;
    
    UILabel *coinsLabel;
    UILabel *costLabel;
    
    UIAlertView *sorryAlert;
    
    UIImageView *boostOneImageView;
    UIImageView *boostTwoImageView;
    UIImageView *boostThreeImageView;
    UIImageView *boostFourImageView;
    UIImageView *boostFiveImageView;
    
    UIButton *boost1Button;
    UIButton *boost2Button;
    UIButton *boost3Button;
    UIButton *boost4Button;
    UIButton *boost5Button;
    
    UIButton *boost1ButtonLarge;
    UIButton *boost2ButtonLarge;
    UIButton *boost3ButtonLarge;
    UIButton *boost4ButtonLarge;
    UIButton *boost5ButtonLarge;
    
    BOOL boostOneSelected;
    BOOL boostTwoSelected;
    BOOL boostThreeSelected;
    BOOL boostFourSelected;
    BOOL boostFiveSelected;UIImageView *tutImageView;
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

- (void)sendOpponentIndex:(int)opponentIndex;

@property (weak) id delegate;

@property BOOL showTutorial;

@end
