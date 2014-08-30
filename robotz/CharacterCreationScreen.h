//
//  CharacterCreationScreen.h
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceTypes.h"
#import "CharacterSelectorModule.h"
#import "CharacterClassDetailsModule.h"
#import "CharacterClassData.h"
#import "LoadingScreen.h"
#import "AudioPlayer.h"
#import "UIView+EasingFunctions.h"
#import "easing.h"

@protocol CharacterCreationScreenProtocol <NSObject>

- (void)newCharacterConfirmed:(NSString *)robotName;

@end

@interface CharacterCreationScreen : UIView <characterClassDetailsModuleProtocol, UITextFieldDelegate>
{
    DeviceTypes *deviceTypes;
    CharacterClassData *charClassData;
    CharacterSelectorModule *charSelectModule;
    CharacterClassDetailsModule *charClassDetailsModule;
    LoadingScreen *loadingScreen;
    
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
    UIButton *nextButton;
    UIButton *nextButton2;
    UIButton *nextButton3;
    
    NSArray *tutorialImages;
    
    UITextField *nameTextField;
    
    int currentTutorialImageIndex;
}

@property (weak) id delegate;
@property BOOL showTutorial;

@end
