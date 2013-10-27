//
//  OpponentBattleModule.h
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceTypes.h"
#import "AnimationsClass.h"
#import "BattleManager.h"
#import "UIView+EasingFunctions.h"
#import "easing.h"
#import "PointBurst.h"

@interface OpponentBattleModule : UIView <BattleManagerProtocolOpponent>
{
    DeviceTypes *deviceTypes;
    AnimationsClass *animations;
    UIImageView *robotImageView;
    
    UIImageView *fireballImageView;
    UIImageView *fireballImageView2;
    UIImageView *fireballImageView3;
    UIImageView *fireballImageView4;
    
    NSTimer *animationTimer;
    
    UIButton *menuButton;
}

@end
