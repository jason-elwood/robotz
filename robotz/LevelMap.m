//
//  LevelMap.m
//  robotz
//
//  Created by Jason Elwood on 10/14/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "LevelMap.h"

@implementation LevelMap

@synthesize delegate, showTutorial;

const CGFloat kScrollObjHeight  = 199.0;
const CGFloat kScrollObjWidth   = 280.0;
const NSUInteger kNumImages     = 5;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        tutorialImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"tutorialMercury.png"], [UIImage imageNamed:@"tutorialVenus.png"], [UIImage imageNamed:@"tutorialEarth.png"], [UIImage imageNamed:@"tutorialMars.png"], [UIImage imageNamed:@"tutorialJupiter.png"], [UIImage imageNamed:@"tutorialSaturn.png"], [UIImage imageNamed:@"tutorialUranus.png"], [UIImage imageNamed:@"tutorialNeptune.png"], [UIImage imageNamed:@"tutorialPluto.png"], nil];
        showTutorial = NO;
        isTheCurrentChallenger = YES;
        followingPlanetsLocked = NO;
        constants = [[Constants alloc] init];
        categoriesAndRobots = [[CategoriesAndRobots alloc] init];
        planetsAndRobotsDict = [[NSMutableDictionary alloc] initWithDictionary:categoriesAndRobots.categoriesAndRobotsDictionary];
        deviceTypes = [[DeviceTypes alloc] init];
        [self drawUI];
        [self displayLoadingScreen];
        
        // Start load screen title timer.
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 1.0];
        NSTimer *animationTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(removeLoadingScreen:) userInfo:nil repeats:NO];
        NSRunLoop *runner = [NSRunLoop currentRunLoop];
        [runner addTimer: animationTimer forMode: NSDefaultRunLoopMode];
    }
    return self;
}

- (void)displayLoadingScreen
{
    loadingScreen = [[LoadingScreen alloc] init];
    [loadingScreen setFrame:CGRectMake(0, 0, 320, loadingScreen.frame.size.height)];  /// Fix this to use the display class to work!!!!!!!!
    [self addSubview:loadingScreen];
}

- (void)removeLoadingScreen:(NSTimer *) timer
{
    [timer invalidate];
    timer = nil;
    [loadingScreen removeFromSuperview];
}

/* Draw the basic UI creating the scrollersContainer */
- (void)drawUI
{
    UIImage *bgImage;
    
    if (deviceTypes.deviceHeight > 480) {
        bgImage = [UIImage imageNamed:@"levelMapScreeniPhone5.png"];
    } else {
        bgImage = [UIImage imageNamed:@"levelMapScreeniPhone4.png"];
    }
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0, 0, 320, bgImage.size.height);
    [self addSubview:bgImageView];
    
    scrollersContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, deviceTypes.deviceWidth, deviceTypes.deviceHeight)];
    [self addSubview:scrollersContainer];
    
    //[self drawScrollerAndContent];
    [self drawPlanets];
    
    UIImage *levelMapFrameImage;
    
    if (deviceTypes.deviceHeight > 480) {
        levelMapFrameImage = [UIImage imageNamed:@"levelMapFrame.png"];
    } else {
        levelMapFrameImage = [UIImage imageNamed:@"levelMapFrameSmall.png"];
    }
    
    UIImageView *levelMapFrame = [[UIImageView alloc] initWithImage:levelMapFrameImage];
    levelMapFrame.frame = CGRectMake(0, 0, deviceTypes.deviceWidth, levelMapFrameImage.size.height);
    [self addSubview:levelMapFrame];
    
    UIImage *backButtonImage = [UIImage imageNamed:@"closeButtonSettings.png"];
    backButtonPlanets = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButtonPlanets setImage:backButtonImage forState:UIControlStateNormal];
    backButtonPlanets.frame = CGRectMake(deviceTypes.deviceWidth / 2 - backButtonImage.size.width / 2, deviceTypes.deviceHeight - 35, backButtonImage.size.width, backButtonImage.size.height);
    [backButtonPlanets addTarget:self action:@selector(backButtonPlanetsHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButtonPlanets];
    [backButtonPlanets setEasingFunction:ExponentialEaseInOut forKeyPath:@"frame"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 1.0];
    NSTimer *startTutorialTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(checkForTutorial:) userInfo:nil repeats:NO];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: startTutorialTimer forMode: NSDefaultRunLoopMode];
    date = nil;
    runner = nil;
}

