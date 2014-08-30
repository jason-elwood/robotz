//
//  InAppPurchaseManager.h
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "Constants.h"
#import "SaveLoadDataDevice.h"

@protocol InAppPurchaseManagerProtocol <NSObject>

- (void)productsLoaded;
- (void)updateTotalCoinsLabel;
- (void)transactionCompleteTransType:(int)tranType;
- (void)transactionFailed;

@end

@protocol InAppPurchaseManagerProtocolBattleScreen <NSObject>

- (void)productLoaded;
- (void)threeResurrectionsPurchased;
- (void)transactionFailed;

@end

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    Constants *constants;
    
    SKProduct *twentyFiveThousandCoins;
    SKProduct *threeHundredThousandCoins;
    SKProduct *oneMillionFiveHundredThousandCoins;
    SKProduct *threeMillionSevenHundredFiftyThousandCoins;
    SKProduct *threeResurrections;
    
    SKProductsRequest *productsRequest;
    NSMutableArray *skProducts;
}

@property (weak) id <InAppPurchaseManagerProtocol>delegate;
@property (weak) id <InAppPurchaseManagerProtocolBattleScreen>delegateBS;

- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchaseOneMillionFiveHundredThousandCoins;
- (void)purchaseTwentyFiveThousandCoins;
- (void)purchaseThreeHundredThousandCoins;
- (void)purchaseThreeMillionSevenHundredFiftyCoins;
- (void)purchaseThreeResurrections;

@end