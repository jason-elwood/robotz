//
//  GCTurnBasedMatchHelper.m
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "GCTurnBasedMatchHelper.h"

@implementation GCTurnBasedMatchHelper

@synthesize gameCenterAvailable, currentMatch, delegate;

#pragma mark Initialization

/******************************************************************************************************************
 Creates a static instance of this class: GCTurnBasedMatchHelper
 *****************************************************************************************************************/
//static GCTurnBasedMatchHelper *sharedHelper = nil;
//+ (GCTurnBasedMatchHelper *) sharedInstance {
//    if (!sharedHelper) {
//        sharedHelper = [[GCTurnBasedMatchHelper alloc] init];
//    }
//    return sharedHelper;
//}

+ (id)sharedInstance; {
    static GCTurnBasedMatchHelper *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        
    });
    return sharedMyManager;
}

/******************************************************************************************************************
 Checks to see if Game Center is available on the current device
 *****************************************************************************************************************/
- (BOOL)isGameCenterAvailable {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                           options:NSNumericSearch] != NSOrderedAscending);
    NSLog(@"isGameCenterAvailable called...");
    return (gcClass && osVersionSupported);
}

/******************************************************************************************************************
 Register for the auth/deauth notification and calls authenticationChanged when there is an update to auth status
 *****************************************************************************************************************/
- (id)init {
    if ((self = [super init])) {
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable) {
            NSNotificationCenter *nc =
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self
                   selector:@selector(authenticationChanged)
                       name:GKPlayerAuthenticationDidChangeNotificationName
                     object:nil];
        }
    }
    return self;
}

/******************************************************************************************************************
 Updates userAuthenticated flag when there is a change to the players' Game Center auth status
 *****************************************************************************************************************/
- (void)authenticationChanged {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated &&
        !userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        userAuthenticated = TRUE;
        [delegate authenticateUserForMatch];
        GKLocalPlayer *lp = [GKLocalPlayer localPlayer];
        //[[GameManagerController sharedInstance] setPlayerOneName:lp.alias];
    } else if (![GKLocalPlayer localPlayer].isAuthenticated &&
               userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = FALSE;
    }
    
}

#pragma mark User functions

/******************************************************************************************************************
 This method checks to see if the user is Game Center authenticated and attempts to authenticate them if not.
 Call this method to auth the user once the app is loaded.
 *****************************************************************************************************************/
- (void)authenticateLocalUser {
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
        if (localPlayer.isAuthenticated)
        {
            // Perform additional tasks for the authenticated player.
        }
    }];
    
//    if (!gameCenterAvailable) return;
//    
//    void (^setGKEventHandlerDelegate)(NSError *) = ^ (NSError *error)
//    {
//        GKTurnBasedEventHandler *ev =
//        [GKTurnBasedEventHandler sharedTurnBasedEventHandler];
//        ev.delegate = self;
//    };
//    
//    NSLog(@"Authenticating local user...");
//    if ([GKLocalPlayer localPlayer].authenticated == NO) {
//        [GKLocalPlayer localPlayer].authenticateHandler = ^(UIViewController *vc, NSError *error) {
//            [delegateVC authenticateUserForMatch:vc];//present the login
//        };
//    } else {
//        NSLog(@"Already authenticated!");
//        setGKEventHandlerDelegate(nil);
//    }
    
    /***********************************************************
     ONLY USE THIS IMPLEMENTATION IN ORDER TO REMOVE OLD DATA!!!
     **********************************************************/
    /*
     if (!gameCenterAvailable) return;
     
     NSLog(@"Authenticating local user...");
     if ([GKLocalPlayer localPlayer].authenticated == NO) {
     [[GKLocalPlayer localPlayer]
     authenticateWithCompletionHandler:^(NSError * error) {
     [GKTurnBasedMatch loadMatchesWithCompletionHandler:
     ^(NSArray *matches, NSError *error){
     for (GKTurnBasedMatch *match in matches) {
     NSLog(@"%@", match.matchID);
     [match removeWithCompletionHandler:^(NSError *error){
     NSLog(@"%@", error);}];
     }}];
     }];
     } else {
     NSLog(@"Already authenticated!");
     }
     */
    
}

/******************************************************************************************************************
 Presents the Game Center Match View Controller with the provided variables from the main UI (ViewController.m) when
 the Game Center button is pressed.
 *****************************************************************************************************************/
- (void)findMatchWithMinPlayers:(int)minPlayers
                     maxPlayers:(int)maxPlayers
                 viewController:(UIViewController *)viewController {
    if (!gameCenterAvailable) return;
    
    presentingViewController = viewController;
    
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = minPlayers;
    request.maxPlayers = maxPlayers;
    
    GKTurnBasedMatchmakerViewController *mmvc =
    [[GKTurnBasedMatchmakerViewController alloc]
     initWithMatchRequest:request];
    mmvc.turnBasedMatchmakerDelegate = self;
    mmvc.showExistingMatches = YES;
    
    [presentingViewController presentModalViewController:mmvc
                                                animated:YES];
}

#pragma mark GKTurnBasedMatchmakerViewControllerDelegate

/******************************************************************************************************************
 DidFindMatch is fired when the user selects a match from the list of matches. This match could be one where it’s
 currently our player’s turn, where it’s another player’s turn, or where the match has ended.
 *****************************************************************************************************************/
