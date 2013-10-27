//
//  EncouragingWords.m
//  robotz
//
//  Created by Jason Elwood on 10/6/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "EncouragingWords.h"

@implementation EncouragingWords

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)displayWithMessage:(NSString *)message
{
    UIImage *image = [UIImage imageNamed:message];
    self.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [self addSubview:imageView];
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
