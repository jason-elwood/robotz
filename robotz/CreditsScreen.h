//
//  CreditsScreen.h
//  robotz
//
//  Created by Jason Elwood on 10/11/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceTypes.h"

@protocol CreditsScreenProtocol <NSObject>

- (void)closeCreditsScreen;

@end

@interface CreditsScreen : UIView
{
    DeviceTypes *deviceTypes;
}

@property (weak) id <CreditsScreenProtocol>delegate;

@end
