//
//  SelectBoostsScreen.m
//  robotz
//
//  Created by Jason Elwood on 9/24/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "SelectBoostsScreen.h"

@implementation SelectBoostsScreen

@synthesize delegate, showTutorial;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        tutorialImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"tutorialBoosts.png"], [UIImage imageNamed:@"tutorialBoosts2.png"], nil];
        showTutorial = NO;
        deviceTypes = [[DeviceTypes alloc] init];
        boostsData = [[BoostsData alloc] init];
        constants = [[Constants alloc] init];
        
        SaveLoadDataDevice *sldd = [SaveLoadDataDevice sharedManager];
        sldd.delegate = self;
        
        boostOneSelected = NO;
        boostTwoSelected = NO;
        boostThreeSelected = NO;
        boostFourSelected = NO;
        boostFiveSelected = NO;
        
        [self drawUI];
    }
    return self;
}

- (void)drawUI
{
    PlayerData *pd = [PlayerData sharedManager];
    
    UIImage *bgImage = [UIImage imageNamed:@"selectBoostsBackground.png"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0, 0, deviceTypes.deviceWidth, bgImage.size.height);
    [self addSubview:bgImageView];
    
    UIImage *moreCoinsButtonImage = [UIImage imageNamed:@"moreCoinsButton.png"];
    UIButton *moreCoinsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreCoinsButton setImage:moreCoinsButtonImage forState:0];
    [moreCoinsButton addTarget:self action:@selector(getMoreCoins:) forControlEvents:UIControlEventTouchUpInside];
    [moreCoinsButton setFrame:CGRectMake(deviceTypes.deviceWidth / 2 - moreCoinsButtonImage.size.width / 2, 102, moreCoinsButtonImage.size.width, moreCoinsButtonImage.size.height)];
    [self addSubview:moreCoinsButton];
    
    UIImage *playButtonImage = [UIImage imageNamed:@"playButtonBoosts.png"];
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton setImage:playButtonImage forState:0];
    [playButton addTarget:self action:@selector(playGame:) forControlEvents:UIControlEventTouchUpInside];
    [playButton setFrame:CGRectMake(deviceTypes.deviceWidth / 2 - playButtonImage.size.width / 2, deviceTypes.deviceHeight - 110, playButtonImage.size.width, playButtonImage.size.height)];
    [self addSubview:playButton];
    
    UIImage *backButtonImage = [UIImage imageNamed:@"backButtonBoosts.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backButtonImage forState:0];
    [backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(10, deviceTypes.deviceHeight - 30, backButtonImage.size.width, backButtonImage.size.height)];
    [self addSubview:backButton];
    
    coinsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, deviceTypes.deviceWidth, 20)];
    coinsLabel.textAlignment = NSTextAlignmentCenter;
    [coinsLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:coinsLabel];
    
    costLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 243, deviceTypes.deviceWidth, 20)];
    costLabel.textAlignment = NSTextAlignmentCenter;
    [costLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:costLabel];
                               
    
    int playersCoins = [[[pd getRobotData] objectForKey:constants.TOTALCOINS] intValue];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:playersCoins]];
    
    [coinsLabel setText:formatted];
    
    [self drawBoostButtons];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 1.0];
    NSTimer *startTutorialTimer = [[NSTimer alloc] initWithFireDate:date interval:0.02 target:self selector:@selector(checkForTutorial:) userInfo:nil repeats:NO];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: startTutorialTimer forMode: NSDefaultRunLoopMode];
    date = nil;
    runner = nil;
}

