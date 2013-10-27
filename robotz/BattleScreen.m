//
//  BattleScreen.m
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "BattleScreen.h"

@implementation BattleScreen

@synthesize delegate, showTutorial;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        showTutorial = NO;
        inAppPurchaseManager = [[InAppPurchaseManager alloc] init];
        inAppPurchaseManager.delegateBS = self;
        tutorialImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"tutorialFirstRobot.png"], [UIImage imageNamed:@"tutorial7.png"], nil];
        animatingMessage = NO;
        constants = [[Constants alloc] init];
        animations = [[AnimationsClass alloc] init];
        deviceTypes = [[DeviceTypes alloc] init];
        BattleManager *bm = [BattleManager sharedManager];
        bm.delegateBattleScreen = self;
        [self displayLoadingScreen];
        [self createTimer:@selector(removeLoadingScreen:) withDelay:0.5];
    }
    return self;
}

- (void)playerAttacked
{
    //[animations shake:puzzleModule]; show an attack animation of some sort.
}

- (void)displayLoadingScreen
{
    UIImage *bgImage = [UIImage imageNamed:@"gameScreenBackground.png"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0, 0, deviceTypes.deviceWidth, bgImage.size.height);
    [self addSubview:bgImageView];
    
//    loadingScreen = [[LoadingScreen alloc] init];
//    [loadingScreen setFrame:CGRectMake(0, 0, deviceTypes.deviceWidth, deviceTypes.deviceHeight)];  /// Fix this to use the display class to work!!!!!!!!
//    [self addSubview:loadingScreen];
}

- (void)createTimer:(SEL)selector withDelay:(float)delay
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: delay];
    NSTimer *animationTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:selector userInfo:nil repeats:NO];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: animationTimer forMode: NSDefaultRunLoopMode];
}

- (void)removeLoadingScreen:(NSTimer *) timer
{
    [timer invalidate];
    timer = nil;
    [self drawPage];
    
    if (showTutorial) {
        [self startTutorial];
    }
    //[loadingScreen removeFromSuperview];
}

- (void)drawPage
{
    puzzleModule = [[PuzzleModule alloc] init];
    puzzleModule.delegate = self;
    puzzleModule.frame = CGRectMake(0, deviceTypes.deviceHeight + 50, deviceTypes.deviceWidth, deviceTypes.deviceHeight - 215);
    [self addSubview:puzzleModule];
    [puzzleModule setEasingFunction:BounceEaseOut forKeyPath:@"frame"];
    
    opponentBattleModule = [[OpponentBattleModule alloc] init];
    opponentBattleModule.frame = CGRectMake(0, -370, 320, 480 - puzzleModule.frame.size.height);
    [self addSubview:opponentBattleModule];
    [opponentBattleModule setEasingFunction:BounceEaseOut forKeyPath:@"frame"];
    
    hud = [[PlayerHudModule alloc] init];
    hud.delegate = self;
    hud.frame = CGRectMake(0, -opponentBattleModule.frame.size.height - 50, 320, 215);
    [self addSubview:hud];
    [hud setEasingFunction:BounceEaseOut forKeyPath:@"frame"];
    
    [self startAnimationsIn];
}

- (void)startAnimationsIn
{
    [UIView animateWithDuration:1.0 animations:^{
        
        puzzleModule.frame = CGRectMake(0, 215, deviceTypes.deviceWidth, deviceTypes.deviceHeight - 215);
        opponentBattleModule.frame = CGRectMake(0, 0, 320, 480 - puzzleModule.frame.size.height);
        hud.frame = CGRectMake(0, 0, 320, 215);
        [puzzleModule setEasingFunction:BounceEaseOut forKeyPath:@"frame"];
        [opponentBattleModule setEasingFunction:BounceEaseOut forKeyPath:@"frame"];
        [hud setEasingFunction:BounceEaseOut forKeyPath:@"frame"];
        
    }];
    
    
}

- (void)startAnimationOutPlayerWon:(BOOL)won
{
    playerWon = won;
    if (playerWon) {
        [UIView animateWithDuration:1.0 animations:^{
            
            puzzleModule.frame = CGRectMake(0, deviceTypes.deviceHeight + 50, deviceTypes.deviceWidth, deviceTypes.deviceHeight - 215);
            opponentBattleModule.frame = CGRectMake(0, -320 - 50, 320, 480 - puzzleModule.frame.size.height);
            hud.frame = CGRectMake(0, -opponentBattleModule.frame.size.height - hud.frame.size.height, 320, 215);
            
        }];
    }
    
    [self displayResultSign];
}

