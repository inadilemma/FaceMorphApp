//
//  InAppPurchaseManager.h
//  MyAgingBooth
//
//  Created by Mahmud on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"

//***************************//
//only edit this productID when you upload your app to itunesConnect and generate in-app purchase productId
//***************************//
#define kInAppPurchaseProUpgradeProductId @"mahmud.MyAgingBooth.TestAgingBoothUpgrade"
//***************************//


// add a couple notifications sent out when the transaction completes

#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"

@class InAppPurchaseManager;
@protocol PurchaseDelegate <NSObject>
@optional
- (void) proceedToNextScreen:(BOOL)flag;
@end

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
    id <PurchaseDelegate> delegate;
}

@property(nonatomic,assign) id <PurchaseDelegate> delegate;


- (void)requestProUpgradeProductData;

// public methods
- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchaseProUpgrade;
@end