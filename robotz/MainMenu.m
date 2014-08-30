//
//  MainMenu.m
//  robotz
//
//  Created by Jason Elwood on 9/19/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "MainMenu.h"

@implementation MainMenu

@synthesize delegate, showTutorial;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        tickerMessage = [[TickerMessages alloc] init];
        tutorialImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"tutorial4.png"], [UIImage imageNamed:@"tutorial5.png"], [UIImage imageNamed:@"tutorial6.png"], nil];
        showTutorial = NO;
        deviceTypes = [[DeviceTypes alloc] init];
        constants = [[Constants alloc] init];
        animations = [[AnimationsClass alloc] init];
        [self displayLoadingScreen];
        SEL selector = @selector(removeLoadingScreen:);
        [self createTimer:selector withDelay:1.0];
    }
    return self;
}

- (void)createTimer:(SEL)selector withDelay:(float)delay
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: delay];
    NSTimer *animationTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:selector userInfo:nil repeats:NO];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: animationTimer forMode: NSDefaultRunLoopMode];
}

- (void)displayLoadingScreen
{
    loadingScreen = [[LoadingScreen alloc] init];
    [loadingScreen setFrame:CGRectMake(0, 0, deviceTypes.deviceHeight, deviceTypes.deviceHeight)];  /// Fix this to use the display class to work!!!!!!!!
    [self addSubview:loadingScreen];
}

- (void)removeLoadingScreen:(NSTimer *) timer
{
    [timer invalidate];
    timer = nil;
    [self startAnimationSequence];
    [loadingScreen removeFromSuperview];
    
    if (showTutorial) {
        [self startTutorial];
    }
}

