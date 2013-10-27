//
//  ViewController.m
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//  Database: name: robotzdb password: Beastie1972!
//  New Database: name: robotzdatabase password: Beastie1972!
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    //[GCTurnBasedMatchHelper sharedInstance].delegate = self;
    showTutorial = YES;
    AudioPlayer *ap = [AudioPlayer sharedManager];
    ap.delegate = self;
    [ap initializeSounds];
    boostsData = [[BoostsData alloc] init];
    constants = [[Constants alloc] init];
    [super viewDidLoad];
    [self getDeviceTypeAndDimensions];
    [self queryDataBase];
    [self showSplashScreen];
    characterSaved = NO;
    animations = [[AnimationsClass alloc] init];
    animations.delegate = self;
    BattleManager *bm = [BattleManager sharedManager];
    bm.delegateViewController = self;
    SaveLoadDataDevice *sldd = [SaveLoadDataDevice sharedManager];
    sldd.delegateVC = self;
    [sldd incrementNumberOfLogins];
//    [sldd setMusicOn:YES];
//    [sldd setSoundFxOn:YES];
    if (sldd.thereIsSavedData) {
        NSLog(@"there is saved data");
        characterSaved = YES;
        [self refreshPlayerData];
        if (![sldd getMusicOn]) {
            NSLog(@"Turn off music from ViewController");
            [[AudioPlayer sharedManager] turnOffAllMusic];
        }
        if (![sldd getSoundFxOn]) {
            [[AudioPlayer sharedManager] turnOffAllSoundFx];
        }
    } else {
        [[SaveLoadDataDevice sharedManager] setMusicOn:YES];
        [[SaveLoadDataDevice sharedManager] setSoundFxOn:YES];
    }
	// Do any additional setup after loading the view, typically from a nib.
    //[self showOfferwall:[[UIButton alloc]init]];
    //[self reviewAppRequest]; /* REMOVE REMOVE REMOVE REMOVE REMOVE REMOVE REMOVE REMOVE REMOVE REMOVE REMOVE REMOVE REMOVE REMOVE REMOVE REMOVE  */
}

#pragma mark START TURN BASED FUNCTIONS

//- (void)authenticateUserForMatch
//{
//    GKMatchRequest *request = [[GKMatchRequest alloc] init];
//    request.minPlayers = 2;
//    request.maxPlayers = 2;
//    
//    GKTurnBasedMatchmakerViewController *mmvc = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
//    mmvc.turnBasedMatchmakerDelegate = self;
//    
//    [self presentViewController:mmvc animated:YES completion:nil];
//}
//
//- (void) loadMatches
//{
//    [GKTurnBasedMatch loadMatchesWithCompletionHandler:^(NSArray *matches, NSError *error) {
//        if (matches)
//        {
//            NSLog(@"loading matches : %@", matches);
//            // Use the match data to populate your user interface.
//        }
//    }];
//}
//
//- (void)turnBasedMatchmakerViewControllerWasCancelled:(GKTurnBasedMatchmakerViewController *)viewController
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//    NSLog(@"turnBasedMatchmakerViewControllerWasCancelled");
//}
//
//- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFailWithError:(NSError *)error
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//    NSLog(@"turnBasedMatchmakerViewController didFailWithError");
//}
//
//- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFindMatch:(GKTurnBasedMatch *)match
//{
//    myMatch = match;
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self performSegueWithIdentifier:@"GamePlayScene" sender:match];
//    NSLog(@"turnBasedMatchmakerViewController didFindMatch");
//    [self loadAndDisplayMatchData];
//}
//
//- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender
//{
//    NSLog(@"performSegueWithIdentifier identifier: %@ sender: %@", identifier, sender);
//}
//
//- (void )prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"GamePlayScene"])
//    {
////        MyGamePlayViewController* gameVC = (MyGamePlayViewController*) segue.destinationViewController;
////        gameVC.delegate = self;
////        gameVC.match = (GKTurnBasedMatch*) sender;
//        
//        NSLog(@"prepareForSegue...");
//    }
//}
//
//- (void) loadAndDisplayMatchData
//{
//    [myMatch loadMatchDataWithCompletionHandler:^(NSData *matchData, NSError *error)
//    {
//        NSDictionary *myDict = [NSPropertyListSerialization
//                                propertyListFromData:matchData mutabilityOption:NSPropertyListImmutable format:nil
//                                errorDescription:nil];
//        //[gameDictionary addEntriesFromDictionary: myDict];
//        //[self populateExistingGameBoard];
//        if (error) {
//            NSLog(@"loadMatchData - %@", [error localizedDescription]);
//        } else {
//            NSLog(@"loadAndDisplayMatchData : %@", matchData);
//        }
//        
//    }];
//    
//}
//
//- (void) updateMatchData
//{
////    // App-specific routine to encode the match data.
////    NSData *updatedMatchData = [this.gameData encodeMatchData];
////    [this.myMatch saveCurrentTurnWithMatchData: updatedMatchData completionHandler ^(NSError *error) {
////        if (error)
////        {
////            // Handle the error.
////        }
////    }];
//}
//
//- (void) advanceTurn
//{
////    NSData *updatedMatchData = [this.gameData encodeMatchData];
////    NSArray *sortedPlayerOrder = [this.gameData encodePlayerOrder];
////    this.MyMatch.message = [this.gameData matchAppropriateMessage];
////    [this.myMatch endTurnWithNextParticipants: sortedPlayerOrder turnTimeOut: GKTurnTimeoutDefault
////                                    matchData: updatedMatchData completionHandler ^(NSError *error) {
////                                        if (error)
////                                        {
////                                            // Handle the error.
////                                        }
////                                    }];
//}

