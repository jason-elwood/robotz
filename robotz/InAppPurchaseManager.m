//
//  InAppPurchaseManager.m
//  robotz
//
//  Created by Jason Elwood on 9/17/13.
//  Copyright (c) 2013 Jason Elwood. All rights reserved.
//

#import "InAppPurchaseManager.h"

#define kInAppPurchaseNinetyNineCentPurchase @"25000"
#define kInAppPurchaseOneNinetyNinePurchase @"300000"
#define kInAppPurchaseFourNinetyNinePurchase @"1500000"
#define kInAppPurchaseNineNinetyNinePurchase @"3750000"
#define kInAppPurchaseThreeResurrections @"3resurrections"
//#define kInAppPurchaseNineNinetyNinePurchase @"com.droppedpixel.robotz.3750000Coins"

@implementation InAppPurchaseManager

@synthesize delegate, delegateBS;

//
// call this method once on startup
//
- (void)loadStore
{
    constants = [[Constants alloc] init];
    NSLog(@"loadStore called.");
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestProductData];
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    NSLog(@"canMakePurchases called.");
    return [SKPaymentQueue canMakePayments];
}

- (void)requestProductData
{
    // Create a set with the product id's
    NSSet *productIdentifiers = [NSSet setWithObjects:@"25000", @"300000", @"1500000", @"3750000", @"3resurrections", nil];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    NSLog(@"Robotz Products returned : %@", productIdentifiers);
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

// This is the callback method.  We loop the product set and log the product info.
// When this method is called, the data is ready and we can display the store buttons.
// I believe this method is used to confirm a response and display any data
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    [delegate productsLoaded];
    NSArray *products = response.products;
    NSLog(@"response.products = %@", response.products);
    oneMillionFiveHundredThousandCoins = [products  objectAtIndex:0];
    twentyFiveThousandCoins = [products  objectAtIndex:1];
    threeHundredThousandCoins = [products  objectAtIndex:2];
    threeMillionSevenHundredFiftyThousandCoins = [products  objectAtIndex:3];
    threeResurrections = [products  objectAtIndex:4];
    skProducts = [[NSMutableArray alloc] initWithObjects:twentyFiveThousandCoins, threeHundredThousandCoins, oneMillionFiveHundredThousandCoins, threeMillionSevenHundredFiftyThousandCoins, threeResurrections, nil];
    
    for (int i = 0; i < [products count]; i++) {
        SKProduct *exampleProduct = [products objectAtIndex:i];
        NSLog(@"Product title: %@" , exampleProduct.localizedTitle);
        NSLog(@"Product description: %@" , exampleProduct.localizedDescription);
        NSLog(@"Product price: %@" , exampleProduct.price);
        NSLog(@"Product id: %@" , exampleProduct.productIdentifier);
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

#pragma -
#pragma Public methods

//
// kick off the upgrade transaction
//

- (void)purchaseTwentyFiveThousandCoins
{
    SKPayment *payment = [SKPayment paymentWithProduct:[skProducts objectAtIndex:0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    NSLog(@"purchaseTwentyFiveThousandCoins.");
}

- (void)purchaseThreeHundredThousandCoins
{
    SKPayment *payment = [SKPayment paymentWithProduct:[skProducts objectAtIndex:1]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    NSLog(@"purchaseThreeHundredThousandCoins.");
}

- (void)purchaseOneMillionFiveHundredThousandCoins
{
    SKPayment *payment = [SKPayment paymentWithProduct:[skProducts objectAtIndex:2]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    NSLog(@"purchaseOneMillionFiveHundredThousandCoins.");
}

- (void)purchaseThreeMillionSevenHundredFiftyCoins
{
    SKPayment *payment = [SKPayment paymentWithProduct:[skProducts objectAtIndex:3]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    NSLog(@"purchaseThreeMillionSevenHundredFiftyCoins.");
}

- (void)purchaseThreeResurrections
{
    SKPayment *payment = [SKPayment paymentWithProduct:[skProducts objectAtIndex:4]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    NSLog(@"purchaseThreeResurrections. skProducts : %@", skProducts);
}

#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseNinetyNineCentPurchase])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:constants.PURCHASETWENTYFIVETHOUSANDCOINS];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"Saved a record in userdefaults of 25,000 coins.");
    } else if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseOneNinetyNinePurchase]) {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:constants.PURCHASETHREEHUNDREDTHOUSANDCOINS];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"Saved a record in userdefaults of 300,000 coins.");
    } else if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseFourNinetyNinePurchase]) {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:constants.PURCHASEONEMILLIONFIVEHUNDREDTHOUSANDCOINS];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"Saved a record in userdefaults of 1,500,000 coins.");
    } else if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseNineNinetyNinePurchase]) {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:constants.PURCHASETHREEMILLIONSEVENHUNDREDFIFTYTHOUSANDCOINS];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"Saved a record in userdefaults of 3,750,000 coins.");
    } else if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseThreeResurrections]) {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:constants.PURCHASETHREEMILLIONSEVENHUNDREDFIFTYTHOUSANDCOINS];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"Saved a record in userdefaults of 3 resurrections coins.");
    }
}