- (void)startAnimationSequence
{
    SaveLoadDataDevice *sldd = [SaveLoadDataDevice sharedManager];
    NSMutableDictionary *slddData = [sldd getCharData];
    
    //Create the 2 main views
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, deviceTypes.deviceWidth, deviceTypes.deviceHeight)];
    [self addSubview:topView];
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, deviceTypes.deviceHeight - 265, deviceTypes.deviceWidth, 265)];
    [self addSubview:bottomView];
    
    UIImage *bgImage = [UIImage imageNamed:@"plainBackgroundImage.png"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
    [topView addSubview:bgImageView];
    
    PlayerData *playerData = [PlayerData sharedManager];
    playerDataDict = [[NSMutableDictionary alloc] initWithDictionary:[playerData getRobotData]];
    
    UIImage *charBackgroundImage;
    
    if (deviceTypes.deviceHeight > 480) {
        charBackgroundImage = [UIImage imageNamed:@"background1iPhone5.png"];
    } else {
        charBackgroundImage = [UIImage imageNamed:[playerDataDict objectForKey:constants.BACKGROUNDIMAGE]];
    }
    
    UIImageView *charBackgroundImageView = [[UIImageView alloc] initWithImage:charBackgroundImage];
    
    if (deviceTypes.deviceHeight > 480) {
        charBackgroundImageView.frame = CGRectMake(0, 40, 320, 215 + 88);
    } else {
        charBackgroundImageView.frame = CGRectMake(0, 40, 320, 215);
    }
    
    [topView addSubview:charBackgroundImageView];
    
    UIImage *headerImage = [UIImage imageNamed:@"mainMenuHeader.png"];
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:headerImage];
    headerImageView.frame = CGRectMake(0, 0, headerImage.size.width, headerImage.size.height);
    [topView addSubview:headerImageView];
    
    playerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, deviceTypes.deviceWidth / 1.5, headerImage.size.height - 14)];
    playerNameLabel.text = [[SaveLoadDataDevice sharedManager] getPlayersName]; // get this from the saveddata class!!!!!!
    [playerNameLabel setTextColor:[UIColor whiteColor]];
    [playerNameLabel setFont:[UIFont boldSystemFontOfSize:30.0]];
    playerNameLabel.alpha = 0.5;
    [topView addSubview:playerNameLabel];
    
    playerLevelLabel = [[UILabel alloc] initWithFrame:CGRectMake(deviceTypes.deviceWidth - 85, 0, 80, headerImage.size.height - 14)];
    playerLevelLabel.text = [NSString stringWithFormat:@"Lvl:%d", [[slddData objectForKey:constants.PLAYERSLEVEL] intValue]];
    [playerLevelLabel setTextColor:[UIColor whiteColor]];
    [playerLevelLabel setFont:[UIFont boldSystemFontOfSize:30.0]];
    playerLevelLabel.alpha = 0.5;
    playerLevelLabel.textAlignment = NSTextAlignmentRight;
    [topView addSubview:playerLevelLabel];
    
    UIImage *bottomPanelImage = [UIImage imageNamed:@"mainMenuBackgroundBottom3Button.png"];
    UIImageView *bottomPanelImageView = [[UIImageView alloc] initWithImage:bottomPanelImage];
    bottomPanelImageView.frame = CGRectMake(0, 0, bottomPanelImage.size.width, bottomPanelImage.size.height);
    [bottomView addSubview:bottomPanelImageView];
    
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(deviceTypes.deviceWidth + 50, 20, 630, 20)];
    messageLabel.textColor = [UIColor darkGrayColor];
    [bottomView addSubview:messageLabel];
    messageLabel.text = [tickerMessage getTickerMessage];
    
    UIImage *messagePanel = [UIImage imageNamed:@"mainMenuMessageFrame.png"];
    UIImageView *messagePanelView = [[UIImageView alloc] initWithImage:messagePanel];
    messagePanelView.frame = CGRectMake(0, 0, messagePanel.size.width, messagePanel.size.height);
    [bottomView addSubview:messagePanelView];
    

    // BUTTONS
    UIImage *playButtonImage = [UIImage imageNamed:@"playButtonMain.png"];
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton setImage:playButtonImage forState:0];
    [playButton addTarget:self action:@selector(playButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [playButton setFrame:CGRectMake(13, 125, playButtonImage.size.width, playButtonImage.size.height)];
    [bottomView addSubview:playButton];
    
    /* WORKING ON HEAD TO HEAD FOR A V2 RELEASE */
//    UIImage *headToHeadButtonImage = [UIImage imageNamed:@"headToHeadButton.png"];
//    UIButton *headToHeadButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [headToHeadButton setImage:headToHeadButtonImage forState:0];
//    [headToHeadButton addTarget:self action:@selector(headToHeadButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
//    [headToHeadButton setFrame:CGRectMake(13, 123, headToHeadButtonImage.size.width, headToHeadButtonImage.size.height)];
//    [bottomView addSubview:headToHeadButton];
    
    UIImage *shopButtonImage = [UIImage imageNamed:@"shopButton.png"];
    UIButton *shopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shopButton setImage:shopButtonImage forState:0];
    [shopButton addTarget:self action:@selector(shopButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [shopButton setFrame:CGRectMake(13, 171, shopButtonImage.size.width, shopButtonImage.size.height)];
    [bottomView addSubview:shopButton];
    
    UIImage *settingsButtonImage = [UIImage imageNamed:@"settingsButton.png"];
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsButton setImage:settingsButtonImage forState:0];
    [settingsButton addTarget:self action:@selector(settingsButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [settingsButton setFrame:CGRectMake(13, 217, settingsButtonImage.size.width, settingsButtonImage.size.height)];
    [bottomView addSubview:settingsButton];
    // BUTTONS
    
    UIImage *expBarImage = [UIImage imageNamed:@"expBar.png"];
    UIImageView *expBar = [[UIImageView alloc] initWithImage:expBarImage];
    expBar.frame = CGRectMake(-1, 36, deviceTypes.deviceWidth * ([[[[SaveLoadDataDevice sharedManager] getCharData] objectForKey:constants.CURRENTEXPERIENCE] floatValue] / [[[[SaveLoadDataDevice sharedManager] getCharData] objectForKey:constants.EXPERIENCETOLEVEL] floatValue]), expBarImage.size.height / 2 - 1.5 );
    [self addSubview:expBar];

    SEL selector = @selector(animateRobot:);
    [self createTimer:selector withDelay:0.2];
    [self startTicker];
}

- (void)startTicker
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.0];
    NSTimer *tickerTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(advanceTicker:) userInfo:nil repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: tickerTimer forMode: NSDefaultRunLoopMode];
}

