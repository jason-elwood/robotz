//
//  PointBurst.m
//  robotz
//
//  Created by Jason Elwood on 9/28/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "PointBurst.h"

@implementation PointBurst

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)createPointBurstWithPoints:(int)points withColor:(UIColor *)color
{
    THLabel *pointBurstLabel = [[THLabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    //UILabel *pointBurstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    pointBurstLabel.strokeColor = [UIColor blackColor];
    pointBurstLabel.strokeSize = 2;
    pointBurstLabel.strokePosition = THLabelStrokePositionOutside;
    UIFont *font = [UIFont fontWithName:@"Hobo Std" size:25.0];
    pointBurstLabel.textAlignment = NSTextAlignmentCenter;
    [pointBurstLabel setTextColor:color];
    [pointBurstLabel setFont:font];
    
    if (points == 0) {
        UIFont *font = [UIFont fontWithName:@"Hobo Std" size:16.0];
        [pointBurstLabel setFont:font];
        [pointBurstLabel setText:[NSString stringWithFormat:@"Dodge"]];
    } else {
        [pointBurstLabel setText:[NSString stringWithFormat:@"%d", points]];
    }
    
    [self addSubview:pointBurstLabel];
}

/*
UIFont *font = [UIFont fontWithName:@"Hobo Std" size:64.0];
[agilityLabel setFont:font];
 */

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