- (void)drawBoostButtons
{
    UIImage *boost1Image = [UIImage imageNamed:[[boostsData getBoostsDataForBoostIndex:0] objectForKey:constants.BOOSTIMAGESMALL]];
    boost1Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [boost1Button setImage:boost1Image forState:UIControlStateNormal];
    [boost1Button addTarget:self action:@selector(boostOneTouch:) forControlEvents:UIControlEventTouchUpInside];
    boost1Button.frame = CGRectMake(28, 278, boost1Image.size.width, boost1Image.size.height);
    [self addSubview:boost1Button];
    
    UIImage *boost2Image = [UIImage imageNamed:[[boostsData getBoostsDataForBoostIndex:1] objectForKey:constants.BOOSTIMAGESMALL]];
    boost2Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [boost2Button setImage:boost2Image forState:UIControlStateNormal];
    [boost2Button addTarget:self action:@selector(boostTwoTouch:) forControlEvents:UIControlEventTouchUpInside];
    boost2Button.frame = CGRectMake(84, 278, boost2Image.size.width, boost2Image.size.height);
    [self addSubview:boost2Button];
    
    if ([[[[SaveLoadDataDevice sharedManager] getCharData] objectForKey:constants.PLAYERSLEVEL] intValue] > 1) {
        UIImage *boost3Image = [UIImage imageNamed:[[boostsData getBoostsDataForBoostIndex:2] objectForKey:constants.BOOSTIMAGESMALL]];
        boost3Button = [UIButton buttonWithType:UIButtonTypeCustom];
        [boost3Button setImage:boost3Image forState:UIControlStateNormal];
        [boost3Button addTarget:self action:@selector(boostThreeTouch:) forControlEvents:UIControlEventTouchUpInside];
        boost3Button.frame = CGRectMake(138, 278, boost3Image.size.width, boost3Image.size.height);
        [self addSubview:boost3Button];
    } else {
        return;
    }
    
    if ([[[[SaveLoadDataDevice sharedManager] getCharData] objectForKey:constants.PLAYERSLEVEL] intValue] > 2) {
        UIImage *boost4Image = [UIImage imageNamed:[[boostsData getBoostsDataForBoostIndex:3] objectForKey:constants.BOOSTIMAGESMALL]];
        boost4Button = [UIButton buttonWithType:UIButtonTypeCustom];
        [boost4Button setImage:boost4Image forState:UIControlStateNormal];
        [boost4Button addTarget:self action:@selector(boostFourTouch:) forControlEvents:UIControlEventTouchUpInside];
        boost4Button.frame = CGRectMake(193, 278, boost4Image.size.width, boost4Image.size.height);
        [self addSubview:boost4Button];
    } else {
        return;
    }
    // or if the user has unlocked it by buying the boost from the YOU LOSE menu.
    if ([[[[SaveLoadDataDevice sharedManager] getCharData] objectForKey:constants.PLAYERSLEVEL] intValue] > 3) {
        UIImage *boost5Image = [UIImage imageNamed:[[boostsData getBoostsDataForBoostIndex:4] objectForKey:constants.BOOSTIMAGESMALL]];
        boost5Button = [UIButton buttonWithType:UIButtonTypeCustom];
        [boost5Button setImage:boost5Image forState:UIControlStateNormal];
        [boost5Button addTarget:self action:@selector(boostFiveTouch:) forControlEvents:UIControlEventTouchUpInside];
        boost5Button.frame = CGRectMake(248, 278, boost5Image.size.width, boost5Image.size.height);
        [self addSubview:boost5Button];
    } else {
        return;
    }
}

- (void)checkForTutorial:(NSTimer *)timer
{
    NSLog(@"SelectBoostsScreen.  Show tutorial? : %d", showTutorial);
    if (showTutorial) {
        [self startTutorial];
    }
}

- (void)sendOpponentIndex:(int)opponentIndexInt
{
    opponentIndex = opponentIndexInt;
}

- (void)updateCoinsValue:(int)value
{
    PlayerData *pd = [PlayerData sharedManager];
    int newCoinValue = [[[pd getRobotData] objectForKey:constants.TOTALCOINS] intValue] - value;
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:newCoinValue]];
    
    [coinsLabel setText:[NSString stringWithFormat:@"%@", formatted]];
    if (newCoinValue < 0) {
        [coinsLabel setTextColor:[UIColor blackColor]];
    } else {
        [coinsLabel setTextColor:[UIColor whiteColor]];
    }
}

