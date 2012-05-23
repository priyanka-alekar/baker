//
//  IAPSubscriptions.m
//  Baker
//
//  Created by Bart on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IAPProducts.h"
#import "IAPReceipt.h"




@implementation IAPProducts
@synthesize productIDs = _productIDs;
@synthesize products = _products;
@synthesize purchasedProductIDs = _purchasedProductIDs;
@synthesize skProductsRequest = _skProductsRequest;
@synthesize completionBlock = _completionBlock;

// initializes with a set of product identifiers, checks the receipts if they are still valid and updates the purchasedproducts array
- (id)initWithProductIdentifiers:(NSArray *)pids isPurchasedBlock:(BOOL(^)(NSString*,NSDictionary*))purchased withCompletionBlock:(void(^)(BOOL))completion
{
    if ((self = [super init])) {
        [self setProductIDs : pids];
        _purchasedProductIDs = [[NSMutableArray alloc] init];
        __block int receiptCounter = 0;
        for (NSString * pi in _productIDs) {
            NSData* receipt = [[NSUserDefaults standardUserDefaults] dataForKey:pi];
            if (receipt){
                receiptCounter++;
                IAPReceipt* receiptCheckHelper = [[IAPReceipt alloc] init];
                [receiptCheckHelper checkReceipt:receipt ofProductID:pi withCompletionBlock:^(NSDictionary * receipt, BOOL success) {
                    if (success){
                        if (purchased(pi,receipt))
                            [self addPurchasedProduct:[receipt objectForKey:@"product_id"]];
                    }
                    else {
                        NSLog(@"Error checking receipt of product %@ :%@",pi,[receipt objectForKey:@"error"]);
                    }
                    receiptCounter = receiptCounter - 1;
                    if (receiptCounter == 0) 
                        completion(YES);
                }];
            }
        }
        if (receiptCounter == 0) 
            completion(YES);
    }
    return self;
}



- (void)startRequestWithCompletionBlock:(void(^)(BOOL,NSArray*))completion {
    [self setCompletionBlock:completion];
    NSSet* pids = [NSSet setWithArray:_productIDs];
    _skProductsRequest = [[[SKProductsRequest alloc] initWithProductIdentifiers:pids] autorelease];
    _skProductsRequest.delegate = self;
    [_skProductsRequest start];
    
}

- (BOOL)isPurchasedProduct:(NSString*)pid{
    // returns YES if the product id is in the array of purchasedProductIDs
    for (NSString* p in _purchasedProductIDs){
        if ([p isEqualToString:pid]) return YES;
    }
    return NO;
}

- (void)addPurchasedProduct:(NSString*)pid{
    [_purchasedProductIDs addObject:pid];
}

#pragma mark SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    if (_products){
        [_products release];
    }
    _products = [NSArray arrayWithArray:response.products];
    _skProductsRequest = nil;
    
    if ([response.invalidProductIdentifiers count]>0){
        NSLog(@"Invalid product identifiers");
    }
    _completionBlock(YES,_products);  
}

- (void)dealloc
{
    [_productIDs release];
    _productIDs = nil;
    [_products release];
    _products = nil;
    [_purchasedProductIDs release];
    _purchasedProductIDs = nil;
    [_skProductsRequest release];
    _skProductsRequest = nil;
    [super dealloc];
}

@end
