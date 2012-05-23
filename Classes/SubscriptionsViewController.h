//
//  BuySubscriptionViewController.h
//  Baker
//
//  Created by Bart on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalViewControllerDelegate.h"
#import "IAPProducts.h"

@interface SubscriptionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,SKPaymentTransactionObserver>

@property (retain, nonatomic) NSArray* subscriptionInfos; // array of subscription info (dictionaries) from the main bundles plist
@property (retain, nonatomic) NSArray* subscriptionIDs; // array of subscriptionIDs (NSString) from the main bundles plist
@property (retain, nonatomic) NSMutableArray* subscriptions; // array of products
@property (retain, nonatomic) IBOutlet UITableView *tvSubscriptions;
@property (retain, nonatomic) id<ModalViewControllerDelegate> delegate;
@property (retain, nonatomic) IAPProducts *productHelper;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end
