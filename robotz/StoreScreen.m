//
//  StoreScreen.m
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "StoreScreen.h"

@implementation StoreScreen

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        facebookCoinsReward = 10000;
        constants = [[Constants alloc] init];
        deviceTypes = [[DeviceTypes alloc] init];
        inAppPurchaseManager = [[InAppPurchaseManager alloc] init];
        inAppPurchaseManager.delegate = self;
        [inAppPurchaseManager loadStore];
        [inAppPurchaseManager canMakePurchases];
        [self drawUI];
    }
    return self;
}
         
- (void)drawUI
{
    UIImage *bgImage = [UIImage imageNamed:@"storeBackground.png"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0, 0, deviceTypes.deviceWidth, bgImage.size.height);
    [self addSubview:bgImageView];
    
    numProducts = 4;
    
    activityIndicatorsArray = [[NSMutableArray alloc] initWithCapacity:numProducts];
    
    for (int i = 0; i < numProducts; i++) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        activityView.center = CGPointMake(deviceTypes.deviceWidth * 0.8, 135 + (38 * i));
        
        [activityView startAnimating];
        
        [self addSubview:activityView];
        
        [activityIndicatorsArray addObject:activityView];
    }
    
    totalCoinsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, deviceTypes.deviceWidth, 20)];
    
    [totalCoinsLabel setTextColor:[UIColor whiteColor]];
    totalCoinsLabel.textAlignment = NSTextAlignmentCenter;
    [totalCoinsLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [self addSubview:totalCoinsLabel];
    [self updateTotalCoinsLabel];
    
    UIImage *closeButtonImage = [UIImage imageNamed:@"closeButtonStore.png"];
    UIButton *closeClassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeClassButton setImage:closeButtonImage forState:0];
    [closeClassButton addTarget:self action:@selector(closeStoreScreen:) forControlEvents:UIControlEventTouchUpInside];
    [closeClassButton setFrame:CGRectMake(deviceTypes.deviceWidth / 2 - closeButtonImage.size.width / 2, 435, closeButtonImage.size.width, closeButtonImage.size.height)];
    [self addSubview:closeClassButton];
    
    if ([[SaveLoadDataDevice sharedManager] getSavedDate] != NULL) {
        
        NSMutableDictionary *savedDateDict = [[SaveLoadDataDevice sharedManager] getSavedDate];
        
        //NSLog(@"savedDate : %@", savedDateDict);
            
        NSDate *today = [NSDate date];
            
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEEE MMMM d, YYYY"];
        [formatter setDateFormat:@"YYYY"];
        NSString *currYear = [formatter stringFromDate:today];
        [formatter setDateFormat:@"MM"];
        NSString *currMonth = [formatter stringFromDate:today];
        [formatter setDateFormat:@"d"];
        NSString *currDay = [formatter stringFromDate:today];
        
        NSLog(@"currYear : %d.  Saved Year : %d", [currYear intValue], [[savedDateDict objectForKey:constants.YEAR] intValue]);
        NSLog(@"currMonth : %d.  Saved Month : %d", [currMonth intValue], [[savedDateDict objectForKey:constants.MONTH] intValue]);
        NSLog(@"currDay : %d.  Saved Day : %d", [currDay intValue], [[savedDateDict objectForKey:constants.DAY] intValue]);
        
        if ([currYear intValue] > [[savedDateDict objectForKey:constants.YEAR] intValue] ||
            [currMonth intValue] > [[savedDateDict objectForKey:constants.MONTH] intValue] ||
            [currDay intValue] > [[savedDateDict objectForKey:constants.DAY] intValue])
        {
            [self displayFacebookButton];
        } else {
            [self displayFacebookCountdownTimer];
        }
    } else {
        [self displayFacebookButton];
    }
    
}

- (void)updateTotalCoinsLabel
{
    NSMutableDictionary *charData = [[SaveLoadDataDevice sharedManager] getCharData];
    
    int coins = [[charData objectForKey:constants.TOTALCOINS] intValue];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:coins]];
    
    totalCoinsLabel.text = [NSString stringWithFormat:@"%@", formatted];
    
    //NSLog(@"Update totalCoins label");
}