-(void)turnBasedMatchmakerViewController:
(GKTurnBasedMatchmakerViewController *)viewController
                            didFindMatch:(GKTurnBasedMatch *)match {
    [presentingViewController
     dismissModalViewControllerAnimated:YES];
    self.currentMatch = match;
    GKTurnBasedParticipant *firstParticipant =
    [match.participants objectAtIndex:0];
    if (firstParticipant.lastTurnDate == NULL) {
        // It's a new game!
        [delegate enterNewGame:match];
    } else {
        if ([match.currentParticipant.playerID
             isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            // It's your turn!
            [delegate takeTurn:match];
        } else {
            // It's not your turn, just display the game state.
            [delegate layoutMatch:match];
        }
    }
}

/******************************************************************************************************************
 WasCancelled will fire when the cancel button is clicked.
 *****************************************************************************************************************/
-(void)turnBasedMatchmakerViewControllerWasCancelled:
(GKTurnBasedMatchmakerViewController *)viewController {
    [presentingViewController
     dismissModalViewControllerAnimated:YES];
    NSLog(@"has cancelled");
}

/******************************************************************************************************************
 DidFail fires when there’s an error. This could occur because we’ve lost connectivity or for a variety of other reasons.
 *****************************************************************************************************************/
-(void)turnBasedMatchmakerViewController:
(GKTurnBasedMatchmakerViewController *)viewController
                        didFailWithError:(NSError *)error {
    [presentingViewController
     dismissModalViewControllerAnimated:YES];
    NSLog(@"Error finding match: %@", error.localizedDescription);
}

/******************************************************************************************************************
 PlayerQuitForMatch method is fired when a player swipes a match (while it’s their turn) and quits it. Swiping a match
 will reveal a quit (if it’s a match that is still active) or remove button. If a player quits a match while it’s still
 their turn, they need to handle the match, update it’s state, and pass it along to the next player. If a player were
 to quit without passing the turn on to the next player, the match would not be able to progress forward!
 *****************************************************************************************************************/
-(void)turnBasedMatchmakerViewController:
(GKTurnBasedMatchmakerViewController *)viewController
                      playerQuitForMatch:(GKTurnBasedMatch *)match {
    NSUInteger currentIndex =
    [match.participants indexOfObject:match.currentParticipant];
    GKTurnBasedParticipant *part;
    
    for (int i = 0; i < [match.participants count]; i++) {
        part = [match.participants objectAtIndex:
                (currentIndex + 1 + i) % match.participants.count];
        if (part.matchOutcome != GKTurnBasedMatchOutcomeQuit) {
            break;
        }
    }
    NSLog(@"playerquitforMatch, %@, %@",
          match, match.currentParticipant);
    [match participantQuitInTurnWithOutcome:
     GKTurnBasedMatchOutcomeQuit nextParticipant:part
                                  matchData:match.matchData completionHandler:nil];
}

#pragma mark GKTurnBasedEventHandlerDelegate

/******************************************************************************************************************
 The handleInviteFromGameCenter is only fired when you start a game from inside the game center app.
 If you send an invite from game center, the callback needs to instantiate a new GKMatchRequest and either programmatically
 or with the view controller (GKTurnBasedMatchmakerViewController) set up the new match. Invites sent from within the
 app won’t need to call this method.
 *****************************************************************************************************************/
-(void)handleInviteFromGameCenter:(NSArray *)playersToInvite {
    [presentingViewController
     dismissModalViewControllerAnimated:YES];
    GKMatchRequest *request =
    [[GKMatchRequest alloc] init];
    request.playersToInvite = playersToInvite;
    request.maxPlayers = 12;
    request.minPlayers = 2;
    GKTurnBasedMatchmakerViewController *viewController =
    [[GKTurnBasedMatchmakerViewController alloc]
     initWithMatchRequest:request];
    viewController.showExistingMatches = NO;
    viewController.turnBasedMatchmakerDelegate = self;
    [presentingViewController
     presentModalViewController:viewController animated:YES];
    NSLog(@"New invite");
}

/******************************************************************************************************************
 When the handleTurn is called, either the match has moved from one player to another, and it’s still not our turn,
 or the turn has moved to our player. In addition, the match that’s currently loaded into the game state, may or may
 not be the match that has received the handleTurn call. We need to distinguish between these scenarios and handle
 each in turn.
 *****************************************************************************************************************/
-(void)handleTurnEventForMatch:(GKTurnBasedMatch *)match {
    NSLog(@"Turn has happened");
    if ([match.matchID isEqualToString:currentMatch.matchID]) {
        if ([match.currentParticipant.playerID
             isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            // it's the current match and it's our turn now
            self.currentMatch = match;
            [delegate takeTurn:match];
        } else {
            // it's the current match, but it's someone else's turn
            self.currentMatch = match;
            [delegate layoutMatch:match];
        }
    } else {
        if ([match.currentParticipant.playerID
             isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            // it's not the current match and it's our turn now
            [delegate sendNotice:@"It's your turn for another match"
                        forMatch:match];
        } else {
            // it's the not current match, and it's someone else's
            // turn
        }
    }
}

/******************************************************************************************************************
 What should happen when a game has ended.  If it's the current match we call recieveEndGame in the ViewController.
 Otherwise we just send a notice.
 *****************************************************************************************************************/
-(void)handleMatchEnded:(GKTurnBasedMatch *)match {
    NSLog(@"Game has ended");
    if ([match.matchID isEqualToString:currentMatch.matchID]) {
        [delegate recieveEndGame:match];
    } else {
        [delegate sendNotice:@"Another Game Ended!" forMatch:match];
    }
}

@end