- (void)displayResultSign
{
    UIImage *resultSignImage;
    if (playerWon) {
        resultSignImage = [UIImage imageNamed:@"gameScreenYouWonOverlay.png"];
        resultGraphic = youWonGraphic = [[UIImageView alloc] initWithImage:resultSignImage];
        
        resultGraphic.frame = CGRectMake(0, -resultSignImage.size.height - 50, resultSignImage.size.width, resultSignImage.size.height);
        [self addSubview:resultGraphic];
        [resultGraphic setEasingFunction:ElasticEaseOut forKeyPath:@"frame"];
        
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 1.0];
        NSTimer *animationTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(animateResultSign:) userInfo:resultGraphic repeats:NO];
        NSRunLoop *runner = [NSRunLoop currentRunLoop];
        [runner addTimer: animationTimer forMode: NSDefaultRunLoopMode];
    } else {
        bgAlpha = [[UIView alloc] initWithFrame:CGRectMake(0, 0, deviceTypes.deviceWidth, deviceTypes.deviceHeight)];
        [bgAlpha setBackgroundColor:[UIColor blackColor]];
        bgAlpha.alpha = 0.7;
        [self addSubview:bgAlpha];
        
        if ([[SaveLoadDataDevice sharedManager] getResurrections] > 0) {
            resultSignImage = [UIImage imageNamed:@"useResurrectionPopup.png"];
            resultGraphic = getRepairsGraphic = [[UIImageView alloc] initWithImage:resultSignImage];
            
            resultView = [[UIView alloc] initWithFrame:CGRectMake(0, -resultSignImage.size.height - 50, resultSignImage.size.width, resultSignImage.size.height)];
            [self addSubview:resultView];
            
            resultGraphic.frame= CGRectMake(0, 0, resultSignImage.size.width, resultSignImage.size.height);
            [resultView addSubview:resultGraphic];
            [resultView setEasingFunction:ElasticEaseOut forKeyPath:@"frame"];
            
            UIImage *endGameImage = [UIImage imageNamed:@"endMatchButton.png"];
            UIButton *endGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [endGameButton setImage:endGameImage forState:UIControlStateNormal];
            [endGameButton addTarget:self action:@selector(endMatch:) forControlEvents:UIControlEventTouchUpInside];
            endGameButton.frame = CGRectMake(25, 130, endGameImage.size.width, endGameImage.size.height);
            [resultView addSubview:endGameButton];
            
            UIImage *keepPlayingImage = [UIImage imageNamed:@"keepPlayingButton.png"];
            keepPlayingButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [keepPlayingButton setImage:keepPlayingImage forState:UIControlStateNormal];
            [keepPlayingButton addTarget:self action:@selector(keepPlayingUseResurrection:) forControlEvents:UIControlEventTouchUpInside];
            keepPlayingButton.frame = CGRectMake(175, 130, keepPlayingImage.size.width, keepPlayingImage.size.height);
            [resultView addSubview:keepPlayingButton];
            
            UILabel *numResurrectionsLabelShadow = [[UILabel alloc] initWithFrame:CGRectMake(119, 21, 30, 20)];
            numResurrectionsLabelShadow.font = [UIFont boldSystemFontOfSize:21];
            numResurrectionsLabelShadow.textColor = [UIColor blackColor];
            numResurrectionsLabelShadow.text = [NSString stringWithFormat:@"%d", [[SaveLoadDataDevice sharedManager] getResurrections]];
            [resultView addSubview:numResurrectionsLabelShadow];
            
            UILabel *numResurrectionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(118, 20, 30, 20)];
            numResurrectionsLabel.font = [UIFont boldSystemFontOfSize:21];
            numResurrectionsLabel.textColor = [UIColor greenColor];
            numResurrectionsLabel.text = [NSString stringWithFormat:@"%d", [[SaveLoadDataDevice sharedManager] getResurrections]];
            [resultView addSubview:numResurrectionsLabel];
            
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.0];
            NSTimer *animationTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(animatePurchaseRepairs:) userInfo:resultView repeats:NO];
            NSRunLoop *runner = [NSRunLoop currentRunLoop];
            [runner addTimer: animationTimer forMode: NSDefaultRunLoopMode];
        } else {
            resultSignImage = [UIImage imageNamed:@"purchaseThreeRepairs.png"];
            [inAppPurchaseManager loadStore];
            [inAppPurchaseManager canMakePurchases];
            resultGraphic = getRepairsGraphic = [[UIImageView alloc] initWithImage:resultSignImage];
            
            resultView = [[UIView alloc] initWithFrame:CGRectMake(0, -resultSignImage.size.height - 50, resultSignImage.size.width, resultSignImage.size.height)];
            [self addSubview:resultView];
            
            resultGraphic.frame= CGRectMake(0, 0, resultSignImage.size.width, resultSignImage.size.height);
            [resultView addSubview:resultGraphic];
            [resultView setEasingFunction:ElasticEaseOut forKeyPath:@"frame"];
            
            UIImage *endGameImage = [UIImage imageNamed:@"endMatchButton.png"];
            UIButton *endGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [endGameButton setImage:endGameImage forState:UIControlStateNormal];
            [endGameButton addTarget:self action:@selector(endMatch:) forControlEvents:UIControlEventTouchUpInside];
            endGameButton.frame = CGRectMake(25, 130, endGameImage.size.width, endGameImage.size.height);
            [resultView addSubview:endGameButton];
            
            UIImage *keepPlayingImage = [UIImage imageNamed:@"keepPlayingButton.png"];
            keepPlayingButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [keepPlayingButton setImage:keepPlayingImage forState:UIControlStateNormal];
            [keepPlayingButton addTarget:self action:@selector(keepPlayingBuyRessurections:) forControlEvents:UIControlEventTouchUpInside];
            keepPlayingButton.frame = CGRectMake(175, 130, keepPlayingImage.size.width, keepPlayingImage.size.height);
            [resultView addSubview:keepPlayingButton];
            
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.0];
            NSTimer *animationTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(animatePurchaseRepairs:) userInfo:resultView repeats:NO];
            NSRunLoop *runner = [NSRunLoop currentRunLoop];
            [runner addTimer: animationTimer forMode: NSDefaultRunLoopMode];
        }
        
    }
    BattleManager *bm = [BattleManager sharedManager];
    bm.delegateHud = hud;
    
}