#pragma mark END TURN BASED FUNCIONS

- (void)showOfferwall:(id)sender
{
	//[Tapjoy showOffersWithViewController:self];
}

- (void)reviewAppRequest
{
    UIAlertView *reviewRequestView = [[UIAlertView alloc] initWithTitle:@"Rate Robotz" message:@"Support Robotz!  Rate the game!" delegate:self cancelButtonTitle:@"Don't ask me again" otherButtonTitles:@"Rate and support", @"No, not now", nil];
    [reviewRequestView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"alertView buttonIndex : %d", buttonIndex);
    if (buttonIndex == 0) {
        [[SaveLoadDataDevice sharedManager] hideRateMyAppForever:[NSNumber numberWithInt:1]];
    } else if (buttonIndex == 1) {
        [self reviewApp];
        [[SaveLoadDataDevice sharedManager] hideRateMyAppForever:[NSNumber numberWithInt:1]];
    } else {
        // Do nothing.
    }
}

- (void)reviewApp
{
    NSString *str = [dbRetrieval getAppURL];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)showFacebookView:(StoreScreen *)view
{
//    if([SLComposeViewController isAvailableForServiceType: SLServiceTypeFacebook])
//    {
        // Facebook Service Type is Available
        
        SLComposeViewController *slVC   =   [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeFacebook];
        SLComposeViewControllerCompletionHandler handler    =   ^(SLComposeViewControllerResult result)
        {
            if (result == SLComposeViewControllerResultCancelled)
            {
                NSLog(@"Cancelled");
                
            }
            else
            {
                NSLog(@"Done");
                [view facebookShareConfirmed];
            }
            
            [slVC dismissViewControllerAnimated:YES completion:Nil];
        };
        slVC.completionHandler          =   handler;
        [slVC setInitialText:@"I    Robotz. Available publicly November 2013!"];
        [slVC addURL:[NSURL URLWithString:@"http://droppedpixelgames.com/"]];
        [slVC addImage:[UIImage imageNamed:@"RobotzComingSoonGraphic.png"]];
        
        [self presentViewController:slVC animated:YES completion:Nil];
//    }
//    else
//    {
//        NSLog(@"Service Unavailable!!!");
//    }
}

