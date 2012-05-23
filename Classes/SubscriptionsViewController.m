//
//  BuySubscriptionViewController.m
//  Baker
//
//  Created by Bart on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SubscriptionsViewController.h"

@interface SubscriptionsViewController ()

@end

@implementation SubscriptionsViewController
@synthesize tvSubscriptions = _tvSubscriptions;
@synthesize delegate = _delegate;
@synthesize subscriptionInfos = _subscriptionInfos;
@synthesize subscriptionIDs = _subscriptionIDs;
@synthesize subscriptions = _subscriptions;
@synthesize productHelper = _productHelper;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _subscriptionInfos = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Subscriptions"];
        NSMutableArray* temp = [[[NSMutableArray alloc] initWithCapacity:[_subscriptionInfos count]] autorelease];
        for (NSDictionary* d in _subscriptionInfos){
            [temp addObject:[d objectForKey:@"ProductIdentifier"]];
        }
        _subscriptionIDs = [NSArray arrayWithArray:temp];
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed)];
        [self.navigationItem setRightBarButtonItem:okButton animated:NO];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([SKPaymentQueue canMakePayments]){
        // Do any additional setup after loading the view from its nib.
        [self.navigationItem setTitle:@"Loading subscriptions..."];
        
        _productHelper = [[IAPProducts alloc] initWithProductIdentifiers:_subscriptionIDs 
                                                        isPurchasedBlock:^BOOL(NSString * pid, NSDictionary * receipt) {
                                                            return [self product:pid isPurchasedWithReceipt:receipt];
                                                        } 
                                                     withCompletionBlock:^(BOOL success) {
                                                         if (success){
                                                             [self performSelector:@selector(startProductRequest) withObject:self afterDelay:1.0 ];
                                                         }
                                                     }];              
    }
    else {
        NSLog(@"Cannot make payments - cancelling the subscription view");
        [[self delegate] modalViewControllerCanceled]; // 
    }
    
}

-(void)startProductRequest{
    if (_productHelper){
        [_productHelper startRequestWithCompletionBlock:^(BOOL success, NSArray* products) {
            if (success){
                [self productsDidFinish:products];
            }
        }];
    }
    else {
        NSLog(@"mmmm");
    }
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
    [self setTvSubscriptions:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_delegate release];
    [_subscriptions release];
    [_subscriptionInfos release];
    [_subscriptionIDs release];
    [_tvSubscriptions release];
    [_productHelper release];
    [super dealloc];
}

- (void) doneButtonPressed
{
    [[self delegate] modalViewControllerIsDone];
}

- (void) cancelButtonPressed
{
    [[self delegate] modalViewControllerCanceled];
    
}

-(void)restoreTransactions{
    NSLog(@"Restoring transactions");
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

-(void)productsDidFinish:(NSArray*) products {
    if (_subscriptions){
        [_subscriptions release];
    }
    _subscriptions = [[[NSMutableArray alloc] init] retain];
    for (SKProduct* p in products){
        [p retain];
        [_subscriptions addObject:p];
    }
    
    [self.navigationItem setTitle:@"Subscriptions"];
    
    [_tvSubscriptions reloadData];
}


#pragma mark table view delegate & datasource protocol
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_subscriptions  count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setFrame:CGRectMake(0, 0, 100, 35)];
        [button addTarget:self action:@selector(btnBuyClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:indexPath.row];
        cell.accessoryView = button;
        [button release];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}




- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    SKProduct* subscription = [_subscriptions objectAtIndex:indexPath.row];
    NSLog(@"%@",[subscription localizedDescription]);
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:subscription.priceLocale];
    NSString *formattedPrice = [numberFormatter stringFromNumber:subscription.price];
    
    NSString* buttonTitle;
    if ([_productHelper isPurchasedProduct:subscription.productIdentifier]) 
        buttonTitle = @"Bought";
    else 
        buttonTitle = [NSString stringWithFormat:@"Buy (%@)",formattedPrice];
    
    NSString* textLabelText;
    
    
    NSDictionary* d = [self getSubscriptionInfo:subscription.productIdentifier];
    
    if (d){
        NSString* localizedDuration = [d objectForKey:@"LocalizedDuration"];
        if (localizedDuration) 
            textLabelText = [NSString stringWithFormat:@"%@ (%@)",[subscription localizedDescription],localizedDuration];
        else 
            textLabelText = [subscription localizedDescription];
        
        [[cell textLabel] setText:textLabelText];
        UIButton* button = (UIButton*)cell.accessoryView;
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        if ([_productHelper isPurchasedProduct:subscription.productIdentifier]) 
            [button setEnabled:NO];
        else 
            [button setEnabled:YES];
    }
    else {
        [[cell textLabel] setText:@"Unknown product"];
    }
}

