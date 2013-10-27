//
//  GameMenu.h
//  robotz
//
//  Created by Jason Elwood on 10/18/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceTypes.h"
#import "SaveLoadDataDevice.h"
#import "AudioPlayer.h"
#import "Constants.h"

@protocol GameMenuProtocol <NSObject>

- (void)hideGameMenu;
- (void)quitMatch;

@end

@interface GameMenu : UIView
{
    DeviceTypes *deviceTypes;
    Constants *constants;
}

@property (weak) id <GameMenuProtocol>delegate;


@end