- (void)boostOneTouch:(id)sender
{
    if (!boostOneSelected) {
        NSLog(@"numBoostsSelected : %d", numBoostsSelected);
        if (numBoostsSelected < 3) {
            
            UIImage *boostOneImage = [UIImage imageNamed:[[boostsData getBoostsDataForBoostIndex:0] objectForKey:constants.BOOSTIMAGELARGE]];
            boost1ButtonLarge = [UIButton buttonWithType:UIButtonTypeCustom];
            [boost1ButtonLarge setImage:boostOneImage forState:UIControlStateNormal];
            [boost1ButtonLarge addTarget:self action:@selector(boostOneTouch:) forControlEvents:UIControlEventTouchUpInside];
            //boostOneImageView = [[UIImageView alloc] initWithImage:boostOneImage];
            
            if (numBoostsSelected == 0) {
                boost1ButtonLarge.frame = CGRectMake(17.5, 151.5, boostOneImage.size.width, boostOneImage.size.height);
            } else if (numBoostsSelected == 1) {
                boost1ButtonLarge.frame = CGRectMake(118, 151.5, boostOneImage.size.width, boostOneImage.size.height);
            } else if (numBoostsSelected == 2) {
                boost1ButtonLarge.frame = CGRectMake(218.5, 151.5, boostOneImage.size.width, boostOneImage.size.height);
            }
            boost1Button.alpha = 0.5;
            [self addSubview:boost1ButtonLarge];
            numBoostsSelected++;
            boostOneSelected = YES;
            accumBoostCost += [[[boostsData getBoostsDataForBoostIndex:0] objectForKey:constants.BOOSTCOST] intValue];
            
            if (showTutorial) {
                accumBoostCost = 0;
            }
            
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
            NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInt:accumBoostCost]];
            costLabel.text = [NSString stringWithFormat:@"%@", formatted];
            [self updateCoinsValue:accumBoostCost];
        } else {
            //UIAlertView;
        }
    } else {
        NSLog(@"numBoostsSelected : %d", numBoostsSelected);
        BOOL thirdSelected = NO;
        if (boost1ButtonLarge.frame.origin.x > 125) {
            thirdSelected = YES;
        }
        [boost1ButtonLarge removeFromSuperview];
        boost1ButtonLarge = nil;
        numBoostsSelected--;
        boostOneSelected = NO;
        boost1Button.alpha = 1.0;
        accumBoostCost -= [[[boostsData getBoostsDataForBoostIndex:0] objectForKey:constants.BOOSTCOST] intValue];
        
        if (showTutorial) {
            accumBoostCost = 0;
        }
        
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInt:accumBoostCost]];
        costLabel.text = [NSString stringWithFormat:@"%@", formatted];
        [self updateCoinsValue:accumBoostCost];
        if (thirdSelected) {
            return;
        }
        if (numBoostsSelected > 0) {
            if (boostTwoSelected && boost2ButtonLarge.frame.origin.x > 101) {
                boost2ButtonLarge.frame = CGRectMake(boost2ButtonLarge.frame.origin.x - 100.5, 151.5, boost2ButtonLarge.frame.size.width, boost2ButtonLarge.frame.size.height);
            }
            if (boostThreeSelected && boost3ButtonLarge.frame.origin.x > 101) {
                boost3ButtonLarge.frame = CGRectMake(boost3ButtonLarge.frame.origin.x - 100.5, 151.5, boost3ButtonLarge.frame.size.width, boost3ButtonLarge.frame.size.height);
            }
            if (boostFourSelected && boost4ButtonLarge.frame.origin.x > 101) {
                boost4ButtonLarge.frame = CGRectMake(boost4ButtonLarge.frame.origin.x - 100.5, 151.5, boost4ButtonLarge.frame.size.width, boost4ButtonLarge.frame.size.height);
            }
            if (boostFiveSelected && boost5ButtonLarge.frame.origin.x > 101) {
                boost5ButtonLarge.frame = CGRectMake(boost5ButtonLarge.frame.origin.x - 100.5, 151.5, boost5ButtonLarge.frame.size.width, boost5ButtonLarge.frame.size.height);
            }
        }
    }
}

