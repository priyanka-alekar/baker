//
//  IAPReceipt.m
//  Baker
//
//  Created by Bart on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IAPReceipt.h"
#import "NSData+Base64.h"
#import "JSON.h"

@implementation IAPReceipt
@synthesize receiptResponse = _receiptResponse;
@synthesize completionBlock = _completionBlock;

-(void)checkReceipt:(NSData*)receipt ofProductID:(NSString*)pid  withCompletionBlock:(void(^)(NSDictionary *, BOOL))completion {
    
    [self setCompletionBlock:completion];
    
    NSString *receiptBase64Encoded = [receipt base64EncodedString];
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          receiptBase64Encoded,@"receipt-data",
                          kSharedSecret,@"password",
                          nil];
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (error){
        NSLog(@"Error serializing dictionary: %@",[error localizedDescription]);
    }
    
    NSURL *requestURL = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:jsonData];
    NSURLConnection *c = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if(c)
        _receiptResponse = [[NSMutableData alloc] init];
    else
        NSLog(@"Cannot create connection to verify receipts");
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Retain count %i", [_completionBlock retainCount] );
    NSLog(@"Error verifying receipts: %@",[error localizedDescription]);
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [_receiptResponse setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_receiptResponse appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSError* error = nil;
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:_receiptResponse options:NSJSONReadingAllowFragments error:&error];
    if (error){
        _completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"],NO);
    }
    else {
        NSNumber* status = [dict objectForKey:@"status"];
        NSDictionary* receipt = [dict objectForKey:@"receipt"];
        if ([status isEqualToNumber:[NSNumber numberWithInt:0]])
            _completionBlock(receipt,YES);
        else {
            NSString* errorMsg = [NSString stringWithFormat:@"Error status: %@",status];
            NSDictionary* dict = [NSDictionary dictionaryWithObject:errorMsg forKey:@"error"]; 
            _completionBlock(dict,NO);
        }
    }
}
@end
