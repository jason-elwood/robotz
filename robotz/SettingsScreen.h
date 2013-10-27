//
//  SettingsScreen.h
//  robotz
//
//  Created by Jason Elwood on 10/5/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceTypes.h"
#import "SaveLoadDataDevice.h"
#import "AudioPlayer.h"
#import "Constants.h"
#import "UIView+EasingFunctions.h"
#import "easing.h"

@protocol SettingsScreenProtocol <NSObject>

- (void)closeSettingsScreen;
- (void)showCreditsScreen;
- (void)viewDidLoad;

@end

@interface SettingsScreen : UIView
{
    Constants *constants;
    DeviceTypes *deviceTypes;
    
    UIView *blackBG;
    UIView *tut1Container;
    UIView *tut2Container;
    UIView *tut3Container;
    UIImageView *tut1ImageView;
    UIImageView *tut2ImageView;
    UIImageView *tut3ImageView;
    UIButton *nextButton;
    UIButton *nextButton2;
    UIButton *nextButton3;
    
    int tutWidth;
    int tutHeight;
}

@property (weak) id <SettingsScreenProtocol>delegate;

@end