- (void)threeResurrectionsPurchased
{
    [UIView animateWithDuration:1.0 animations:^{
        
        resultView.frame = CGRectMake(0, deviceTypes.deviceHeight + 50, resultView.frame.size.width, resultView.frame.size.height);
        
    }];
    
    [bgAlpha removeFromSuperview];
    [self displayResultSign];
    NSLog(@"threeResurrectionsPurchased");
}

- (void)endMatch:(id)sender
{
    [UIView animateWithDuration:1.0 animations:^{
        
        resultView.frame = CGRectMake(0, deviceTypes.deviceHeight + 50, resultView.frame.size.width, resultView.frame.size.height);
        
    }];
    [self getBattleResults:[[NSTimer alloc] init]];
}

- (void)keepPlayingBuyRessurections:(id)sender
{
    [inAppPurchaseManager purchaseThreeResurrections];
    paymentProgressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    paymentProgressView.center = CGPointMake(keepPlayingButton.frame.origin.x + 60, keepPlayingButton.frame.origin.y + 14);
    [paymentProgressView startAnimating];
    [resultView addSubview:paymentProgressView];
    paymentProgressLabel = [[UILabel alloc] initWithFrame:CGRectMake(keepPlayingButton.frame.origin.x - 6, keepPlayingButton.frame.origin.y - 1, 150, 30)];
    paymentProgressLabel.font = [UIFont boldSystemFontOfSize:12.0];
    paymentProgressLabel.textColor = [UIColor darkGrayColor];
    paymentProgressLabel.text = @"Contacting App Store";
    [resultView addSubview:paymentProgressLabel];
    [keepPlayingButton removeFromSuperview];
    keepPlayingButton = nil;
    NSLog(@"keepPlayingBuyRessurections");
}

- (void)transactionFailed
{
    [paymentProgressView removeFromSuperview];
    paymentProgressView = nil;
    [paymentProgressLabel removeFromSuperview];
    paymentProgressLabel = nil;

    UIImage *keepPlayingImage = [UIImage imageNamed:@"keepPlayingButton.png"];
    keepPlayingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [keepPlayingButton setImage:keepPlayingImage forState:UIControlStateNormal];
    [keepPlayingButton addTarget:self action:@selector(keepPlayingBuyRessurections:) forControlEvents:UIControlEventTouchUpInside];
    keepPlayingButton.frame = CGRectMake(175, 130, keepPlayingImage.size.width, keepPlayingImage.size.height);
    [resultView addSubview:keepPlayingButton];}

