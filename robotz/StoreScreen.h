//
//  StoreScreen.h
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceTypes.h"
#import "SaveLoadDataDevice.h"
#import "InAppPurchaseManager.h"
#import "Constants.h"
#import "AudioPlayer.h"

@protocol StoreScreenProtocol <NSObject>

- (void)hideStoreScreen;
- (void)showFacebookView:(id)view;

@end

@interface StoreScreen : UIView <InAppPurchaseManagerProtocol>
{
    DeviceTypes *deviceTypes;
    InAppPurchaseManager *inAppPurchaseManager;
    Constants *constants;
    
    int numProducts;
    int facebookCoinsReward;
    NSMutableArray *activityIndicatorsArray;
    
    UIButton *facebookButton;
    
    UILabel *totalCoinsLabel;
    UILabel *timerText;
    UILabel *paymentProgressLabel;
    UIImageView *tellYourFriendsView;
    
    UIButton *nineNinetyNineButton;
    UIButton *fourNinetyNineButton;
    UIButton *oneNinetyNineButton;
    UIButton *ninetyNineButton;
    
    UIActivityIndicatorView *paymentProgressView;
}

@property (weak) id delegate;

- (void)facebookShareConfirmed;

@end