- (void)refreshPlayerData
{
    SaveLoadDataDevice *sldd = [SaveLoadDataDevice sharedManager];
    PlayerData *pd = [PlayerData sharedManager];
    [pd setRobotData:[sldd loadPlayerData]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getDeviceTypeAndDimensions
{
    deviceTypes = [[DeviceTypes alloc] init];
}

- (void)queryDataBase
{
    dbRetrieval = [[DataBaseRetrieval alloc] init];
    [dbRetrieval getPlayerDataFromDatabase];
}

- (void)clearScreen:(UIView *)screen
{
    if (screen != nil) {
        [screen removeFromSuperview];
        screen = nil;
    }
}

- (void)showSplashScreen
{
    splashScreen = [[SplashScreen alloc] init];
    [self.view addSubview:splashScreen];
    [self clearScreen:currentView];
    currentView = splashScreen;
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 3.0];
    NSTimer *animationTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(showStartScreen:) userInfo:nil repeats:NO];
    
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: animationTimer forMode: NSDefaultRunLoopMode];
}

- (void)showStartScreen:(NSTimer *)timer
{
    [timer invalidate];
    timer = nil;
    startScreen = [[StartScreen alloc] init];
    startScreen.delegate = self;
    [startScreen setFrame:CGRectMake(0, 0, deviceTypes.deviceWidth, deviceTypes.deviceHeight)];
    [self.view addSubview:startScreen];
    
    if (currentlyPlayingMusic != nil) {
        //[[AudioPlayer sharedManager] StopMusic:currentlyPlayingMusic];
        NSLog(@"stopping : %@", currentlyPlayingMusic);
    }
    
    [[AudioPlayer sharedManager] PlayMusic:constants.MUSICMAINMENU atVolume:1.0];
    currentlyPlayingMusic = constants.MUSICMAINMENU;
    
    [self clearScreen:currentView];
    currentView = startScreen;
    
    // Display the request to rate the app or not.
    if (![[SaveLoadDataDevice sharedManager] hideRateMyAppForever:[NSNumber numberWithInt:-1]]) {
        if ([[SaveLoadDataDevice sharedManager] getNumberOfLogins] % 3 == 0) {
            NSString *str = [dbRetrieval getAppURL];
            if (str == nil || [str isEqualToString:@""]) {
                return;
            } else {
                [self reviewAppRequest];
            }
        }
    }
}

- (void)showSettingsScreen
{
    settingsScreen = [[SettingsScreen alloc] initWithFrame:CGRectMake(0, -deviceTypes.deviceHeight, deviceTypes.deviceWidth, settingsScreen.frame.size.height)];
    settingsScreen.delegate = self;
    [self.view  addSubview:settingsScreen];
    [settingsScreen setEasingFunction:BounceEaseOut forKeyPath:@"frame"];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        settingsScreen.frame = CGRectMake(0, 0, deviceTypes.deviceWidth, deviceTypes.deviceHeight);
        [settingsScreen setEasingFunction:BounceEaseOut forKeyPath:@"frame"];
    }];
    
    [[AudioPlayer sharedManager] PlayViewOpenClose:1.0];
    
}

- (void)closeSettingsScreen
{
    [UIView animateWithDuration:1.0 animations:^{
        
        settingsScreen.frame = CGRectMake(0, -deviceTypes.deviceHeight - 100, deviceTypes.deviceWidth, deviceTypes.deviceHeight);
        [settingsScreen setEasingFunction:BounceEaseOut forKeyPath:@"frame"];
    }];
    
    [[AudioPlayer sharedManager] PlayViewOpenClose:1.0];
}

- (void)showCreditsScreen
{
    creditsScreen = [[CreditsScreen alloc] initWithFrame:CGRectMake(0, -deviceTypes.deviceHeight, deviceTypes.deviceWidth, settingsScreen.frame.size.height)];
    creditsScreen.delegate = self;
    [self.view addSubview:creditsScreen];
    [creditsScreen setEasingFunction:BounceEaseOut forKeyPath:@"frame"];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        creditsScreen.frame = CGRectMake(0, 0, deviceTypes.deviceWidth, deviceTypes.deviceHeight);
        [creditsScreen setEasingFunction:BounceEaseOut forKeyPath:@"frame"];
    }];
    
    [[AudioPlayer sharedManager] PlayViewOpenClose:1.0];
    
}

