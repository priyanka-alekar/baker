//
//  Content.m
//  SitelessMagazine
//
//  Created by Bart Termorshuizen on 7/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Content.h"
#import "Issue.h"
#import "SSZipArchive.h"
#import "IssueViewController.h"


@implementation Content
@dynamic path;
@dynamic url;
@dynamic issue;


- (void)resolve:(UIProgressView *) progressView
{
    // Set the progress view
    progressViewC = progressView;
    
    // Create the request.
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[[NSURL alloc] initWithString:[self url]]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    NSLog(@"Resolving content from: %@",[self url]);
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        receivedData = [[NSMutableData data] retain];
    } else {
        NSLog(@"Content - resolve: connection failed");
    }
    return;
    
}

/*
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
}
 */

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
	NSDictionary *allHeaders = [((NSHTTPURLResponse *)response) allHeaderFields];
	NSLog(@"%@", allHeaders);

    
	if ([response respondsToSelector:@selector(statusCode)]) 
	{
		int statusCode = [((NSHTTPURLResponse *)response) statusCode];
		
		// IF THE PAGE CANNOT BE FOUND CANCEL THE DOWNLOAD AND PRESENT A WARNING MESSAGE
        if (statusCode != 200)  
		{
			[connection cancel]; 
			NSString *errorMessage = [NSString stringWithFormat:@"Unable to download the prices file.  Prices shown may therefore not be current."];
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occured" message:errorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			
			[alertView show];
			[alertView release], alertView = nil;
            
            // OTHERWISE CONTINUE WITH THE DOWNLOAD
		} else {
			if ( [response expectedContentLength] != NSURLResponseUnknownLength )
			{
				filesize = [[NSNumber numberWithLong: [response expectedContentLength] ] retain];
				NSLog(@"Length Avaialble (%@)", filesize);
			}
			else
			{
				//NSDictionary *allHeaders = 
				NSLog(@"Length NOT Avaialble");
			}
            
			//NSLog(@"Started to receive data");
            [receivedData setLength:0];
		}
    }
}


/*
// this message allows us to update the download progress
-(void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes {
    [self setDownloadProgress:1.*totalBytesWritten/expectedTotalBytes];
}
*/

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    float progress;
    progress = [receivedData length]/[filesize floatValue];

    //NSLog(@"PROGRESS: %f", progress);
    
    // Update the progress value
    progressViewC.hidden = NO;
    progressViewC.progress = progress;

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
    NSLog(@"Content - Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    return;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
    
    // Make progress bar invisible
    progressViewC.hidden = YES;
    

    // we've downloaded the cover image
    // now we're storing it on a path on the file system
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    // filename = [issue mag] + [issue number] + "zipissue"
    NSString *issueNumber = [[[self issue] number] stringValue];
    NSString *zipFileName = [[[[self issue] mag] stringByAppendingString:issueNumber] stringByAppendingString:@"zipissue"];
    NSString *fileName = [[[[self issue] mag] stringByAppendingString:issueNumber] stringByAppendingString:@"issue"];
   
    // full path = documentsDir || fileName
    NSString *path = [documentsDir stringByAppendingPathComponent:fileName];
    
    // full zippath = documentsDir || zipfileName
    NSString *zipPath = [documentsDir stringByAppendingPathComponent:zipFileName];
    
    
    NSError *error = nil;
    
    [receivedData writeToFile:zipPath options:NSDataWritingAtomic error:&error];
    if (error){
        NSLog(@"Content - Connection failed! Error - %@  - %@",[error localizedDescription],[error userInfo]);
    }
    else {
        // unzip
        
        [SSZipArchive unzipFileAtPath:zipPath toDestination:path overwrite:YES password:nil error:&error ];
        // remove downloaded file
        [[NSFileManager defaultManager] removeItemAtPath:zipPath error:NULL];
        if (error){
            NSLog(@"Content - Unzip failed! Error - %@  - %@",[error localizedDescription],[error userInfo]);
        }
        else {
            // update path component
            [self setPath:path];
            // notify all interested parties of the uploaded and unpacked content
            [[NSNotificationCenter defaultCenter] postNotificationName:@"contentDownloaded" object:self];
        }
        
        
    }
    
    [connection release];
    [receivedData release];
    return;
}


@end
