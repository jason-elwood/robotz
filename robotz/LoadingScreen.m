//
//  LoadingScreen.m
//  robotz
//
//  Created by Jason Elwood on 9/18/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "LoadingScreen.h"

@implementation LoadingScreen

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self drawLoadingScreen];
        
    }
    return self;
}

- (void)drawLoadingScreen
{
    deviceTypes = [[DeviceTypes alloc] init];
    //NSLog(@"Device Type: %@", [deviceTypes getModel]);
    
    if (deviceTypes.deviceHeight > 480) {
        splashImage = [UIImage imageNamed:@"loadingGraphicLarge.png"];
    } else {
        splashImage = [UIImage imageNamed:@"loadingGraphicSmall.png"];
    }
    
    UIImageView *splashImageView = [[UIImageView alloc] initWithImage:splashImage];
    [splashImageView setFrame:CGRectMake(0, 0, deviceTypes.deviceWidth, deviceTypes.deviceHeight)];
    //NSLog(@"deviceWidth = %d and deviceHeight = %d", deviceTypes.deviceWidth, deviceTypes.deviceHeight);
    
    [self addSubview:splashImageView];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 310, 320, 20)];
    UIFont *font = [UIFont fontWithName:@"Hobo Std" size:20.0];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    [loadingLabel setTextColor:[UIColor whiteColor]];
    [loadingLabel setFont:font];
    [loadingLabel setText:@"Loading..."];
    [self addSubview:loadingLabel];
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
