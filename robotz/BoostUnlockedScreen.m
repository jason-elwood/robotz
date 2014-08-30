//
//  BoostUnlockedScreen.m
//  robotz
//
//  Created by Jason Elwood on 10/14/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "BoostUnlockedScreen.h"

@implementation BoostUnlockedScreen

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self drawUI];
        deviceTypes = [[DeviceTypes alloc] init];
    }
    return self;
}

- (void)drawUI
{
    UIImage *boostUnlockedBgImage = [UIImage imageNamed:@"boostUnlockedScreen.png"];
    UIImageView *boostUnlockedBgImageView = [[UIImageView alloc] initWithImage:boostUnlockedBgImage];
    boostUnlockedBgImageView.frame = CGRectMake(0, 0, 320, boostUnlockedBgImage.size.height);
    [self addSubview:boostUnlockedBgImageView];
}

- (void)createScreenWithBoostImage:(NSString *)boostImage andBoostText:(NSString *)boostText
{
    UIImage *boostTypeImage = [UIImage imageNamed:boostImage];
    UIImageView *boostTypeImageView = [[UIImageView alloc] initWithImage:boostTypeImage];
    boostTypeImageView.frame = CGRectMake(deviceTypes.deviceWidth / 2 - boostTypeImage.size.width / 2, 130, boostTypeImage.size.width, boostTypeImage.size.height);
    [self addSubview:boostTypeImageView];
    
    THLabel *boostTextLabel= [[THLabel alloc] initWithFrame:CGRectMake(0, 220, deviceTypes.deviceWidth, 50)];
    boostTextLabel.strokeColor = [UIColor darkGrayColor];
    boostTextLabel.strokeSize = 2;
    boostTextLabel.strokePosition = THLabelStrokePositionOutside;
    UIFont *font = [UIFont boldSystemFontOfSize:30.0];
    boostTextLabel.textAlignment = NSTextAlignmentCenter;
    [boostTextLabel setTextColor:[UIColor whiteColor]];
    [boostTextLabel setFont:font];
    boostTextLabel.text = boostText;
    [self addSubview:boostTextLabel];
    
    UIImage *continueButtonImage = [UIImage imageNamed:@"continueButton.png"];
    UIButton *continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [continueButton setImage:continueButtonImage forState:UIControlStateNormal];
    [continueButton addTarget:self action:@selector(continueButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    continueButton.frame = CGRectMake(deviceTypes.deviceWidth / 2 - continueButtonImage.size.width / 2, 360, continueButtonImage.size.width, continueButtonImage.size.height);
    [self addSubview:continueButton];
}

- (void)continueButtonHandler:(id)sender
{
    [delegate closeBoostUnlockedScreen];
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