- (void)productsLoaded
{
    for (int i = 0; i < numProducts; i++) {
        [[activityIndicatorsArray objectAtIndex:i] removeFromSuperview];
    }
    
    nineNinetyNineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *nineNinetyNineImage = [UIImage imageNamed:@"999Button.png"];
    [nineNinetyNineButton setImage:nineNinetyNineImage forState:UIControlStateNormal];
    nineNinetyNineButton.frame = CGRectMake(deviceTypes.deviceWidth * 0.6, 123, nineNinetyNineImage.size.width, nineNinetyNineImage.size.height);
    [nineNinetyNineButton addTarget:self action:@selector(buyNineNinetyNine:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nineNinetyNineButton];
    
    fourNinetyNineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *fourNinetyNineImage = [UIImage imageNamed:@"499Button.png"];
    [fourNinetyNineButton setImage:fourNinetyNineImage forState:UIControlStateNormal];
    fourNinetyNineButton.frame = CGRectMake(deviceTypes.deviceWidth * 0.6, 161, nineNinetyNineImage.size.width, nineNinetyNineImage.size.height);
    [fourNinetyNineButton addTarget:self action:@selector(buyFourNinetyNine:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:fourNinetyNineButton];
    
    oneNinetyNineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *oneNinetyNineImage = [UIImage imageNamed:@"199Button.png"];
    [oneNinetyNineButton setImage:oneNinetyNineImage forState:UIControlStateNormal];
    oneNinetyNineButton.frame = CGRectMake(deviceTypes.deviceWidth * 0.6, 199, nineNinetyNineImage.size.width, nineNinetyNineImage.size.height);
    [oneNinetyNineButton addTarget:self action:@selector(buyOneNinetyNine:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:oneNinetyNineButton];
    
    ninetyNineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *ninetyNineImage = [UIImage imageNamed:@"99centButton.png"];
    [ninetyNineButton setImage:ninetyNineImage forState:UIControlStateNormal];
    ninetyNineButton.frame = CGRectMake(deviceTypes.deviceWidth * 0.6, 237, nineNinetyNineImage.size.width, nineNinetyNineImage.size.height);
    [ninetyNineButton addTarget:self action:@selector(buyNinetyNine:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:ninetyNineButton];
}

- (void)displayFacebookCountdownTimer
{
    UITextView *waitMessage = [[UITextView alloc] initWithFrame:CGRectMake(50, 352, 220, 80)];
    waitMessage.editable = NO;
    [waitMessage setFont:[UIFont boldSystemFontOfSize:18]];
    waitMessage.textColor = [UIColor whiteColor];
    waitMessage.backgroundColor = [UIColor clearColor];
    waitMessage.text = @"Free coins are available for sharing to Facebook once per day.";
    [self addSubview:waitMessage];
    //NSLog(@"Display wait message.");
    
    timerText = [[UILabel alloc] initWithFrame:CGRectMake(110, 325, 125, 40)];
    timerText.textColor = [UIColor whiteColor];
    [timerText setFont:[UIFont boldSystemFontOfSize:25]];
    [self addSubview:timerText];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 0.0];
    NSTimer *freeCoinsTimer = [[NSTimer alloc] initWithFireDate:date interval:1.0 target:self selector:@selector(displayCountdownTime:) userInfo:nil repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: freeCoinsTimer forMode: NSDefaultRunLoopMode];
}

- (void)displayCountdownTime:(NSTimer *)timer
{
    NSDate *today = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    [formatter setDateFormat:@"HH"];
    NSString *currHour = [formatter stringFromDate:today];
    [formatter setDateFormat:@"mm"];
    NSString *currMinute = [formatter stringFromDate:today];
    [formatter setDateFormat:@"ss"];
    NSString *currSecond = [formatter stringFromDate:today];
    
    int hoursToGo = 24 - [currHour intValue];
    int minutesToGo = 60 - [currMinute intValue];
    int secondsToGo = 60 - [currSecond intValue];
    
    NSString *hours;
    NSString *minutes;
    NSString *seconds;
    
    if (hoursToGo < 10) {
        hours = [NSString stringWithFormat:@"0%d", hoursToGo - 1];
    } else {
        hours = [NSString stringWithFormat:@"%d", hoursToGo - 1];
    }
    if (minutesToGo < 10) {
        minutes = [NSString stringWithFormat:@"0%d", minutesToGo- 1];
    } else {
        minutes = [NSString stringWithFormat:@"%d", minutesToGo - 1];
    }
    if (secondsToGo < 10) {
        seconds = [NSString stringWithFormat:@"0%d", secondsToGo - 1];
    } else {
        seconds = [NSString stringWithFormat:@"%d", secondsToGo - 1];
    }
    if (hoursToGo == 24) {
        hours = @"00";
    }
    if (minutesToGo == 60) {
        minutes = @"00";
    }
    if (secondsToGo == 60)
    {
        seconds = @"00";
    }
    
    timerText.text = [NSString stringWithFormat:@"%@:%@:%@", hours, minutes, seconds];
    
    // clean up
    formatter = nil;
    currSecond = nil;
    currMinute = nil;
    currHour = nil;
    hours = nil;
    minutes = nil;
    seconds = nil;
}

- (void)displayFacebookButton
{
    UIImage *facebookImage = [UIImage imageNamed:@"facebookButton.png"];
    facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    facebookButton.frame = CGRectMake(deviceTypes.deviceWidth / 2 - (facebookImage.size.width * 0.9) / 2, 325, facebookImage.size.width * 0.9, facebookImage.size.height * 0.9);
    [facebookButton setImage:facebookImage forState:UIControlStateNormal];
    [facebookButton addTarget:self action:@selector(facebookButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:facebookButton];
    
    UIImage *tellYourFriendsImage = [UIImage imageNamed:@"tellYourFriendsText.png"];
    tellYourFriendsView = [[UIImageView alloc] initWithImage:tellYourFriendsImage];
    tellYourFriendsView.frame = CGRectMake(50, 365, tellYourFriendsImage.size.width, tellYourFriendsImage.size.height);
    [self addSubview:tellYourFriendsView];
}

- (void)facebookButtonHandler:(id)sender
{
    [delegate showFacebookView:self];
}

- (void)facebookShareConfirmed
{
    [[SaveLoadDataDevice sharedManager] setPlayersCoins:[[[[SaveLoadDataDevice sharedManager] getCharData] objectForKey:constants.TOTALCOINS] intValue] + facebookCoinsReward];
    [self updateTotalCoinsLabel];
    [self startFacebookFreeCoinsTimer];
}

- (void)startFacebookFreeCoinsTimer
{
    NSDate *today = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE MMMM d, YYYY"];
    [formatter setDateFormat:@"YYYY"];
    NSString *currYear = [formatter stringFromDate:today];
    [formatter setDateFormat:@"MM"];
    NSString *currMonth = [formatter stringFromDate:today];
    [formatter setDateFormat:@"d"];
    NSString *currDay = [formatter stringFromDate:today];
    
    NSMutableDictionary *dateDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     [NSNumber numberWithInt:[currYear intValue]], constants.YEAR,
                                     [NSNumber numberWithInt:[currMonth intValue]], constants.MONTH,
                                     [NSNumber numberWithInt:[currDay intValue]], constants.DAY,
                                     nil];
    [[SaveLoadDataDevice sharedManager] setCurrentDate:dateDict];
    
    [tellYourFriendsView removeFromSuperview];
    tellYourFriendsView = nil;
    
    [facebookButton removeFromSuperview];
    facebookButton = nil;
    
    [self displayFacebookCountdownTimer];
    
    //NSLog(@"currYear : %d, currMonth : %d, currDay : %d", [currYear intValue], [currMonth intValue], [currDay intValue]);
}

- (void)buyNineNinetyNine:(id)sender
{
    [inAppPurchaseManager purchaseThreeMillionSevenHundredFiftyCoins];
    
    paymentProgressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    paymentProgressView.center = CGPointMake(nineNinetyNineButton.frame.origin.x + 60, nineNinetyNineButton.frame.origin.y + 14);
    [paymentProgressView startAnimating];
    [self addSubview:paymentProgressView];
    paymentProgressLabel = [[UILabel alloc] initWithFrame:CGRectMake(nineNinetyNineButton.frame.origin.x - 6, nineNinetyNineButton.frame.origin.y - 1, 150, 30)];
    paymentProgressLabel.font = [UIFont boldSystemFontOfSize:12.0];
    paymentProgressLabel.textColor = [UIColor darkGrayColor];
    paymentProgressLabel.text = @"Contacting App Store";
    [self addSubview:paymentProgressLabel];
    nineNinetyNineButton.alpha = 0.0;
    nineNinetyNineButton.enabled = NO;
    
    nineNinetyNineButton.enabled = NO;
    fourNinetyNineButton.enabled = NO;
    oneNinetyNineButton.enabled = NO;
    ninetyNineButton.enabled = NO;
    
    //NSLog(@"Attempting to buy $9.99 item.");
}

- (void)buyFourNinetyNine:(id)sender
{
    [inAppPurchaseManager purchaseOneMillionFiveHundredThousandCoins];
    
    paymentProgressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    paymentProgressView.center = CGPointMake(fourNinetyNineButton.frame.origin.x + 60, fourNinetyNineButton.frame.origin.y + 14);
    [paymentProgressView startAnimating];
    [self addSubview:paymentProgressView];
    paymentProgressLabel = [[UILabel alloc] initWithFrame:CGRectMake(fourNinetyNineButton.frame.origin.x - 6, fourNinetyNineButton.frame.origin.y - 1, 150, 30)];
    paymentProgressLabel.font = [UIFont boldSystemFontOfSize:12.0];
    paymentProgressLabel.textColor = [UIColor darkGrayColor];
    paymentProgressLabel.text = @"Contacting App Store";
    [self addSubview:paymentProgressLabel];
    fourNinetyNineButton.alpha = 0.0;
    fourNinetyNineButton.enabled = NO;
    
    nineNinetyNineButton.enabled = NO;
    fourNinetyNineButton.enabled = NO;
    oneNinetyNineButton.enabled = NO;
    ninetyNineButton.enabled = NO;
    
    //NSLog(@"Attempting to buy $4.99 item.");
}

- (void)buyOneNinetyNine:(id)sender
{
    [inAppPurchaseManager purchaseThreeHundredThousandCoins];
    
    paymentProgressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    paymentProgressView.center = CGPointMake(oneNinetyNineButton.frame.origin.x + 60, oneNinetyNineButton.frame.origin.y + 14);
    [paymentProgressView startAnimating];
    [self addSubview:paymentProgressView];
    paymentProgressLabel = [[UILabel alloc] initWithFrame:CGRectMake(oneNinetyNineButton.frame.origin.x - 6, oneNinetyNineButton.frame.origin.y - 1, 150, 30)];
    paymentProgressLabel.font = [UIFont boldSystemFontOfSize:12.0];
    paymentProgressLabel.textColor = [UIColor darkGrayColor];
    paymentProgressLabel.text = @"Contacting App Store";
    [self addSubview:paymentProgressLabel];
    oneNinetyNineButton.alpha = 0.0;
    oneNinetyNineButton.enabled = NO;
    
    nineNinetyNineButton.enabled = NO;
    fourNinetyNineButton.enabled = NO;
    oneNinetyNineButton.enabled = NO;
    ninetyNineButton.enabled = NO;
    
    //NSLog(@"Attempting to buy $1.99 item.");
}

- (void)buyNinetyNine:(id)sender
{
    [inAppPurchaseManager purchaseTwentyFiveThousandCoins];
    
    paymentProgressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    paymentProgressView.center = CGPointMake(ninetyNineButton.frame.origin.x + 60, ninetyNineButton.frame.origin.y + 14);
    [paymentProgressView startAnimating];
    [self addSubview:paymentProgressView];
    paymentProgressLabel = [[UILabel alloc] initWithFrame:CGRectMake(ninetyNineButton.frame.origin.x - 6, ninetyNineButton.frame.origin.y - 1, 150, 30)];
    paymentProgressLabel.font = [UIFont boldSystemFontOfSize:12.0];
    paymentProgressLabel.textColor = [UIColor darkGrayColor];
    paymentProgressLabel.text = @"Contacting App Store";
    [self addSubview:paymentProgressLabel];
    ninetyNineButton.alpha = 0.0;
    ninetyNineButton.enabled = NO;
    
    nineNinetyNineButton.enabled = NO;
    fourNinetyNineButton.enabled = NO;
    oneNinetyNineButton.enabled = NO;
    ninetyNineButton.enabled = NO;
    
    //NSLog(@"Attempting to $0.99 item.");
}

- (void)transactionCompleteTransType:(int)tranType
{
    [paymentProgressView removeFromSuperview];
    paymentProgressView = nil;
    [paymentProgressLabel removeFromSuperview];
    paymentProgressLabel = nil;
    
    ninetyNineButton.alpha = 1.0;
    ninetyNineButton.enabled = YES;
    oneNinetyNineButton.alpha = 1.0;
    oneNinetyNineButton.enabled = YES;
    fourNinetyNineButton.alpha = 1.0;
    fourNinetyNineButton.enabled = YES;
    nineNinetyNineButton.alpha = 1.0;
    nineNinetyNineButton.enabled = YES;
}

- (void)transactionFailed
{
    [paymentProgressView removeFromSuperview];
    paymentProgressView = nil;
    [paymentProgressLabel removeFromSuperview];
    paymentProgressLabel = nil;
    
    ninetyNineButton.alpha = 1.0;
    ninetyNineButton.enabled = YES;
    oneNinetyNineButton.alpha = 1.0;
    oneNinetyNineButton.enabled = YES;
    fourNinetyNineButton.alpha = 1.0;
    fourNinetyNineButton.enabled = YES;
    nineNinetyNineButton.alpha = 1.0;
    nineNinetyNineButton.enabled = YES;
    //NSLog(@"transaction failed!");
}

- (void)closeStoreScreen:(id)sender
{
    [[AudioPlayer sharedManager] PlayButtonPressSoundAtVolume:0.1];
    [delegate hideStoreScreen];
    //[inAppPurchaseManager purchaseRedDeck];
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