- (void)boostTwoTouch:(id)sender
{
    if (!boostTwoSelected) {
        NSLog(@"numBoostsSelected : %d", numBoostsSelected);
        if (numBoostsSelected < 3) {
            UIImage *boostTwoImage = [UIImage imageNamed:[[boostsData getBoostsDataForBoostIndex:1] objectForKey:constants.BOOSTIMAGELARGE]];
            boost2ButtonLarge = [UIButton buttonWithType:UIButtonTypeCustom];
            [boost2ButtonLarge setImage:boostTwoImage forState:UIControlStateNormal];
            [boost2ButtonLarge addTarget:self action:@selector(boostTwoTouch:) forControlEvents:UIControlEventTouchUpInside];
            //boostTwoImageView = [[UIImageView alloc] initWithImage:boostTwoImage];
            if (numBoostsSelected == 0) {
                boost2ButtonLarge.frame = CGRectMake(17.5, 151.5, boostTwoImage.size.width, boostTwoImage.size.height);
            } else if (numBoostsSelected == 1) {
                boost2ButtonLarge.frame = CGRectMake(118, 151.5, boostTwoImage.size.width, boostTwoImage.size.height);
            } else if (numBoostsSelected == 2) {
                boost2ButtonLarge.frame = CGRectMake(218.5, 151.5, boostTwoImage.size.width, boostTwoImage.size.height);
            }
            boost2Button.alpha = 0.5;
            [self addSubview:boost2ButtonLarge];
            numBoostsSelected++;
            boostTwoSelected = YES;
            accumBoostCost += [[[boostsData getBoostsDataForBoostIndex:1] objectForKey:constants.BOOSTCOST] intValue];
            
            if (showTutorial) {
                accumBoostCost = 0;
            }
            
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
            NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInt:accumBoostCost]];
            costLabel.text = [NSString stringWithFormat:@"%@", formatted];
            [self updateCoinsValue:accumBoostCost];
        } else {
            //UIAlertView;
        }
    } else {
        NSLog(@"numBoostsSelected : %d", numBoostsSelected);
        BOOL thirdSelected = NO;
        if (boost2ButtonLarge.frame.origin.x > 125) {
            thirdSelected = YES;
        }
        [boost2ButtonLarge removeFromSuperview];
        boost2ButtonLarge = nil;
        numBoostsSelected--;
        boostTwoSelected = NO;
        boost2Button.alpha = 1.0;
        accumBoostCost -= [[[boostsData getBoostsDataForBoostIndex:1] objectForKey:constants.BOOSTCOST] intValue];
        
        if (showTutorial) {
            accumBoostCost = 0;
        }
        
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInt:accumBoostCost]];
        costLabel.text = [NSString stringWithFormat:@"%@", formatted];
        [self updateCoinsValue:accumBoostCost];
        if (thirdSelected) {
            return;
        }
        if (numBoostsSelected > 0) {
            if (boostOneSelected && boost1ButtonLarge.frame.origin.x > 101) {
                boost1ButtonLarge.frame = CGRectMake(boost1ButtonLarge.frame.origin.x - 100.5, 151.5, boost1ButtonLarge.frame.size.width, boost1ButtonLarge.frame.size.height);
            }
            if (boostThreeSelected && boost3ButtonLarge.frame.origin.x > 101) {
                boost3ButtonLarge.frame = CGRectMake(boost3ButtonLarge.frame.origin.x - 100.5, 151.5, boost3ButtonLarge.frame.size.width, boost3ButtonLarge.frame.size.height);
            }
            if (boostFourSelected && boost4ButtonLarge.frame.origin.x > 101) {
                boost4ButtonLarge.frame = CGRectMake(boost4ButtonLarge.frame.origin.x - 100.5, 151.5, boost4ButtonLarge.frame.size.width, boost4ButtonLarge.frame.size.height);
            }
            if (boostFiveSelected && boost5ButtonLarge.frame.origin.x > 101) {
                boost5ButtonLarge.frame = CGRectMake(boost5ButtonLarge.frame.origin.x - 100.5, 151.5, boost5ButtonLarge.frame.size.width, boost5ButtonLarge.frame.size.height);
            }
        }
    }
}