- (void)advanceTicker:(NSTimer *)timer
{
    messageLabel.frame = CGRectMake(messageLabel.frame.origin.x - 1, 20, 630, 20);
    if (messageLabel.frame.origin.x < -630) {
        messageLabel.frame = CGRectMake(deviceTypes.deviceWidth, 20, 630, 20);
        messageLabel.text = [tickerMessage getTickerMessage];
    }
}

- (void)animateRobot:(NSTimer *) timer
{
    [timer invalidate];
    timer = nil;
    
    PlayerData *playerData = [PlayerData sharedManager];
    playerDataDict = [[NSMutableDictionary alloc] initWithDictionary:[playerData getRobotData]];
    UIImage *robotImage = [UIImage imageNamed:[playerDataDict objectForKey:constants.ROBOTIMAGE]];
    UIImageView *robotImageView = [[UIImageView alloc] initWithImage:robotImage];
    
    if (deviceTypes.deviceHeight > 480) {
        robotImageView.frame = CGRectMake(-30, 70, robotImage.size.width * 1.1, robotImage.size.height * 1.1);
    } else {
        robotImageView.frame = CGRectMake(0, 50, robotImage.size.width * 0.8, robotImage.size.height * 0.8);
    }
    
    robotImageView.alpha = 0.0;
    [topView addSubview:robotImageView];
    
    [robotImageView setEasingFunction:BounceEaseOut forKeyPath:@"path"];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        robotImageView.alpha = 1.0;
        
    }];
    
    SEL selector = @selector(animateStats:);
    [self createTimer:selector withDelay:0.2];
}

- (void)animateStats:(NSTimer *) timer
{
    [timer invalidate];
    timer = nil;
    
    PlayerData *playerData = [PlayerData sharedManager];
    playerDataDict = [[NSMutableDictionary alloc] initWithDictionary:[playerData getRobotData]];
    
    UIView *statsContainer = [[UIView alloc] initWithFrame:CGRectMake(150, 70, 150, 150)];
    statsContainer.alpha = 0.0;
    [self addSubview:statsContainer];
    
    charClassLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
    charClassLabel.textAlignment = NSTextAlignmentCenter;
    charClassLabel.textColor = [UIColor whiteColor];
    [charClassLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [statsContainer addSubview:charClassLabel];
    
    attackLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, deviceTypes.deviceWidth / 2 - 5, 20)];
    attackLabel.textAlignment = NSTextAlignmentLeft;
    attackLabel.textColor = [UIColor whiteColor];
    [attackLabel setFont:[UIFont boldSystemFontOfSize:18]];
    attackLabel.text = @"Attack:";
    [statsContainer addSubview:attackLabel];
    
    defenseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, deviceTypes.deviceWidth / 2 - 5, 20)];
    defenseLabel.textAlignment = NSTextAlignmentLeft;
    defenseLabel.textColor = [UIColor whiteColor];
    [defenseLabel setFont:[UIFont boldSystemFontOfSize:18]];
    defenseLabel.text = @"Defense:";
    [statsContainer addSubview:defenseLabel];
    
    repairLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, deviceTypes.deviceWidth / 2 - 5, 20)];
    repairLabel.textAlignment = NSTextAlignmentLeft;
    repairLabel.textColor = [UIColor whiteColor];
    [repairLabel setFont:[UIFont boldSystemFontOfSize:18]];
    repairLabel.text = @"Repair:";
    [statsContainer addSubview:repairLabel];
    
    agilityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 85, deviceTypes.deviceWidth / 2 - 5, 20)];
    agilityLabel.textAlignment = NSTextAlignmentLeft;
    agilityLabel.textColor = [UIColor whiteColor];
    [agilityLabel setFont:[UIFont boldSystemFontOfSize:18]];
    agilityLabel.text = @"Agility:";
    [statsContainer addSubview:agilityLabel];
    
    attackValue = [[UILabel alloc] initWithFrame:CGRectMake(75, 25, 60, 20)];
    attackValue.textAlignment = NSTextAlignmentRight;
    attackValue.textColor = [UIColor greenColor];
    [attackValue setFont:[UIFont boldSystemFontOfSize:18]];
    [statsContainer addSubview:attackValue];
    
    defenseValue = [[UILabel alloc] initWithFrame:CGRectMake(75, 45, 60, 20)];
    defenseValue.textAlignment = NSTextAlignmentRight;
    defenseValue.textColor = [UIColor greenColor];
    [defenseValue setFont:[UIFont boldSystemFontOfSize:18]];
    [statsContainer addSubview:defenseValue];
    
    repairValue = [[UILabel alloc] initWithFrame:CGRectMake(75, 65, 60, 20)];
    repairValue.textAlignment = NSTextAlignmentRight;
    repairValue.textColor = [UIColor greenColor];
    [repairValue setFont:[UIFont boldSystemFontOfSize:18]];
    [statsContainer addSubview:repairValue];
    
    agilityValue = [[UILabel alloc] initWithFrame:CGRectMake(75, 85, 60, 20)];
    agilityValue.textAlignment = NSTextAlignmentRight;
    agilityValue.textColor = [UIColor greenColor];
    [agilityValue setFont:[UIFont boldSystemFontOfSize:18]];
    [statsContainer addSubview:agilityValue];
    
    UIImage *coinsImage = [UIImage imageNamed:@"coinsImage.png"];
    UIImageView *coinsImageView = [[UIImageView alloc] initWithImage:coinsImage];
    coinsImageView.frame = CGRectMake(deviceTypes.deviceWidth - coinsImage.size.width - 6, 46, coinsImage.size.width, coinsImage.size.height);
    [self addSubview:coinsImageView];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[[SaveLoadDataDevice sharedManager] getPlayersCoins]]];
    
    UILabel *coinsLabel = [[UILabel alloc] initWithFrame:CGRectMake(deviceTypes.deviceWidth - coinsImage.size.width - 15 - 200, 43, 200, 20)];
    [coinsLabel setText:formatted];
    coinsLabel.textColor = [UIColor whiteColor];
    coinsLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:coinsLabel];
    
    [self updateCharacterSelectorDetails];
    
    [statsContainer setEasingFunction:BounceEaseOut forKeyPath:@"path"];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        statsContainer.alpha = 1.0;
        
    }];
}

