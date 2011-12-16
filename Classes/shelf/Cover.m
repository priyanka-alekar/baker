//
//  Cover.m
//  SitelessMagazine
//
//  Created by Bart Termorshuizen on 7/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Cover.h"
#import "Issue.h"


@implementation Cover
@dynamic path;
@dynamic url;
@dynamic issue;

-(void)resolve
{
    // Create the request.
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[[NSURL alloc] initWithString:[self url]]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        receivedData = [[NSMutableData data] retain];
    } else {
        NSLog(@"Cover - resolve: connection failed");
    }
    return;
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
    return;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
    
    // inform the user
    NSLog(@"Cover - Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    return;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
  
    // we've downloaded the cover image
    // now we're storing it on a path on the file system
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    // filename = [issue mag] + [issue number]
    NSString *issueNumber = [[[self issue] number] stringValue];
    NSString *fileName = [[[self issue] mag] stringByAppendingString:issueNumber];
   
    // full path = documentsDir || fileName
    NSString *path = [documentsDir stringByAppendingPathComponent:fileName];
    
    NSError *error = nil;
    
    [receivedData writeToFile:path options:NSDataWritingAtomic error:&error];
    if (error){
        NSLog(@"Cover - Connection failed! Error - %@  - %@",[error localizedDescription],[error userInfo]);
    }
    else {
        // update path component
        [self setPath:path];
        
        // notify all interested parties of the uploaded cover
         [[NSNotificationCenter defaultCenter] postNotificationName:@"coverResolved" object:self];
    }

    [connection release];
    [receivedData release];
    return;
}

@end