- (void)boostThreeTouch:(id)sender
{
    if (!boostThreeSelected) {
        NSLog(@"numBoostsSelected : %d", numBoostsSelected);
        if (numBoostsSelected < 3) {
            UIImage *boostThreeImage = [UIImage imageNamed:[[boostsData getBoostsDataForBoostIndex:2] objectForKey:constants.BOOSTIMAGELARGE]];
            boost3ButtonLarge = [UIButton buttonWithType:UIButtonTypeCustom];
            [boost3ButtonLarge setImage:boostThreeImage forState:UIControlStateNormal];
            [boost3ButtonLarge addTarget:self action:@selector(boostThreeTouch:) forControlEvents:UIControlEventTouchUpInside];
            //boostThreeImageView = [[UIImageView alloc] initWithImage:boostThreeImage];
            if (numBoostsSelected == 0) {
                boost3ButtonLarge.frame = CGRectMake(17.5, 151.5, boostThreeImage.size.width, boostThreeImage.size.height);
            } else if (numBoostsSelected == 1) {
                boost3ButtonLarge.frame = CGRectMake(118, 151.5, boostThreeImage.size.width, boostThreeImage.size.height);
            } else if (numBoostsSelected == 2) {
                boost3ButtonLarge.frame = CGRectMake(218.5, 151.5, boostThreeImage.size.width, boostThreeImage.size.height);
            }
            boost3Button.alpha = 0.5;
            [self addSubview:boost3ButtonLarge];
            numBoostsSelected++;
            boostThreeSelected = YES;
            accumBoostCost += [[[boostsData getBoostsDataForBoostIndex:2] objectForKey:constants.BOOSTCOST] intValue];
            
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
            NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInt:accumBoostCost]];
            costLabel.text = [NSString stringWithFormat:@"%@", formatted];
            [self updateCoinsValue:accumBoostCost];
        } else {
            //UIAlertView;
        }
    } else {
        NSLog(@"numBoostsSelected : %d", numBoostsSelected);
        BOOL thirdSelected = NO;
        if (boost3ButtonLarge.frame.origin.x > 125) {
            thirdSelected = YES;
        }
        [boost3ButtonLarge removeFromSuperview];
        boost3ButtonLarge = nil;
        numBoostsSelected--;
        boostThreeSelected = NO;
        boost3Button.alpha = 1.0;
        accumBoostCost -= [[[boostsData getBoostsDataForBoostIndex:2] objectForKey:constants.BOOSTCOST] intValue];
        
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInt:accumBoostCost]];
        costLabel.text = [NSString stringWithFormat:@"%@", formatted];
        [self updateCoinsValue:accumBoostCost];
        if (thirdSelected) {
            return;
        }
        if (numBoostsSelected > 0) {
            if (boostOneSelected && boost1ButtonLarge.frame.origin.x > 101) {
                boost1ButtonLarge.frame = CGRectMake(boost1ButtonLarge.frame.origin.x - 100.5, 151.5, boost1ButtonLarge.frame.size.width, boost1ButtonLarge.frame.size.height);
            }
            if (boostTwoSelected && boost2ButtonLarge.frame.origin.x > 101) {
                boost2ButtonLarge.frame = CGRectMake(boost2ButtonLarge.frame.origin.x - 100.5, 151.5, boost2ButtonLarge.frame.size.width, boost2ButtonLarge.frame.size.height);
            }
            if (boostFourSelected && boost4ButtonLarge.frame.origin.x > 101) {
                boost4ButtonLarge.frame = CGRectMake(boost4ButtonLarge.frame.origin.x - 100.5, 151.5, boost4ButtonLarge.frame.size.width, boost4ButtonLarge.frame.size.height);
            }
            if (boostFiveSelected && boost5ButtonLarge.frame.origin.x > 101) {
                boost5ButtonLarge.frame = CGRectMake(boost5ButtonLarge.frame.origin.x - 100.5, 151.5, boost5ButtonLarge.frame.size.width, boost5ButtonLarge.frame.size.height);
            }
        }
    }
}