- (void)updateCharacterSelectorDetails
{
    SaveLoadDataDevice *sldd = [SaveLoadDataDevice sharedManager];
    
    [charClassLabel setText:[playerDataDict objectForKey:constants.CLASSNAME]];
    [attackValue setText:[NSString stringWithFormat:@"%d", [[[sldd getCharData] objectForKey:constants.DAMAGE] intValue]]];
    [defenseValue setText:[NSString stringWithFormat:@"%d", [[[sldd getCharData] objectForKey:constants.DEFENSE] intValue]]];
    [repairValue setText:[NSString stringWithFormat:@"%d", [[[sldd getCharData] objectForKey:constants.REPAIR] intValue]]];
    [agilityValue setText:[NSString stringWithFormat:@"%d", [[[sldd getCharData] objectForKey:constants.AGILITY] intValue]]];
}

- (void)playButtonHandler:(id)sender
{
    [[AudioPlayer sharedManager] PlayButtonPressSoundAtVolume:0.1];
    [delegate showLevelMapScreen];
}

- (void)headToHeadButtonHandler:(id)sender
{
    [[AudioPlayer sharedManager] PlayButtonPressSoundAtVolume:0.1];
    //[[GCTurnBasedMatchHelper sharedInstance] authenticateLocalUser];
    //[delegate authenticateUserForMatch];
}

- (void)settingsButtonHandler:(id)sender
{
    [[AudioPlayer sharedManager] PlayButtonPressSoundAtVolume:0.1];
    [delegate showSettingsScreen];
}

- (void)shopButtonHandler:(id)sender
{
    [[AudioPlayer sharedManager] PlayButtonPressSoundAtVolume:0.1];
    [delegate showStoreScreen];
}

- (void)buttonHandlerTemp:(id) sender
{
    //NSLog(@"button pressed.");
}