- (void)keepPlayingUseResurrection:(id)sender
{
    BattleManager *bm = [BattleManager sharedManager];
    bm.playerHasResurrection = YES;
    [bm playerUsesPurchasedResurrection];
    [[SaveLoadDataDevice sharedManager] useResurrection];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        resultView.frame = CGRectMake(0, deviceTypes.deviceHeight + 50, resultView.frame.size.width, resultView.frame.size.height);
        
    }];
    
    [bgAlpha removeFromSuperview];
    NSLog(@"keepPlayingUseResurrection");
}

- (void)animatePurchaseRepairs:(NSTimer *)timer
{
    UIImageView *view = [timer userInfo];
    [UIView animateWithDuration:1.0 animations:^{
        
        view.frame = CGRectMake(0, deviceTypes.deviceHeight / 2 - view.frame.size.height / 2, deviceTypes.deviceWidth, view.frame.size.height);
        [view setEasingFunction:ElasticEaseOut forKeyPath:@"frame"];
        
    }];
}

- (void)animateResultSign:(NSTimer *)timer
{
    UIImageView *view = [timer userInfo];
    [UIView animateWithDuration:1.0 animations:^{
        
        view.frame = CGRectMake(0, deviceTypes.deviceHeight / 2 - view.frame.size.height / 2, deviceTypes.deviceWidth, view.frame.size.height);
        
    }];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 2.0];
    NSTimer *getResultsTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(getBattleResults:) userInfo:nil repeats:NO];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: getResultsTimer forMode: NSDefaultRunLoopMode];
}

- (void)getBattleResults:(NSTimer *)timer
{
    resultGraphic.frame = CGRectMake(0, deviceTypes.deviceHeight + 50, resultGraphic.frame.size.width, resultGraphic.frame.size.height);
    
    PlayerData *pd = [PlayerData sharedManager];
    NSLog(@"players level at end of battle : %d", [[[pd getRobotData] objectForKey:constants.PLAYERSLEVEL] intValue]);
    
    [delegate showResultsScreen];
}

- (void)showTheGameMenu
{
    [delegate showGameMenu];
}

- (void)displayEncouragingMessage:(NSString *)message
{
    if (animatingMessage) {
        return;
    }
    NSLog(@"displayEncouragingMessage : %@", message);
    EncouragingWords *ew = [[EncouragingWords alloc] init];
    [ew displayWithMessage:message];
    ew.frame = CGRectMake(deviceTypes.deviceWidth / 2 - ew.frame.size.width / 2, deviceTypes.deviceHeight / 2 - ew.frame.size.height / 2, ew.frame.size.width, ew.frame.size.height);
    ew.alpha = 0.0;
    [self addSubview:ew];
    [animations animateEncouragingText:ew];
    
    if ([message isEqualToString:constants.MESSAGEAWESOME]) {
        [[AudioPlayer sharedManager] playAwesomeVoiceAtVolume:0.7];
    } else if ([message isEqualToString:constants.MESSAGEGREAT]) {
        [[AudioPlayer sharedManager] playGreatVoiceAtVolume:0.7];
    } else if ([message isEqualToString:constants.MESSAGENICE]) {
        [[AudioPlayer sharedManager] playNiceVoiceAtVolume:0.7];
    }
    animatingMessage = YES;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 2.0];
    resetMessageTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(resetMessageAnimation:) userInfo:nil repeats:NO];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: resetMessageTimer forMode: NSDefaultRunLoopMode];
}

- (void)noMoreMovesShufflingWithMessage:(NSString *)message
{
    if (noMoreMatchesGraphic) {
        return;
    }
    UIImage *image = [UIImage imageNamed:message];
    noMoreMatchesGraphic = [[UIImageView alloc] initWithImage:image];
    noMoreMatchesGraphic.frame = CGRectMake(deviceTypes.deviceWidth / 2 - image.size.width / 2, deviceTypes.deviceHeight / 2 - image.size.height / 2, image.size.width, image.size.height);
    noMoreMatchesGraphic.alpha = 0.0;
    [self addSubview:noMoreMatchesGraphic];
    [animations fadeInView:noMoreMatchesGraphic];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 3.0];
    NSTimer *cancelMessageTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(noMoreMovesShufflingRemoveMessage:) userInfo:nil repeats:NO];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: cancelMessageTimer forMode: NSDefaultRunLoopMode];
    NSLog(@"show no more moves message");
}