- (void)boostFourTouch:(id)sender
{
    if (!boostFourSelected) {
        NSLog(@"numBoostsSelected : %d", numBoostsSelected);
        if (numBoostsSelected < 3) {
            UIImage *boostFourImage = [UIImage imageNamed:[[boostsData getBoostsDataForBoostIndex:3] objectForKey:constants.BOOSTIMAGELARGE]];
            boost4ButtonLarge = [UIButton buttonWithType:UIButtonTypeCustom];
            [boost4ButtonLarge setImage:boostFourImage forState:UIControlStateNormal];
            [boost4ButtonLarge addTarget:self action:@selector(boostFourTouch:) forControlEvents:UIControlEventTouchUpInside];
            //boostFourImageView = [[UIImageView alloc] initWithImage:boostFourImage];
            if (numBoostsSelected == 0) {
                boost4ButtonLarge.frame = CGRectMake(17.5, 151.5, boostFourImage.size.width, boostFourImage.size.height);
            } else if (numBoostsSelected == 1) {
                boost4ButtonLarge.frame = CGRectMake(118, 151.5, boostFourImage.size.width, boostFourImage.size.height);
            } else if (numBoostsSelected == 2) {
                boost4ButtonLarge.frame = CGRectMake(218.5, 151.5, boostFourImage.size.width, boostFourImage.size.height);
            }
            boost4Button.alpha = 0.5;
            [self addSubview:boost4ButtonLarge];
            numBoostsSelected++;
            boostFourSelected = YES;
            accumBoostCost += [[[boostsData getBoostsDataForBoostIndex:3] objectForKey:constants.BOOSTCOST] intValue];
            
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
            NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInt:accumBoostCost]];
            costLabel.text = [NSString stringWithFormat:@"%@", formatted];
            [self updateCoinsValue:accumBoostCost];
        } else {
            //UIAlertView;
        }
    } else {
        NSLog(@"numBoostsSelected : %d", numBoostsSelected);
        BOOL thirdSelected = NO;
        if (boost4ButtonLarge.frame.origin.x > 125) {
            thirdSelected = YES;
        }
        [boost4ButtonLarge removeFromSuperview];
        boost4ButtonLarge = nil;
        numBoostsSelected--;
        boostFourSelected = NO;
        boost4Button.alpha = 1.0;
        accumBoostCost -= [[[boostsData getBoostsDataForBoostIndex:3] objectForKey:constants.BOOSTCOST] intValue];
        
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInt:accumBoostCost]];
        costLabel.text = [NSString stringWithFormat:@"%@", formatted];
        [self updateCoinsValue:accumBoostCost];
        if (thirdSelected) {
            return;
        }
        if (numBoostsSelected > 0) {
            if (boostOneSelected && boost1ButtonLarge.frame.origin.x > 101) {
                boost1ButtonLarge.frame = CGRectMake(boost1ButtonLarge.frame.origin.x - 100.5, 151.5, boost1ButtonLarge.frame.size.width, boost1ButtonLarge.frame.size.height);
            }
            if (boostTwoSelected && boost2ButtonLarge.frame.origin.x > 101) {
                boost2ButtonLarge.frame = CGRectMake(boost2ButtonLarge.frame.origin.x - 100.5, 151.5, boost2ButtonLarge.frame.size.width, boost2ButtonLarge.frame.size.height);
            }
            if (boostThreeSelected && boost3ButtonLarge.frame.origin.x > 101) {
                boost3ButtonLarge.frame = CGRectMake(boost3ButtonLarge.frame.origin.x - 100.5, 151.5, boost3ButtonLarge.frame.size.width, boost3ButtonLarge.frame.size.height);
            }
            if (boostFiveSelected && boost5ButtonLarge.frame.origin.x > 101) {
                boost5ButtonLarge.frame = CGRectMake(boost5ButtonLarge.frame.origin.x - 100.5, 151.5, boost5ButtonLarge.frame.size.width, boost5ButtonLarge.frame.size.height);
            }
        }
    }
}

