//
//  Content.h
//  SitelessMagazine
//
//  Created by Bart Termorshuizen on 7/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//#import <UIKit/UIKit.h>

@class Issue;

@interface Content : NSManagedObject {
    NSMutableData * receivedData;
    NSNumber *filesize;
    
    
    //IBOutlet UIProgressView* progressView;  // <---------------------

    

@private
}
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Issue * issue;

-(void)resolve;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;


//- (IBAction) setDownloadProgress:(float) value;      // <----------


@end