//
// enable pro features
// this is where we will unlock the purchased item.
//
- (void)provideContent:(NSString *)productId
{
    NSLog(@"Providing content for productId : %@", productId);
    if ([productId isEqualToString:kInAppPurchaseNinetyNineCentPurchase])
    {
        // enable the features
        [[SaveLoadDataDevice sharedManager] setPlayersCoins:[[[[SaveLoadDataDevice sharedManager] getCharData] objectForKey:constants.TOTALCOINS] intValue] + 25000];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [delegate updateTotalCoinsLabel];
        [delegate transactionCompleteTransType:0];
        NSLog(@"25,000 coins awarded and saved to the device.");
    }
    else if ([productId isEqualToString:kInAppPurchaseOneNinetyNinePurchase]) {
        // enable the features
        [[SaveLoadDataDevice sharedManager] setPlayersCoins:[[[[SaveLoadDataDevice sharedManager] getCharData] objectForKey:constants.TOTALCOINS] intValue] + 300000];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [delegate updateTotalCoinsLabel];
        [delegate transactionCompleteTransType:1];
        NSLog(@"300,000 coins awarded and saved to the device.");
    }
    else if ([productId isEqualToString:kInAppPurchaseFourNinetyNinePurchase]) {
        // enable the features
        [[SaveLoadDataDevice sharedManager] setPlayersCoins:[[[[SaveLoadDataDevice sharedManager] getCharData] objectForKey:constants.TOTALCOINS] intValue] + 1500000];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [delegate updateTotalCoinsLabel];
        [delegate transactionCompleteTransType:2];
        NSLog(@"1,500,000 coins awarded and saved to the device.");
    }
    else if ([productId isEqualToString:kInAppPurchaseNineNinetyNinePurchase]) {
        // enable the features
        [[SaveLoadDataDevice sharedManager] setPlayersCoins:[[[[SaveLoadDataDevice sharedManager] getCharData] objectForKey:constants.TOTALCOINS] intValue] + 3750000];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [delegate updateTotalCoinsLabel];
        [delegate transactionCompleteTransType:3];
        NSLog(@"3,750,000 coins awarded and saved to the device.");
    }
    else if ([productId isEqualToString:kInAppPurchaseThreeResurrections]) {
        // enable the features
        for (int i = 0; i < 3; i++) {
            [[SaveLoadDataDevice sharedManager] addResurrection];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        [delegateBS threeResurrectionsPurchased];
        NSLog(@"3 resurrections awarded and saved to the device.");
    }
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"Canceled : %@", error);// test error.code, if it equals SKErrorPaymentCancelled it's been cancelled
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
    NSLog(@"Transaction complete and recorded.");
}

//
// called when a transaction has been restored and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                NSLog(@"transaction completed");
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                NSLog(@"transaction failed");
                [delegateBS transactionFailed];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                NSLog(@"transaction restored");
            default:
                break;
        }
    }
}

@end