- (void)boostFiveTouch:(id)sender
{
    if (!boostFiveSelected) {
        NSLog(@"numBoostsSelected : %d", numBoostsSelected);
        if (numBoostsSelected < 3) {
            UIImage *boostFiveImage = [UIImage imageNamed:[[boostsData getBoostsDataForBoostIndex:4] objectForKey:constants.BOOSTIMAGELARGE]];
            boost5ButtonLarge = [UIButton buttonWithType:UIButtonTypeCustom];
            [boost5ButtonLarge setImage:boostFiveImage forState:UIControlStateNormal];
            [boost5ButtonLarge addTarget:self action:@selector(boostFiveTouch:) forControlEvents:UIControlEventTouchUpInside];
            //boostFiveImageView = [[UIImageView alloc] initWithImage:boostFiveImage];
            if (numBoostsSelected == 0) {
                boost5ButtonLarge.frame = CGRectMake(17.5, 151.5, boostFiveImage.size.width, boostFiveImage.size.height);
            } else if (numBoostsSelected == 1) {
                boost5ButtonLarge.frame = CGRectMake(118, 151.5, boostFiveImage.size.width, boostFiveImage.size.height);
            } else if (numBoostsSelected == 2) {
                boost5ButtonLarge.frame = CGRectMake(218.5, 151.5, boostFiveImage.size.width, boostFiveImage.size.height);
            }
            boost5Button.alpha = 0.5;
            [self addSubview:boost5ButtonLarge];
            numBoostsSelected++;
            boostFiveSelected = YES;
            accumBoostCost += [[[boostsData getBoostsDataForBoostIndex:4] objectForKey:constants.BOOSTCOST] intValue];
            
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
            NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInt:accumBoostCost]];
            costLabel.text = [NSString stringWithFormat:@"%@", formatted];
            [self updateCoinsValue:accumBoostCost];
        } else {
            //UIAlertView;
        }
    } else {
        NSLog(@"numBoostsSelected : %d", numBoostsSelected);
        BOOL thirdSelected = NO;
        if (boost5ButtonLarge.frame.origin.x > 125) {
            thirdSelected = YES;
        }
        [boost5ButtonLarge removeFromSuperview];
        boost5ButtonLarge = nil;
        numBoostsSelected--;
        boostFiveSelected = NO;
        boost5Button.alpha = 1.0;
        accumBoostCost -= [[[boostsData getBoostsDataForBoostIndex:4] objectForKey:constants.BOOSTCOST] intValue];
        costLabel.text = [NSString stringWithFormat:@"%d", accumBoostCost];
        [self updateCoinsValue:accumBoostCost];
        if (thirdSelected) {
            return;
        }
        if (numBoostsSelected > 0) {
            if (boostOneSelected && boost1ButtonLarge.frame.origin.x > 101) {
                boost1ButtonLarge.frame = CGRectMake(boost1ButtonLarge.frame.origin.x - 100.5, 151.5, boost1ButtonLarge.frame.size.width, boost1ButtonLarge.frame.size.height);
            }
            if (boostTwoSelected && boost2ButtonLarge.frame.origin.x > 101) {
                boost2ButtonLarge.frame = CGRectMake(boost2ButtonLarge.frame.origin.x - 100.5, 151.5, boost2ButtonLarge.frame.size.width, boost2ButtonLarge.frame.size.height);
            }
            if (boostThreeSelected && boost3ButtonLarge.frame.origin.x > 101) {
                boost3ButtonLarge.frame = CGRectMake(boost3ButtonLarge.frame.origin.x - 100.5, 151.5, boost3ButtonLarge.frame.size.width, boost3ButtonLarge.frame.size.height);
            }
            if (boostFourSelected && boost4ButtonLarge.frame.origin.x > 101) {
                boost4ButtonLarge.frame = CGRectMake(boost4ButtonLarge.frame.origin.x - 100.5, 151.5, boost4ButtonLarge.frame.size.width, boost4ButtonLarge.frame.size.height);
            }
        }
    }
}