- (void)checkForTutorial:(NSTimer *)timer
{
    //NSLog(@"SelectBoostsScreen.  Show tutorial? : %d", showTutorial);
    if (showTutorial) {
        [self startTutorial];
    }
}

- (void)drawPlanets
{
    categoryScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, deviceTypes.deviceWidth, deviceTypes.deviceHeight)];
    categoryScrollView.contentSize = CGSizeMake(deviceTypes.deviceWidth, deviceTypes.deviceHeight);
    [scrollersContainer addSubview:categoryScrollView];
    [categoryScrollView setEasingFunction:ExponentialEaseInOut forKeyPath:@"frame"];
    
    UIImage *bgImage = [UIImage imageNamed:@"levelMapBG.png"];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:bgImage];
    bgView.frame = CGRectMake(0, 0, deviceTypes.deviceWidth, bgImage.size.height);
    [categoryScrollView addSubview:bgView];
    
    UIImage *mercuryImage = [UIImage imageNamed:@"levelMapMercury.png"];
    UIImage *venusImage = [UIImage imageNamed:@"levelMapVenus.png"];
    UIImage *earthImage = [UIImage imageNamed:@"levelMapEarth.png"];
    UIImage *marsImage = [UIImage imageNamed:@"levelMapMars.png"];
    UIImage *jupiterImage = [UIImage imageNamed:@"levelMapJupiter.png"];
    UIImage *saturnImage = [UIImage imageNamed:@"levelMapSaturn.png"];
    UIImage *uranusImage = [UIImage imageNamed:@"levelMapUranus.png"];
    UIImage *neptuneImage = [UIImage imageNamed:@"levelMapNeptune.png"];
    UIImage *plutoImage = [UIImage imageNamed:@"levelMapPluto.png"];
    
    mercuryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    venusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    earthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    marsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    jupiterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saturnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    uranusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    neptuneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    plutoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [mercuryButton setImage:mercuryImage forState:UIControlStateNormal];
    [venusButton setImage:venusImage forState:UIControlStateNormal];
    [earthButton setImage:earthImage forState:UIControlStateNormal];
    [marsButton setImage:marsImage forState:UIControlStateNormal];
    [jupiterButton setImage:jupiterImage forState:UIControlStateNormal];
    [saturnButton setImage:saturnImage forState:UIControlStateNormal];
    [uranusButton setImage:uranusImage forState:UIControlStateNormal];
    [neptuneButton setImage:neptuneImage forState:UIControlStateNormal];
    [plutoButton setImage:plutoImage forState:UIControlStateNormal];
    
    mercuryButton.tag = 0;
    venusButton.tag = 1;
    earthButton.tag = 2;
    marsButton.tag = 3;
    jupiterButton.tag = 4;
    saturnButton.tag = 5;
    uranusButton.tag = 6;
    neptuneButton.tag = 7;
    plutoButton.tag = 8;
    
    [mercuryButton addTarget:self action:@selector(categorySelected:) forControlEvents:UIControlEventTouchUpInside];
    [venusButton addTarget:self action:@selector(categorySelected:) forControlEvents:UIControlEventTouchUpInside];
    [earthButton addTarget:self action:@selector(categorySelected:) forControlEvents:UIControlEventTouchUpInside];
    [marsButton addTarget:self action:@selector(categorySelected:) forControlEvents:UIControlEventTouchUpInside];
    [jupiterButton addTarget:self action:@selector(categorySelected:) forControlEvents:UIControlEventTouchUpInside];
    [saturnButton addTarget:self action:@selector(categorySelected:) forControlEvents:UIControlEventTouchUpInside];
    [uranusButton addTarget:self action:@selector(categorySelected:) forControlEvents:UIControlEventTouchUpInside];
    [neptuneButton addTarget:self action:@selector(categorySelected:) forControlEvents:UIControlEventTouchUpInside];
    [plutoButton addTarget:self action:@selector(categorySelected:) forControlEvents:UIControlEventTouchUpInside];
    
    mercuryButton.frame = CGRectMake(205, 60, mercuryImage.size.width, mercuryImage.size.height);
    venusButton.frame = CGRectMake(35, 105, venusImage.size.width, venusImage.size.height);
    earthButton.frame = CGRectMake(135, 170, earthImage.size.width, earthImage.size.height );
    marsButton.frame = CGRectMake(60, 195, marsImage.size.width, marsImage.size.height);
    jupiterButton.frame = CGRectMake(220, 210, jupiterImage.size.width, jupiterImage.size.height);
    saturnButton.frame = CGRectMake(80, 257, saturnImage.size.width, saturnImage.size.height);
    uranusButton.frame = CGRectMake(15, 315, jupiterImage.size.width, jupiterImage.size.height);
    neptuneButton.frame = CGRectMake(155, 350, neptuneImage.size.width, neptuneImage.size.height);
    plutoButton.frame = CGRectMake(270, 400, plutoImage.size.width, plutoImage.size.height);
    
    [categoryScrollView addSubview:mercuryButton];
    [categoryScrollView addSubview:venusButton];
    [categoryScrollView addSubview:earthButton];
    [categoryScrollView addSubview:marsButton];
    [categoryScrollView addSubview:jupiterButton];
    [categoryScrollView addSubview:saturnButton];
    [categoryScrollView addSubview:uranusButton];
    [categoryScrollView addSubview:neptuneButton];
    [categoryScrollView addSubview:plutoButton];
    
    NSMutableArray *planetButtons = [[NSMutableArray alloc] initWithObjects:mercuryButton, venusButton, earthButton, marsButton, jupiterButton, saturnButton, uranusButton, neptuneButton, plutoButton, nil];
    
    labelsTextArray = [[NSMutableArray alloc] initWithObjects:@"Mercury", @"Venus", @"Earth", @"Mars", @"Jupiter", @"Saturn", @"Uranus", @"Neptune", @"Pluto", nil];
    int numCategories = 9;
    
    for (int i = 0; i < numCategories; i++) {
        if (followingPlanetsLocked) {
            ((UIButton *)[planetButtons objectAtIndex:i]).alpha= 0.0;
        } else {
            ((UIButton *)[planetButtons objectAtIndex:i]).alpha = 1.0;
        }
        
        if ([[[SaveLoadDataDevice sharedManager] getCurrentPlanet] isEqualToString:[labelsTextArray objectAtIndex:i]]) {
            followingPlanetsLocked = YES;
        }
    }
    
}