- (void)closeCreditsScreen
{
    [UIView animateWithDuration:1.0 animations:^{
        
        creditsScreen.frame = CGRectMake(0, -deviceTypes.deviceHeight - 100, deviceTypes.deviceWidth, deviceTypes.deviceHeight);
        [creditsScreen setEasingFunction:BounceEaseOut forKeyPath:@"frame"];
    }];
}

- (void)startGame
{
    NSLog(@"Start Game!");
    [self checkForSavedCharacter];
    
}

- (void)checkForSavedCharacter
{
    if (!characterSaved) {  // debug - debug - debug - debug - debug - debug - debug - debug - debug - debug - debug - debug - debug - debug - debug
        [[SaveLoadDataDevice sharedManager] hideRateMyAppForever:[NSNumber numberWithInt:0]];
        [self showCharacterCreationScreen];
    } else {
        showTutorial = NO;
        [self showMainMenu];
    }
}

- (void)endTutorial
{
    showTutorial = NO;
}

- (void)showCharacterCreationScreen
{
    charCreateScreen = [[CharacterCreationScreen alloc] init];
    charCreateScreen.delegate = self;
    [charCreateScreen setFrame:CGRectMake(0, 0, deviceTypes.deviceWidth, deviceTypes.deviceHeight)];
    
    if (showTutorial) {
        charCreateScreen.showTutorial = YES;
    }
    
    [self.view addSubview:charCreateScreen];
    
    [self clearScreen:currentView];
    currentView = charCreateScreen;
}

- (void)newCharacterConfirmed:(NSString *)robotName
{
    [[SaveLoadDataDevice sharedManager] setPlayersName:robotName];
    [self showMainMenu];
}

- (void)showMainMenu
{
    NSLog(@"Show Main Menu!");
    mainMenu = [[MainMenu alloc] initWithFrame:CGRectMake(0, 0, deviceTypes.deviceWidth, deviceTypes.deviceHeight)];
    mainMenu.delegate = self;
    [self.view addSubview:mainMenu];
    
    if (currentlyPlayingMusic != nil) {
        //[[AudioPlayer sharedManager] StopMusic:currentlyPlayingMusic];
    }
    
    [[AudioPlayer sharedManager] PlayMusic:constants.MUSICMAINMENU atVolume:1.0];
    currentlyPlayingMusic = constants.MUSICMAINMENU;
    
    [self clearScreen:currentView];
    currentView = mainMenu;
    
    if (showTutorial) {
        mainMenu.showTutorial = YES;
    }
}

- (void)playSinglePlayer:(int)opponentIndex
{
    BattleManager *bm = [BattleManager sharedManager];
    [bm initializeBattleManagerState:opponentIndex];
    [self showBattleScreen];
}

- (void)showLevelMapScreen
{
    NSLog(@"Show Level Map Screen");
    levelMapScreen = [[LevelMap alloc] initWithFrame:CGRectMake(0, 0, deviceTypes.deviceWidth, deviceTypes.deviceHeight)];
    levelMapScreen.delegate = self;
    [self.view addSubview:levelMapScreen];
    [levelMapScreen setEasingFunction:BounceEaseOut forKeyPath:@"frame"];
    [self animateView:levelMapScreen];
    
    if (showTutorial) {
        levelMapScreen.showTutorial = YES;
    }
    if (unlockPlanet) {
        [levelMapScreen showTutorialForPlanetIndex:planetIndexLocal];
        unlockPlanet = NO;
    }
}

- (void)unlockPlanet:(int)planetIndex
{
    unlockPlanet = YES;
    planetIndexLocal = planetIndex;
}

- (void)closeLevelMapScreen
{
    [self showMainMenu];
    [levelMapScreen removeFromSuperview];
    levelMapScreen = nil;
}