- (void)getMoreCoins:(id)sender
{
    [delegate showStoreScreen];
}

- (void)playGame:(id)sender
{
    if (showTutorial && numBoostsSelected < 2) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Select 2 boosts before continuing.  They're free this time!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [[AudioPlayer sharedManager] PlayButtonPressSoundAtVolume:0.1];
    SaveLoadDataDevice *sldd = [SaveLoadDataDevice sharedManager];
    BattleManager *bm = [BattleManager sharedManager];
    if ([[[sldd getCharData] objectForKey:constants.TOTALCOINS] intValue] < accumBoostCost) {
        sorryAlert = [[UIAlertView alloc] initWithTitle:@"Oops"  message:@"You do not have enough coins for that.  Please remove one or more boosts or get more coins." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [sorryAlert show];
    } else {
        // send boosts to the BattleManager!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        NSLog(@"numBoostsSelected = %d", numBoostsSelected);
        NSMutableArray *boostsArray = [[NSMutableArray alloc] init];
        
        if (boostOneSelected) {
            [boostsArray addObject:[[boostsData getBoostsDataForBoostIndex:0] objectForKey:constants.BOOSTTYPE]];
        }
        if (boostTwoSelected) {
            [boostsArray addObject:[[boostsData getBoostsDataForBoostIndex:1] objectForKey:constants.BOOSTTYPE]];
        }
        if (boostThreeSelected) {
            [boostsArray addObject:[[boostsData getBoostsDataForBoostIndex:2] objectForKey:constants.BOOSTTYPE]];
        }
        if (boostFourSelected) {
            [boostsArray addObject:[[boostsData getBoostsDataForBoostIndex:3] objectForKey:constants.BOOSTTYPE]];
        }
        if (boostFiveSelected) {
            [boostsArray addObject:[[boostsData getBoostsDataForBoostIndex:4] objectForKey:constants.BOOSTTYPE]];
        }

        [bm setBoosts:boostsArray];
        [sldd setPlayersCoins:[[[sldd getCharData] objectForKey:constants.TOTALCOINS] intValue] - accumBoostCost];
        [delegate playSinglePlayer:opponentIndex];
    }
}

- (void)updateCoins:(int)coins
{
    [[PlayerData sharedManager] setRobotData:[[SaveLoadDataDevice sharedManager] loadPlayerData]];
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:coins]];
    
    [coinsLabel setText:[NSString stringWithFormat:@"%@", formatted]];
}

- (void)goBack:(id)sender
{
    [delegate hideSelectBoostsScreen];
}

/****************************************************************************************************************************************
 TUTORIAL | TUTORIAL | TUTORIAL | TUTORIAL | TUTORIAL | TUTORIAL | TUTORIAL | TUTORIAL | TUTORIAL | TUTORIAL | TUTORIAL | TUTORIAL |
 ****************************************************************************************************************************************/

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
}

- (void)hideBlackBG:(NSTimer *)timer
{
    blackBG.alpha -= 0.02;
    if (blackBG.alpha <= 0.0) {
        [timer invalidate];
        timer = nil;
        [blackBG removeFromSuperview];
        [tut1Container removeFromSuperview];
        tut1Container = nil;
        [tut2Container removeFromSuperview];
        tut2Container = nil;
        [tut3Container removeFromSuperview];
        tut3Container = nil;
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