/*  Draw the main Planets scroller containing the planet buttons. */
- (void)drawScrollerAndContent
{
    int numCategories = 9;
    float opponentFrameWidth = 304;
    float opponentFrameHeight = 63.5;
    
    categoryScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(deviceTypes.deviceWidth / 2 - opponentFrameWidth / 2 + 0.5/* because the bgImage is off by 1px */, 40, deviceTypes.deviceWidth - (deviceTypes.deviceWidth - opponentFrameWidth), deviceTypes.deviceHeight - 55)];
    categoryScrollView.contentSize = CGSizeMake(opponentFrameWidth, opponentFrameHeight * numCategories + 40);
    [scrollersContainer addSubview:categoryScrollView];
    [categoryScrollView setEasingFunction:ExponentialEaseInOut forKeyPath:@"frame"];
    
    UIImage *image = [UIImage imageNamed:@"levelMapOpponentBg.png"];
    
    labelsTextArray = [[NSMutableArray alloc] initWithObjects:@"Mercury", @"Venus", @"Earth", @"Mars", @"Jupiter", @"Saturn", @"Uranus", @"Neptune", @"Pluto", nil];
    
    for (int i = 0; i < numCategories; i++) {
        UIButton *categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [categoryButton setImage:image forState:UIControlStateNormal];
        categoryButton.frame = CGRectMake(0, opponentFrameHeight * i, image.size.width, image.size.height);
        categoryButton.tag = i;
        [categoryButton addTarget:self action:@selector(categorySelected:) forControlEvents:UIControlEventTouchUpInside];
        [categoryScrollView addSubview:categoryButton];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10 + opponentFrameHeight * i, 100, 20)];
        label.text = [labelsTextArray objectAtIndex:i];
        [categoryScrollView addSubview:label];
        
        if (followingPlanetsLocked) {
            categoryButton.enabled = NO;
        } else {
            categoryButton.enabled = YES;
        }
        
        if ([[[SaveLoadDataDevice sharedManager] getCurrentPlanet] isEqualToString:[labelsTextArray objectAtIndex:i]]) {
            followingPlanetsLocked = YES;
        }
    }
    
}

