//
//  BoostUnlockedScreen.h
//  robotz
//
//  Created by Jason Elwood on 10/14/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceTypes.h"
#import "THLabel.h"

@protocol BoostUnlockedProtocol <NSObject>

- (void)closeBoostUnlockedScreen;

@end

@interface BoostUnlockedScreen : UIView
{
    DeviceTypes *deviceTypes;
}

@property (weak) id <BoostUnlockedProtocol>delegate;

- (void)createScreenWithBoostImage:(NSString *)boostImage andBoostText:(NSString *)boostText;

@end