- (void)showSelectBoostsScreen:(int)opponentIndex
{
    NSLog(@"Show Select Boosts Screen");
    [self refreshPlayerData];
    selectBoostsScreen = [[SelectBoostsScreen alloc] initWithFrame:CGRectMake(0, -deviceTypes.deviceHeight- 50, deviceTypes.deviceWidth, deviceTypes.deviceHeight)];
    selectBoostsScreen.delegate = self;
    [selectBoostsScreen sendOpponentIndex:opponentIndex];
    [self.view addSubview:selectBoostsScreen];
    [selectBoostsScreen setEasingFunction:BounceEaseOut forKeyPath:@"frame"];
    [self animateView:selectBoostsScreen];
    
    [[AudioPlayer sharedManager] PlayViewOpenClose:1.0];
    
    if (showTutorial) {
        selectBoostsScreen.showTutorial = YES;
    }
}

- (void)hideSelectBoostsScreen
{
    [animations animateUIViewYaxisHide:selectBoostsScreen];
    
    [[AudioPlayer sharedManager] PlayViewOpenClose:1.0];
}

- (void)boostsAnimationFinished
{
    NSLog(@"Boosts Screen Animation Finished!");
    [self clearScreen:selectBoostsScreen];
}

- (void)showBattleScreen
{
    battleScreen = [[BattleScreen alloc] initWithFrame:CGRectMake(0, 0, deviceTypes.deviceWidth, deviceTypes.deviceHeight)];
    battleScreen.delegate = self;
    [self.view addSubview:battleScreen];
    
    [self clearScreen:currentView];
    currentView = battleScreen;
    
    if (currentlyPlayingMusic != nil) {
        //[[AudioPlayer sharedManager] StopMusic:currentlyPlayingMusic];
    }
    
    [[AudioPlayer sharedManager] PlayMusic:constants.MUSICBATTLESCREEN atVolume:1.0];
    currentlyPlayingMusic = constants.MUSICBATTLESCREEN;
    
    if (mainMenu) {
        [self clearScreen:mainMenu];
    }
    
    if (showTutorial) {
        battleScreen.showTutorial = YES;
    }
}

- (void)showGameMenu
{
    NSLog(@"Menu button pressed.");
    gameMenu = [[GameMenu alloc] initWithFrame:CGRectMake(0, -deviceTypes.deviceHeight - 100, deviceTypes.deviceWidth, gameMenu.frame.size.height)];
    gameMenu.delegate = self;
    [gameMenu setEasingFunction:BounceEaseOut forKeyPath:@"frame"];
    [self.view addSubview:gameMenu];
    [self animateView:gameMenu];
}

- (void)hideGameMenu
{
    [UIView animateWithDuration:1.0 animations:^{
        
        gameMenu.frame = CGRectMake(0, -deviceTypes.deviceHeight - 100, deviceTypes.deviceWidth, deviceTypes.deviceHeight);
        [gameMenu setEasingFunction:BounceEaseOut forKeyPath:@"frame"];
    }];
}

- (void)quitMatch
{
    [gameMenu removeFromSuperview];
    gameMenu = nil;
    [battleScreen removeFromSuperview];
    battleScreen = nil;
    [self showMainMenu];
}

- (void)showStoreScreen
{
    storeScreen = [[StoreScreen alloc] initWithFrame:CGRectMake(0, -deviceTypes.deviceHeight - 50, deviceTypes.deviceWidth, deviceTypes.deviceHeight)];
    storeScreen.delegate = self;
    [self.view addSubview:storeScreen];
    [storeScreen setEasingFunction:BounceEaseOut forKeyPath:@"frame"];
    
    [self animateView:storeScreen];
    
    //[self clearScreen:currentView];
    //currentView = storeScreen;
}

- (void)hideStoreScreen
{
    [UIView animateWithDuration:1.0 animations:^{
        
        storeScreen.frame = CGRectMake(0, -deviceTypes.deviceHeight - 100, deviceTypes.deviceWidth, deviceTypes.deviceHeight);
        [storeScreen setEasingFunction:BounceEaseOut forKeyPath:@"frame"];
    }];
}

- (void)battleEndedPlayerWins
{
    [battleScreen startAnimationOutPlayerWon:YES];
    playerWon = YES;
    NSLog(@"Player Wins!");
}

- (void)battleEndedPlayerLost
{
    [battleScreen startAnimationOutPlayerWon:NO];
    playerWon = NO;
    NSLog(@"Player Loses!");
}