/*  A Planet was selected.  Use the tag property as a planet index in order to draw the robots for a given planet. */
- (void)categorySelected:(id)sender
{
    //NSLog(@"Category %d selected.", [sender tag]);
    [self createAndDisplayOpponentListForPlanet:[sender tag]];
    
}

- (void)createAndDisplayOpponentListForPlanet:(int)planetIndex
{
    SaveLoadDataDevice *sldd = [SaveLoadDataDevice sharedManager];
    
    int numRobots = [[planetsAndRobotsDict objectForKey:[labelsTextArray objectAtIndex:planetIndex]] count];
    
    NSMutableArray *robotsArray = [planetsAndRobotsDict objectForKey:[labelsTextArray objectAtIndex:planetIndex]];
    
    float opponentFrameWidth = 304;
    float opponentFrameHeight = 63.5;
    
    robotScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(deviceTypes.deviceWidth, 9, deviceTypes.deviceWidth - (deviceTypes.deviceWidth - opponentFrameWidth), deviceTypes.deviceHeight - 24)];
    robotScrollView.contentSize = CGSizeMake(opponentFrameWidth, opponentFrameHeight * numRobots + 40);
    [scrollersContainer addSubview:robotScrollView];
    [robotScrollView setEasingFunction:ExponentialEaseInOut forKeyPath:@"frame"];
    
    UIImage *image = [UIImage imageNamed:@"levelMapOpponentBg.png"];
    
    for (int i = 0; i < numRobots; i++) {
        int robotIndexInt = [[[robotsArray objectAtIndex:i] objectForKey:constants.OPPONENTINDEXINT] intValue];
        if ([[[robotsArray objectAtIndex:i] objectForKey:constants.OPPONENTINDEXINT] intValue] == [[[[sldd getOpponentHistoryDetails] objectAtIndex:robotIndexInt] objectForKey:constants.OPPONENTINDEXINT] intValue]) { /* player already beat this robot. */
            //NSLog(@"This robot has been beaten already.");
            /* show stats with stars */
            UIButton *categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [categoryButton setImage:image forState:UIControlStateNormal];
            categoryButton.frame = CGRectMake(0, opponentFrameHeight * i, image.size.width, image.size.height);
            [categoryButton addTarget:self action:@selector(robotSelected:) forControlEvents:UIControlEventTouchUpInside];
            categoryButton.tag = [[[robotsArray objectAtIndex:i] objectForKey:constants.OPPONENTINDEXINT] intValue];
            [robotScrollView addSubview:categoryButton];
            
            UIImage *avatarImage = [UIImage imageNamed:[[robotsArray objectAtIndex:i] objectForKey:constants.OPPONENTAVATAR]];
            UIImageView *avatarImageView = [[UIImageView alloc] initWithImage:avatarImage];
            avatarImageView.frame = CGRectMake(15, 10 + image.size.height * i, avatarImage.size.width, avatarImage.size.height);
            [robotScrollView addSubview:avatarImageView];
            
            UILabel *opponentTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 7 + opponentFrameHeight * i, 100, 20)];
            opponentTypeLabel.textColor = [UIColor whiteColor];
            opponentTypeLabel.text = [[robotsArray objectAtIndex:i] objectForKey:constants.CLASSNAME];
            [robotScrollView addSubview:opponentTypeLabel];
            
            UILabel *opponentScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 32 + opponentFrameHeight * i, 100, 20)];
            opponentScoreLabel.textColor = [UIColor whiteColor];
            opponentScoreLabel.text = [NSString stringWithFormat:@"Score:%d", [[[[sldd getOpponentHistoryDetails] objectAtIndex:robotIndexInt] objectForKey:constants.SCORE] intValue]];
            [robotScrollView addSubview:opponentScoreLabel];
            
            UIImage *goldStarImage = [UIImage imageNamed:@"goldStar.png"];
            //UIImage *greyStarImage = [UIImage imageNamed:@"greyStar.png"];
            
            if ([[[[sldd getOpponentHistoryDetails] objectAtIndex:robotIndexInt] objectForKey:constants.NUMBEROFSTARSEARNED] intValue] > 0) {
                UIImageView *goldStarImageView = [[UIImageView alloc] initWithImage:goldStarImage];
                goldStarImageView.frame = CGRectMake(162, 10 + opponentFrameHeight * i, goldStarImage.size.width, goldStarImage.size.height);
                [robotScrollView addSubview:goldStarImageView];
            }
            if ([[[[sldd getOpponentHistoryDetails] objectAtIndex:robotIndexInt] objectForKey:constants.NUMBEROFSTARSEARNED] intValue] > 1) {
                UIImageView *goldStarImageView = [[UIImageView alloc] initWithImage:goldStarImage];
                goldStarImageView.frame = CGRectMake(162 + goldStarImage.size.width + 4, 10 + opponentFrameHeight * i, goldStarImage.size.width, goldStarImage.size.height);
                [robotScrollView addSubview:goldStarImageView];
            }
            if ([[[[sldd getOpponentHistoryDetails] objectAtIndex:robotIndexInt] objectForKey:constants.NUMBEROFSTARSEARNED] intValue] > 2) {
                UIImageView *goldStarImageView = [[UIImageView alloc] initWithImage:goldStarImage];
                goldStarImageView.frame = CGRectMake(162 + goldStarImage.size.width * 2 + 8, 10 + opponentFrameHeight * i, goldStarImage.size.width, goldStarImage.size.height);
                [robotScrollView addSubview:goldStarImageView];
            }
            
        } else {
            
            if (isTheCurrentChallenger) {
                /* show a challenge button */
                UIButton *categorieButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [categorieButton setImage:image forState:UIControlStateNormal];
                categorieButton.frame = CGRectMake(0, opponentFrameHeight * i, image.size.width, image.size.height);
                [categorieButton addTarget:self action:@selector(robotSelected:) forControlEvents:UIControlEventTouchUpInside];
                categorieButton.tag = [[[robotsArray objectAtIndex:i] objectForKey:constants.OPPONENTINDEXINT] intValue];
                [robotScrollView addSubview:categorieButton];
            
                UIImage *avatarImage = [UIImage imageNamed:[[robotsArray objectAtIndex:i] objectForKey:constants.OPPONENTAVATAR]];
                UIImageView *avatarImageView = [[UIImageView alloc] initWithImage:avatarImage];
                avatarImageView.frame = CGRectMake(15, 10 + image.size.height * i, avatarImage.size.width, avatarImage.size.height);
                [robotScrollView addSubview:avatarImageView];
            
                UIImage *challengeImage = [UIImage imageNamed:@"challengeButton.png"];
                UIImageView *challengeimageView = [[UIImageView alloc] initWithImage:challengeImage];
                challengeimageView.frame = CGRectMake(170, 18 + image.size.height * i, challengeImage.size.width, challengeImage.size.height);
                [robotScrollView addSubview:challengeimageView];
                
                UILabel *opponentTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 7 + opponentFrameHeight * i, 100, 20)];
                opponentTypeLabel.textColor = [UIColor whiteColor];
                opponentTypeLabel.text = [[robotsArray objectAtIndex:i] objectForKey:constants.CLASSNAME];
                [robotScrollView addSubview:opponentTypeLabel];
                
                robotScrollView.contentOffset = CGPointMake(0, opponentFrameHeight * i);
                
                isTheCurrentChallenger = NO;
            
            } else {
                /* show that these robots are locked. */
                UIButton *categorieButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [categorieButton setImage:image forState:UIControlStateNormal];
                categorieButton.frame = CGRectMake(0, opponentFrameHeight * i, image.size.width, image.size.height);
                [categorieButton addTarget:self action:@selector(selectedRobotLocked:) forControlEvents:UIControlEventTouchUpInside];
                categorieButton.tag = [[[robotsArray objectAtIndex:i] objectForKey:constants.OPPONENTINDEXINT] intValue];
                [robotScrollView addSubview:categorieButton];
                
                UIImage *avatarImage = [UIImage imageNamed:@"lockedAvatar.png"];
                UIImageView *avatarImageView = [[UIImageView alloc] initWithImage:avatarImage];
                avatarImageView.frame = CGRectMake(15, 10 + image.size.height * i, avatarImage.size.width, avatarImage.size.height);
                [robotScrollView addSubview:avatarImageView];
            
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(180, 15 + opponentFrameHeight * i, 200, 30)];
                [label setFont:[UIFont boldSystemFontOfSize:25]];
                label.textColor = [UIColor whiteColor];
                label.text = [NSString stringWithFormat:@"LOCKED"];
                [robotScrollView addSubview:label];
            }
        }
        
    }
    
    UIImage *backButtonImage = [UIImage imageNamed:@"backButton.png"];
    backButtonRobots = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButtonRobots setImage:backButtonImage forState:UIControlStateNormal];
    backButtonRobots.frame = CGRectMake(deviceTypes.deviceWidth  + deviceTypes.deviceWidth / 2 - backButtonImage.size.width / 2, deviceTypes.deviceHeight - 35, backButtonImage.size.width, backButtonImage.size.height);
    [backButtonRobots addTarget:self action:@selector(backButtonRobotsHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButtonRobots];
    [backButtonRobots setEasingFunction:ExponentialEaseInOut forKeyPath:@"frame"];
    
    [self animateScrollersForwardToTheLeftWithScroller1:categoryScrollView andScroller2:robotScrollView];
}