-(void)btnBuyClick:(id)sender {
    //Get the superview from this button which will be our cell
	UIButton *button = (UIButton *)sender;
    int row = button.tag;
    SKProduct* sub = [_subscriptions objectAtIndex:row];
    NSLog(@"%@",sub);
    

    SKPayment *paymentRequest = [SKPayment paymentWithProductIdentifier: sub.productIdentifier]; 
	
	// Request a purchase of the selected item.
	[[SKPaymentQueue defaultQueue] addPayment:paymentRequest];

}

- (BOOL)product:(NSString*)pid isPurchasedWithReceipt:(NSDictionary*)receipt
{
    // get info of the product
    NSDictionary* subscriptionInfo = [self getSubscriptionInfo:pid];
    if (subscriptionInfo)
    {
        NSString* productType = [subscriptionInfo objectForKey:@"Type"];
        if ([productType isEqualToString:@"Auto-Renewable"]){
            NSNumber* duration = [subscriptionInfo objectForKey:@"Duration"]; // is in months
            NSNumber* purchaseDateMs = [receipt objectForKey:@"purchase_date_ms"];
            long long purchaseDateMsI = [purchaseDateMs longLongValue]/1000;
            NSDate* purchaseDate = [NSDate dateWithTimeIntervalSince1970:purchaseDateMsI];
            NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
            [components setMonth: [duration intValue]];
            [components setDay:0];
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDate* dateAfterDurationFromPurchase = [calendar dateByAddingComponents:components toDate:purchaseDate options:0];
            
            NSDate* today = [NSDate date];
            if (today == [dateAfterDurationFromPurchase laterDate:today]) // expired
                return FALSE;
            else {
                return TRUE;
            }
        }
        else if ([productType isEqualToString:@"Free Subscription"]){
            return TRUE; // never expires
        }
        else {
            return FALSE; // unknown product
        }
    }
    return NO;
}

- (NSDictionary*) getSubscriptionInfo:(NSString*)pid{

    for (NSDictionary* i in _subscriptionInfos){
        if ([pid isEqualToString:[i objectForKey:@"ProductIdentifier"]]){
            return i;
        }
    }
    return nil;
}

#pragma mark SKPaymentTransactionObserver protocol implementation
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
	for(SKPaymentTransaction *transaction in transactions) {
		switch (transaction.transactionState) {
				
			case SKPaymentTransactionStatePurchasing:
                NSLog(@"Purchasing...");
				break;
				
			case SKPaymentTransactionStatePurchased:
                NSLog(@"Purchased");
                [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:transaction.payment.productIdentifier ];
                [[NSUserDefaults standardUserDefaults] synchronize];
				[[SKPaymentQueue defaultQueue] finishTransaction: transaction];

                [_productHelper addPurchasedProduct:transaction.payment.productIdentifier];
                // update the UI to reflect the status change
                [_tvSubscriptions reloadData];
				break;
				
			case SKPaymentTransactionStateRestored:
                NSLog(@"Restored");
                [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:transaction.payment.productIdentifier ];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                
                [_productHelper addPurchasedProduct:transaction.payment.productIdentifier];
                // update the UI to reflect the status change
                [_tvSubscriptions reloadData];
				break;
				
			case SKPaymentTransactionStateFailed:
                NSLog(@"Transaction failed with error: %@",[transaction.error localizedDescription]);
				[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
				break;
		}
	}
}
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions{
    
}
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"Error: %@",error);
}
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
}

@end
