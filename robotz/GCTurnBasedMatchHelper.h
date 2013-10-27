//
//  GCTurnBasedMatchHelper.h
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
//#import "GameManagerController.h"

@protocol GCTurnBasedMatchHelperDelegate

- (void)authenticateUserForMatch;
- (void)enterNewGame:(GKTurnBasedMatch *)match;
- (void)layoutMatch:(GKTurnBasedMatch *)match;
- (void)takeTurn:(GKTurnBasedMatch *)match;
- (void)recieveEndGame:(GKTurnBasedMatch *)match;
- (void)sendNotice:(NSString *)notice
          forMatch:(GKTurnBasedMatch *)match;
- (void)displayStartScreen;

@end

@interface GCTurnBasedMatchHelper : NSObject
<GKTurnBasedMatchmakerViewControllerDelegate,
GKTurnBasedEventHandlerDelegate>
{
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    UIViewController *presentingViewController;
    
    GKTurnBasedMatch *currentMatch;
}

@property (weak) id <GCTurnBasedMatchHelperDelegate> delegate;
@property (assign, readonly) BOOL gameCenterAvailable;
@property (nonatomic, retain) GKTurnBasedMatch *currentMatch;

+ (GCTurnBasedMatchHelper *)sharedInstance;
- (void)authenticateLocalUser;
- (void)authenticationChanged;
- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(UIViewController *)viewController;

@end