- (void)noMoreMovesShufflingRemoveMessage:(NSTimer *)timer
{
    [timer invalidate];
    timer = nil;
    if (!noMoreMatchesGraphic) {
        return;
    }
    [animations fadeOutView:noMoreMatchesGraphic];
    NSLog(@"remove no more moves message");
}

- (void)resetMessageAnimation:(NSTimer *)timer
{
    [resetMessageTimer invalidate];
    resetMessageTimer = nil;
    animatingMessage = NO;
}

- (void)startTutorial
{
    UIImage *swipeImage = [UIImage imageNamed:@"swipeToChoose.png"];
    swipeToChooseView = [[UIImageView alloc] initWithImage:swipeImage];
    swipeToChooseView.frame = CGRectMake(deviceTypes.deviceWidth / 2 - swipeImage.size.width / 2, 100, swipeImage.size.width, swipeImage.size.height);
    swipeToChooseView.alpha = 0.0;
    [self addSubview:swipeToChooseView];
    
    blackBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, deviceTypes.deviceWidth, deviceTypes.deviceHeight)];
    blackBG.alpha = 0.7;
    blackBG.backgroundColor = [UIColor blackColor];
    [self addSubview:blackBG];
    
    /***************************************  Tutorial screen 1 ***************************************/
    
    tut1ImageView = [[UIImageView alloc] initWithImage:[tutorialImages objectAtIndex:0]];
    tut1ImageView.frame = CGRectMake(0, 0, ((UIImage*)[tutorialImages objectAtIndex:0]).size.width, ((UIImage*)[tutorialImages objectAtIndex:0]).size.height);
    
    tut1Container = [[UIView alloc] initWithFrame:CGRectMake(deviceTypes.deviceWidth / 2 - tut1ImageView.frame.size.width / 2, deviceTypes.deviceHeight, ((UIImage*)[tutorialImages objectAtIndex:0]).size.width, ((UIImage*)[tutorialImages objectAtIndex:0]).size.height + 50)];
    
    UIImage *buttonImage = [UIImage imageNamed:@"checkButton.png"];
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setImage:buttonImage forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(closeTutorialScreen1:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.frame = CGRectMake(deviceTypes.deviceWidth - buttonImage.size.width - 15, tut1ImageView.frame.size.height - 50, buttonImage.size.width, buttonImage.size.height);
    
    [self addSubview:tut1Container];
    [tut1Container addSubview:tut1ImageView];
    [tut1Container addSubview:nextButton];
    [tut1Container setEasingFunction:ExponentialEaseOut forKeyPath:@"frame"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.5];
    NSTimer *animTut1Timer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(displayTutorialScreen1:) userInfo:nil repeats:NO];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: animTut1Timer forMode: NSDefaultRunLoopMode];
    date = nil;
    runner = nil;
    
    /***************************************  Tutorial screen 2 ***************************************/
    
    tut2ImageView = [[UIImageView alloc] initWithImage:[tutorialImages objectAtIndex:1]];
    tut2ImageView.frame = CGRectMake(0, 0, ((UIImage*)[tutorialImages objectAtIndex:1]).size.width, ((UIImage*)[tutorialImages objectAtIndex:1]).size.height);
    
    tut2Container = [[UIView alloc] initWithFrame:CGRectMake(deviceTypes.deviceWidth / 2 - tut2ImageView.frame.size.width / 2, deviceTypes.deviceHeight, ((UIImage*)[tutorialImages objectAtIndex:1]).size.width, ((UIImage*)[tutorialImages objectAtIndex:1]).size.height + 50)];
    
    nextButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton2 setImage:buttonImage forState:UIControlStateNormal];
    [nextButton2 addTarget:self action:@selector(closeTutorialScreen3:) forControlEvents:UIControlEventTouchUpInside];
    nextButton2.frame = CGRectMake(deviceTypes.deviceWidth - buttonImage.size.width - 15, tut2ImageView.frame.size.height - 50, buttonImage.size.width, buttonImage.size.height);
    
    [self addSubview:tut2Container];
    [tut2Container addSubview:tut2ImageView];
    [tut2Container addSubview:nextButton2];
    [tut2Container setEasingFunction:ExponentialEaseOut forKeyPath:@"frame"];
    
    /***************************************  Tutorial screen 3 ***************************************/
    