- (void)robotSelected:(id)sender
{
    [delegate showSelectBoostsScreen:[sender tag]];
    //NSLog(@"robotSelected sender.tag : %d", [sender tag]);
}

- (void)selectedRobotLocked:(id)sender
{
    
}

- (void)animateScrollersForwardToTheLeftWithScroller1:(UIScrollView *)scroller1 andScroller2:(UIScrollView *)scroller2
{
    [UIView animateWithDuration:0.5 animations:^{
        
        scroller1.frame = CGRectMake(-deviceTypes.deviceWidth, scroller1.frame.origin.y, scroller1.frame.size.width, scroller1.frame.size.height);
        scroller2.frame = CGRectMake(8.5, scroller2.frame.origin.y, scroller2.frame.size.width, scroller2.frame.size.height);
        backButtonPlanets.frame = CGRectMake(-deviceTypes.deviceWidth / 2 - backButtonPlanets.frame.size.width / 2, backButtonPlanets.frame.origin.y, backButtonPlanets.frame.size.width, backButtonPlanets.frame.size.height);
        backButtonRobots.frame = CGRectMake(deviceTypes.deviceWidth / 2 - backButtonRobots.frame.size.width / 2, backButtonRobots.frame.origin.y, backButtonRobots.frame.size.width, backButtonRobots.frame.size.height);
        
    }];
    
}

