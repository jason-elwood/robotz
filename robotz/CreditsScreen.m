//
//  CreditsScreen.m
//  robotz
//
//  Created by Jason Elwood on 10/11/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "CreditsScreen.h"

@implementation CreditsScreen

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        deviceTypes = [[DeviceTypes alloc] init];
        [self drawUI];
    }
    return self;
}

- (void)drawUI
{
    UIImage *bgImage = [UIImage imageNamed:@"creditsPageBG.png"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0, 0, deviceTypes.deviceWidth, bgImage.size.height);
    [self addSubview:bgImageView];
    
    [self drawCreditsText];
}

- (void)closeCredits:(id)sender
{
    [delegate closeCreditsScreen];
}

- (void)drawCreditsText
{
    UITextView *creditsText = [[UITextView alloc] initWithFrame:CGRectMake(60, 80, deviceTypes.deviceWidth - 120, 303)];
    creditsText.editable = NO;
    [creditsText setBackgroundColor:[UIColor clearColor]];
    [creditsText setTextColor:[UIColor darkGrayColor]];
    creditsText.textAlignment = NSTextAlignmentCenter;
    creditsText.text = @"DESIGNER\nJason Elwood\n\nUI DESIGN, ART & ANIMATIONS\nJason Elwood\n\nGAME ENGINEERING\nJason Elwood\n\nSERVER ENGINEERING\nJason Elwood\n\nROBOT DESIGN\nAll robots designed by Jason Elwood. In some cases artwork was purchased to obtain legal use and then modified for use in game.  Any resemblance to actual robots, living or dead, is entirely coincidental.\n\nMUSIC & SOUNDS\nAll music used with permission from Teknoaxe - http://www.youtube.com/user/teknoaxe. Sounds created by Jason Elwood or obtained legally.\n\n\n";
    [self addSubview:creditsText];
    
    UIImage *closeButtonImage = [UIImage imageNamed:@"closeButtonSettings.png"];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(deviceTypes.deviceWidth / 2 - closeButtonImage.size.width / 2, 388, closeButtonImage.size.width, closeButtonImage.size.height);
    [closeButton setImage:closeButtonImage forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeCredits:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
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
