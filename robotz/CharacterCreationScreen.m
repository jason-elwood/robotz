//
//  CharacterCreationScreen.m
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "CharacterCreationScreen.h"

@implementation CharacterCreationScreen

@synthesize delegate, showTutorial;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        showTutorial = NO;
        tutorialImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"tutorial1.png"], [UIImage imageNamed:@"tutorial2.png"], [UIImage imageNamed:@"tutorial3.png"], nil];
        deviceTypes = [[DeviceTypes alloc] init];
        charClassData = [[CharacterClassData alloc] init];
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
    [self buildCharSelectModule];
    [loadingScreen removeFromSuperview];
    
    if (showTutorial) {
        [self startTutorial];
    }
}

- (void)buildCharSelectModule
{
    int charSelectContainerHeight;
    int charDetailsContainerHeight;
    
    charSelectContainerHeight = 215;
    charDetailsContainerHeight = 265;
    
    charSelectContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 27, deviceTypes.deviceWidth, charSelectContainerHeight)];
    [self addSubview:charSelectContainer];
    
    charSelectModule  = [[CharacterSelectorModule alloc] init];
    [charSelectModule setContentArray:[charClassData getImages]];
    [charSelectModule setSizeFromParentView:charSelectContainer];
    [charSelectModule enablePageControlOnBottom];
    [charSelectContainer addSubview:[charSelectModule getWithPositionMemory]];
    
    charClassDetailsModule = [[CharacterClassDetailsModule alloc] initWithFrame:CGRectMake(0, charSelectContainerHeight, deviceTypes.deviceWidth, charDetailsContainerHeight)];
    charClassDetailsModule.delegate = self;
    [self addSubview:charClassDetailsModule];
    
    UIImage *headerImage = [UIImage imageNamed:@"charCreationHeader.png"];
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:headerImage];
    headerImageView.frame = CGRectMake(0, 0, headerImage.size.width, headerImage.size.height);
    [self addSubview:headerImageView];
    //[self displaySwipeFinger];
}

- (void)newCharacterConfirmed
{
    [[AudioPlayer sharedManager] PlayButtonPressSoundAtVolume:0.1];
    [self nameYourRobot];
}

- (void)nameYourRobot
{
    UIImage *nameRobotPopupImage = [UIImage imageNamed:@"enterNamePopup.png"];
    nameRobotPopupView = [[UIImageView alloc] initWithImage:nameRobotPopupImage];
    nameRobotPopupView.frame = CGRectMake(0, 0, deviceTypes.deviceWidth, nameRobotPopupImage.size.height);
    [self addSubview:nameRobotPopupView];
    
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(deviceTypes.deviceWidth / 2 - 115, 159, 230, 30)];
    [nameTextField becomeFirstResponder];
    [self addSubview:nameTextField];
    
    UIImage *buttonImage = [UIImage imageNamed:@"okayButton.png"];
    okayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okayButton setImage:buttonImage forState:UIControlStateNormal];
    [okayButton addTarget:self action:@selector(robotNameConfirmed:) forControlEvents:UIControlEventTouchUpInside];
    okayButton.frame = CGRectMake(deviceTypes.deviceWidth / 2 - buttonImage.size.width / 2, 195, buttonImage.size.width, buttonImage.size.height);
    [self addSubview:okayButton];
    
    nameTextField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"return sent to textfield.");
    [self robotNameConfirmed:self];
    return YES;
}

- (void)robotNameConfirmed:(id)sender
{
    if ([nameTextField.text length] < 1 || [nameTextField.text length] > 12) {
        UIAlertView *nameLengthAlert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please enter a name between 1-12 characters long." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [nameLengthAlert show];
        return;
    }
    [delegate newCharacterConfirmed:nameTextField.text];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