- (void)backButtonPlanetsHandler:(id)sender
{
    [[AudioPlayer sharedManager] PlayButtonPressSoundAtVolume:0.1];
    [delegate closeLevelMapScreen];
}

- (void)backButtonRobotsHandler:(id)sender
{
    [[AudioPlayer sharedManager] PlayButtonPressSoundAtVolume:0.1];
    [UIView animateWithDuration:0.5 animations:^{
        
        categoryScrollView.frame = CGRectMake(0, categoryScrollView.frame.origin.y, categoryScrollView.frame.size.width, categoryScrollView.frame.size.height);
        robotScrollView.frame = CGRectMake(deviceTypes.deviceWidth, robotScrollView.frame.origin.y, robotScrollView.frame.size.width, robotScrollView.frame.size.height);
        backButtonPlanets.frame = CGRectMake(deviceTypes.deviceWidth / 2 - backButtonPlanets.frame.size.width / 2, backButtonPlanets.frame.origin.y, backButtonPlanets.frame.size.width, backButtonPlanets.frame.size.height);
        backButtonRobots.frame = CGRectMake(deviceTypes.deviceWidth  + deviceTypes.deviceWidth / 2 - backButtonRobots.frame.size.width / 2, backButtonRobots.frame.origin.y, backButtonRobots.frame.size.width, backButtonRobots.frame.size.height);
        
    }];
    
    isTheCurrentChallenger = YES;
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
    [nextButton addTarget:self action:@selector(closeTutorialScreen3:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.frame = CGRectMake(deviceTypes.deviceWidth - buttonImage.size.width - 15, tut1ImageView.frame.size.height - 50, buttonImage.size.width, buttonImage.size.height);
    
    [self addSubview:tut1Container];
    [tut1Container addSubview:tut1ImageView];
    [tut1Container addSubview:nextButton];
    [tut1Container setEasingFunction:ExponentialEaseOut forKeyPath:@"frame"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.0];
    NSTimer *animTut1Timer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(displayTutorialScreen1:) userInfo:nil repeats:NO];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: animTut1Timer forMode: NSDefaultRunLoopMode];
    date = nil;
    runner = nil;
    
    /***************************************  Tutorial screen 2 ***************************************/
    
//    tut2ImageView = [[UIImageView alloc] initWithImage:[tutorialImages objectAtIndex:1]];
//    tut2ImageView.frame = CGRectMake(0, 0, ((UIImage*)[tutorialImages objectAtIndex:1]).size.width, ((UIImage*)[tutorialImages objectAtIndex:1]).size.height);
//    
//    tut2Container = [[UIView alloc] initWithFrame:CGRectMake(deviceTypes.deviceWidth / 2 - tut2ImageView.frame.size.width / 2, deviceTypes.deviceHeight, ((UIImage*)[tutorialImages objectAtIndex:1]).size.width, ((UIImage*)[tutorialImages objectAtIndex:1]).size.height + 50)];
//    
//    nextButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [nextButton2 setImage:buttonImage forState:UIControlStateNormal];
//    [nextButton2 addTarget:self action:@selector(closeTutorialScreen2:) forControlEvents:UIControlEventTouchUpInside];
//    nextButton2.frame = CGRectMake(deviceTypes.deviceWidth - buttonImage.size.width - 15, tut2ImageView.frame.size.height - 50, buttonImage.size.width, buttonImage.size.height);
//    
//    [self addSubview:tut2Container];
//    [tut2Container addSubview:tut2ImageView];
//    [tut2Container addSubview:nextButton2];
//    [tut2Container setEasingFunction:ExponentialEaseOut forKeyPath:@"frame"];
    
    /***************************************  Tutorial screen 3 ***************************************/
    
//    tut3ImageView = [[UIImageView alloc] initWithImage:[tutorialImages objectAtIndex:2]];
//    tut3ImageView.frame = CGRectMake(0, 0, ((UIImage*)[tutorialImages objectAtIndex:2]).size.width, ((UIImage*)[tutorialImages objectAtIndex:2]).size.height);
//    
//    tut3Container = [[UIView alloc] initWithFrame:CGRectMake(deviceTypes.deviceWidth / 2 - tut3ImageView.frame.size.width / 2, deviceTypes.deviceHeight, ((UIImage*)[tutorialImages objectAtIndex:2]).size.width, ((UIImage*)[tutorialImages objectAtIndex:2]).size.height + 50)];
//    
//    nextButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [nextButton3 setImage:buttonImage forState:UIControlStateNormal];
//    [nextButton3 addTarget:self action:@selector(closeTutorialScreen3:) forControlEvents:UIControlEventTouchUpInside];
//    nextButton3.frame = CGRectMake(deviceTypes.deviceWidth - buttonImage.size.width - 15, tut3ImageView.frame.size.height - 50, buttonImage.size.width, buttonImage.size.height);
//    
//    [self addSubview:tut3Container];
//    [tut3Container addSubview:tut3ImageView];
//    [tut3Container addSubview:nextButton3];
//    [tut3Container setEasingFunction:ExponentialEaseOut forKeyPath:@"frame"];
}