//    tut3ImageView = [[UIImageView alloc] initWithImage:[tutorialImages objectAtIndex:2]];
//    tut3ImageView.frame = CGRectMake(0, 0, ((UIImage*)[tutorialImages objectAtIndex:2]).size.width, ((UIImage*)[tutorialImages objectAtIndex:2]).size.height);
//    
    tut3Container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, deviceTypes.deviceWidth, deviceTypes.deviceHeight)];
//
//    nextButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [nextButton3 setImage:buttonImage forState:UIControlStateNormal];
//    [nextButton3 addTarget:self action:@selector(closeTutorialScreen3:) forControlEvents:UIControlEventTouchUpInside];
//    nextButton3.frame = CGRectMake(deviceTypes.deviceWidth - buttonImage.size.width - 15, tut3ImageView.frame.size.height - 50, buttonImage.size.width, buttonImage.size.height);
//
//    [tut3Container addSubview:tut3ImageView];
//    [tut3Container addSubview:nextButton3];
//    [tut3Container setEasingFunction:ExponentialEaseOut forKeyPath:@"frame"];
    
    /***************************************  Tutorial screen 3 ***************************************/
    UIImage *tutOverlayImage = [UIImage imageNamed:@"gameViewTutorialOverlay.png"];
    tutOverlayGraphic = [[UIImageView alloc] initWithImage:tutOverlayImage];
    tutOverlayGraphic.frame = CGRectMake(0, 0, deviceTypes.deviceWidth, tutOverlayImage.size.height);
    tut3Container.alpha = 0.0;
    [tut3Container addSubview:tutOverlayGraphic];
    
    UIImage *closeButtonImage = [UIImage imageNamed:@"closeButtonSettings.png"];
    UIButton *closeButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:closeButtonImage forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeOverlay:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.frame = CGRectMake(deviceTypes.deviceWidth / 2 - closeButtonImage.size.width / 2, deviceTypes.deviceHeight - closeButtonImage.size.height - 20, closeButtonImage.size.width, closeButtonImage.size.height);
    [tut3Container addSubview:closeButton];
    
}

- (void)closeOverlay:(int)sender
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.0];
    NSTimer *closeOverlayTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(fadeOutOverlay:) userInfo:nil repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: closeOverlayTimer forMode: NSDefaultRunLoopMode];
    date = nil;
    runner = nil;
}

- (void)fadeOutOverlay:(NSTimer *)timer
{
    tut3Container.alpha -= 0.05;
    if (tut3Container.alpha <= 0.0) {
        [tut3Container removeFromSuperview];
        tut3Container = nil;
        [timer invalidate];
        timer = nil;
    }
}

- (void)displayTutorialScreen1:(NSTimer *)timer
{
    NSLog(@"displayTutorialScreen1");
    [UIView animateWithDuration:0.5 animations:^{
        
        tut1Container.frame = CGRectMake(deviceTypes.deviceWidth / 2 - tut1ImageView.frame.size.width / 2, deviceTypes.deviceHeight / 2 - ((UIImage*)[tutorialImages objectAtIndex:0]).size.height / 2, ((UIImage*)[tutorialImages objectAtIndex:0]).size.width, ((UIImage*)[tutorialImages objectAtIndex:0]).size.height + 50);
        [tut1Container setEasingFunction:ExponentialEaseOut forKeyPath:@"frame"];
    }];
    
    [tut1Container setEasingFunction:ExponentialEaseIn forKeyPath:@"frame"];
    
    [timer invalidate];
    timer = nil;
}

- (void)closeTutorialScreen1:(id)sender
{
    NSLog(@"closeTutorialScreen1");
    [UIView animateWithDuration:0.5 animations:^{
        
        tut1Container.frame = CGRectMake(deviceTypes.deviceWidth / 2 - tut1ImageView.frame.size.width / 2, deviceTypes.deviceHeight, tut1ImageView.frame.size.width, tut1ImageView.frame.size.height);
        [tut1Container setEasingFunction:ExponentialEaseOut forKeyPath:@"frame"];
    }];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.5];
    NSTimer *animTut2Timer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(displayTutorialScreen2:) userInfo:nil repeats:NO];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: animTut2Timer forMode: NSDefaultRunLoopMode];
    date = nil;
    runner = nil;
}