- (void)startTutorial
{
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
    [nextButton2 addTarget:self action:@selector(closeTutorialScreen2:) forControlEvents:UIControlEventTouchUpInside];
    nextButton2.frame = CGRectMake(deviceTypes.deviceWidth - buttonImage.size.width - 15, tut2ImageView.frame.size.height - 50, buttonImage.size.width, buttonImage.size.height);
    
    [self addSubview:tut2Container];
    [tut2Container addSubview:tut2ImageView];
    [tut2Container addSubview:nextButton2];
    [tut2Container setEasingFunction:ExponentialEaseOut forKeyPath:@"frame"];
    
    /***************************************  Tutorial screen 3 ***************************************/
    
    tut3ImageView = [[UIImageView alloc] initWithImage:[tutorialImages objectAtIndex:2]];
    tut3ImageView.frame = CGRectMake(0, 0, ((UIImage*)[tutorialImages objectAtIndex:2]).size.width, ((UIImage*)[tutorialImages objectAtIndex:2]).size.height);
    
    tut3Container = [[UIView alloc] initWithFrame:CGRectMake(deviceTypes.deviceWidth / 2 - tut3ImageView.frame.size.width / 2, deviceTypes.deviceHeight, ((UIImage*)[tutorialImages objectAtIndex:2]).size.width, ((UIImage*)[tutorialImages objectAtIndex:2]).size.height + 50)];
    
    nextButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton3 setImage:buttonImage forState:UIControlStateNormal];
    [nextButton3 addTarget:self action:@selector(closeTutorialScreen3:) forControlEvents:UIControlEventTouchUpInside];
    nextButton3.frame = CGRectMake(deviceTypes.deviceWidth - buttonImage.size.width - 15, tut3ImageView.frame.size.height - 50, buttonImage.size.width, buttonImage.size.height);
    
    [self addSubview:tut3Container];
    [tut3Container addSubview:tut3ImageView];
    [tut3Container addSubview:nextButton3];
    [tut3Container setEasingFunction:ExponentialEaseOut forKeyPath:@"frame"];
}

- (void)displayTutorialScreen1:(NSTimer *)timer
{
    //NSLog(@"displayTutorialScreen1");
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
    //NSLog(@"closeTutorialScreen1");
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
    //NSLog(@"displayTutorialScreen2");
    [UIView animateWithDuration:0.5 animations:^{
        
        tut2Container.frame = CGRectMake(deviceTypes.deviceWidth / 2 - tut2ImageView.frame.size.width / 2, deviceTypes.deviceHeight / 2 - ((UIImage*)[tutorialImages objectAtIndex:1]).size.height / 2, ((UIImage*)[tutorialImages objectAtIndex:1]).size.width, ((UIImage*)[tutorialImages objectAtIndex:1]).size.height + 50);
    }];
    
    [tut2Container setEasingFunction:ExponentialEaseIn forKeyPath:@"frame"];
    
    [timer invalidate];
    timer = nil;
}

- (void)closeTutorialScreen2:(id)sender
{
    //NSLog(@"closeTutorialScreen2");
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
    //NSLog(@"displayTutorialScreen3");
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
    //NSLog(@"closeTutorialScreen3");
    [UIView animateWithDuration:0.5 animations:^{
        
        tut3Container.frame = CGRectMake(deviceTypes.deviceWidth / 2 - tut3ImageView.frame.size.width / 2, deviceTypes.deviceHeight, tut3ImageView.frame.size.width, tut3ImageView.frame.size.height);
        [tut3Container setEasingFunction:ExponentialEaseOut forKeyPath:@"frame"];
    }];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.0];
    NSTimer *animTut3Timer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(hideBlackBG:) userInfo:nil repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: animTut3Timer forMode: NSDefaultRunLoopMode];
    date = nil;
    runner = nil;
}

- (void)hideBlackBG:(NSTimer *)timer
{
    blackBG.alpha -= 0.1;
    if (blackBG.alpha <= 0.0) {
        [timer invalidate];
        timer = nil;
        [blackBG removeFromSuperview];
    }
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