- (void)showTutorialForPlanetIndex:(int)planetIndexInt
{
    blackBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, deviceTypes.deviceWidth, deviceTypes.deviceHeight)];
    blackBG.alpha = 0.7;
    blackBG.backgroundColor = [UIColor blackColor];
    [self addSubview:blackBG];
    
    tut1ImageView = [[UIImageView alloc] initWithImage:[tutorialImages objectAtIndex:planetIndexInt]];
    tut1ImageView.frame = CGRectMake(0, 0, ((UIImage*)[tutorialImages objectAtIndex:0]).size.width, ((UIImage*)[tutorialImages objectAtIndex:0]).size.height);
    
    tut1Container = [[UIView alloc] initWithFrame:CGRectMake(deviceTypes.deviceWidth / 2 - tut1ImageView.frame.size.width / 2, deviceTypes.deviceHeight, ((UIImage*)[tutorialImages objectAtIndex:0]).size.width, ((UIImage*)[tutorialImages objectAtIndex:0]).size.height + 50)];
    
    UIImage *buttonImage = [UIImage imageNamed:@"checkButton.png"];
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setImage:buttonImage forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(closeTutorialScreen3:) forControlEvents:UIControlEventTouchUpInside];
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
        
        tut1Container.frame = CGRectMake(deviceTypes.deviceWidth / 2 - tut1ImageView.frame.size.width / 2, deviceTypes.deviceHeight, tut1ImageView.frame.size.width, tut1ImageView.frame.size.height);
        [tut1Container setEasingFunction:ExponentialEaseOut forKeyPath:@"frame"];
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
