//
//  CharacterClassDetailsModule.h
//  robotz
//
//  Created by Jason Elwood on 9/18/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceTypes.h"
#import "GameData.h"
#import "PlayerData.h"
#import "CharacterClassData.h"
#import "Constants.h"
#import "SaveLoadDataDevice.h"
#import "CharLevelData.h"
#import "AudioPlayer.h"

@protocol characterClassDetailsModuleProtocol <NSObject>

- (void)newCharacterConfirmed;

@end

@interface CharacterClassDetailsModule : UIView <GameDataProtocol, UIAlertViewDelegate>
{
    DeviceTypes *deviceTypes;
    Constants *constants;
    CharLevelData *charLevelData;
    CharacterClassData *charClassData;
    UIImage *charDetailsBgImage;
    UIAlertView *confirmAlertView;
    
    int characterIndex;
    
    UILabel *classNameLabel;
    UITextView *classDescLabel;
    UILabel *attackLabel;
    UILabel *defenseLabel;
    UILabel *repairLabel;
    UILabel *agilityLabel;
    
    UILabel *attackValue;
    UILabel *defenseValue;
    UILabel *repairValue;
    UILabel *agilityValue;
    
    NSDictionary *charDataDictionary;
}

@property (weak) id delegate;

@end