- (void)displayTutorialScreen2:(NSTimer *)timer
{
    NSLog(@"displayTutorialScreen2");
    [UIView animateWithDuration:0.5 animations:^{
        
        tut2Container.frame = CGRectMake(deviceTypes.deviceWidth / 2 - tut2ImageView.frame.size.width / 2, deviceTypes.deviceHeight / 2 - ((UIImage*)[tutorialImages objectAtIndex:1]).size.height / 2, ((UIImage*)[tutorialImages objectAtIndex:1]).size.width, ((UIImage*)[tutorialImages objectAtIndex:1]).size.height + 50);
    }];
    
    [tut2Container setEasingFunction:ExponentialEaseIn forKeyPath:@"frame"];
    
    [timer invalidate];
    timer = nil;
}

- (void)closeTutorialScreen2:(id)sender
{
    NSLog(@"closeTutorialScreen2");
    [UIView animateWithDuration:0.5 animations:^{
        
        tut2Container.frame = CGRectMake(deviceTypes.deviceWidth / 2 - tut2ImageView.frame.size.width / 2, deviceTypes.deviceHeight, tut2ImageView.frame.size.width, tut2ImageView.frame.size.height);
        [tut2Container setEasingFunction:ExponentialEaseOut forKeyPath:@"frame"];
    }];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.5];
    NSTimer *animTut3Timer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(displayTutorialScreen3:) userInfo:nil repeats:NO];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: animTut3Timer forMode: NSDefaultRunLoopMode];
    date = nil;
    runner = nil;
}

- (void)displayTutorialScreen3:(NSTimer *)timer
{
    NSLog(@"displayTutorialScreen3");
    [UIView animateWithDuration:0.5 animations:^{
        
        tut3Container.frame = CGRectMake(deviceTypes.deviceWidth / 2 - tut3ImageView.frame.size.width / 2, deviceTypes.deviceHeight / 2 - ((UIImage*)[tutorialImages objectAtIndex:1]).size.height / 2, ((UIImage*)[tutorialImages objectAtIndex:2]).size.width, ((UIImage*)[tutorialImages objectAtIndex:2]).size.height + 50);
    }];
    
    [tut3Container setEasingFunction:ExponentialEaseIn forKeyPath:@"frame"];
    
    [timer invalidate];
    timer = nil;
    
    swipeToChooseView.alpha = 1.0;
}

- (void)closeTutorialScreen3:(id)sender
{
    NSLog(@"closeTutorialScreen3");
    [UIView animateWithDuration:0.5 animations:^{
        
        tut2Container.frame = CGRectMake(deviceTypes.deviceWidth / 2 - tut2ImageView.frame.size.width / 2, deviceTypes.deviceHeight, tut2ImageView.frame.size.width, tut2ImageView.frame.size.height);
        [tut2Container setEasingFunction:ExponentialEaseOut forKeyPath:@"frame"];
    }];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.0];
    NSTimer *animTut3Timer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(hideBlackBG:) userInfo:nil repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: animTut3Timer forMode: NSDefaultRunLoopMode];
    date = nil;
    runner = nil;
    
    [self addSubview:tut3Container];
    [delegate endTutorial];
}

- (void)hideBlackBG:(NSTimer *)timer
{
    blackBG.alpha -= 0.1;
    tut3Container.alpha += 0.2;
    if (blackBG.alpha <= 0.0) {
        [timer invalidate];
        timer = nil;
        [blackBG removeFromSuperview];
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 1.0];
        NSTimer *swipeImageTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(hideSwipeImage:) userInfo:nil repeats:YES];
        NSRunLoop *runner = [NSRunLoop currentRunLoop];
        [runner addTimer: swipeImageTimer forMode: NSDefaultRunLoopMode];
        date = nil;
        runner = nil;
    }
}

- (void)hideSwipeImage:(NSTimer *)timer
{
    swipeToChooseView.alpha -= 0.1;
    if (swipeToChooseView.alpha <= 0.0) {
        [timer invalidate];
        timer = nil;
        [swipeToChooseView removeFromSuperview];
    }
}

- (void)showUseBoostPopup
{
    //UIImage *
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
