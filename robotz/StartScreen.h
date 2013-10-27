//
//  StartScreen.h
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceTypes.h"
#import "UIView+EasingFunctions.h"
#import "easing.h"
#import "AudioPlayer.h"

@protocol startScreenProtocol <NSObject>

- (void)startGame;
- (void)showFacebookView;

@end

@interface StartScreen : UIView
{
    DeviceTypes *deviceTypes;
    UIImage *startImage;
    UIImageView *titleImageView;
    
    UIImage *playButtonImage;
    UIButton *playButton;
    UIImage *robotImage;
    UIImageView *robotImageView;
}

@property (weak) id delegate;

@end