- (void)showResultsScreen
{
    battleResultsScreen = [[BattleResultsScreen alloc] initWithFrame:CGRectMake(0, -deviceTypes.deviceHeight, deviceTypes.deviceWidth, deviceTypes.deviceHeight)];
    battleResultsScreen.delegate = self;
    
    [self.view addSubview:battleResultsScreen];
    [battleResultsScreen setEasingFunction:ElasticEaseOut forKeyPath:@"frame"];
    [self animateView:battleResultsScreen];
    
    if (currentlyPlayingMusic != nil) {
        //[[AudioPlayer sharedManager] StopMusic:currentlyPlayingMusic];
    }
    
    if (playerWon) {
        [[AudioPlayer sharedManager] PlayMusic:constants.MUSICBATTLEWON atVolume:0.6];
        currentlyPlayingMusic = constants.MUSICBATTLEWON;
    } else {
        [[AudioPlayer sharedManager] PlayMusic:constants.MUSICBATTLELOST atVolume:0.6];
        currentlyPlayingMusic = constants.MUSICBATTLELOST;
    }
    
    [[AudioPlayer sharedManager] PlayViewOpenClose:1.0];
    
}

- (void)animateView:(UIView *)view
{
    [UIView animateWithDuration:1.0 animations:^{
        
        view.frame = CGRectMake(0, 0, deviceTypes.deviceWidth, deviceTypes.deviceHeight);
        
    }];
}

- (void)showBoostUnlockedScreen:(int)level
{
    [battleResultsScreen removeFromSuperview];
    battleResultsScreen = nil;
    boostUnlockedScreen = [[BoostUnlockedScreen alloc] initWithFrame:CGRectMake(0, -deviceTypes.deviceHeight - 50, deviceTypes.deviceWidth, deviceTypes.deviceHeight)];
    boostUnlockedScreen.delegate = self;
    if (level == 2) {
        [boostUnlockedScreen createScreenWithBoostImage:[[boostsData getBoostsDataForBoostIndex:2] objectForKey:constants.BOOSTIMAGELARGE] andBoostText:[[boostsData getBoostsDataForBoostIndex:2] objectForKey:constants.BOOSTTYPE]];
    } else if (level == 3) {
        [boostUnlockedScreen createScreenWithBoostImage:[[boostsData getBoostsDataForBoostIndex:3] objectForKey:constants.BOOSTIMAGELARGE] andBoostText:[[boostsData getBoostsDataForBoostIndex:3] objectForKey:constants.BOOSTTYPE]];
    } else if (level == 4) {
        [boostUnlockedScreen createScreenWithBoostImage:[[boostsData getBoostsDataForBoostIndex:4] objectForKey:constants.BOOSTIMAGELARGE] andBoostText:[[boostsData getBoostsDataForBoostIndex:4] objectForKey:constants.BOOSTTYPE]];
    }
    
    [self.view addSubview:boostUnlockedScreen];
    [boostUnlockedScreen setEasingFunction:ElasticEaseOut forKeyPath:@"frame"];
    [self animateView:boostUnlockedScreen];
    //[[AudioPlayer sharedManager] StopMusic:currentlyPlayingMusic];
    
    // Play a sound here.
    
}

- (void)closeBoostUnlockedScreen
{
    [self showMainMenu];
    if (boostUnlockedScreen) {
        [boostUnlockedScreen removeFromSuperview];
        boostUnlockedScreen = nil;
    }
}

- (void)closeBattleResultsScreen
{
    //[self stopAllMusic];
    [self showMainMenu];
    if (battleResultsScreen) {
        [battleResultsScreen removeFromSuperview];
        battleResultsScreen = nil;
    }
    if (battleScreen) {
        [battleScreen removeFromSuperview];
        battleScreen = nil;
    }
    
    [[AudioPlayer sharedManager] PlayViewOpenClose:1.0];
}

- (NSString *)getCurrentlyPlayingMusic
{
    return currentlyPlayingMusic;
}

- (void)setCurrentlyPlayingMusic:(NSString *)music
{
    NSLog(@"setCurrentlyPlayingMusic");
    currentlyPlayingMusic = music;
}

@end
