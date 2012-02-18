//
//  Content.h
//
//  Created by Bart Termorshuizen on 7/10/11.
//  Modified/Adapted for BakerShelf by Andrew Krowczyk @nin9creative on 2/18/2012
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Issue;

@interface Content : NSManagedObject {
    NSMutableData * receivedData;
    NSNumber *filesize;
    UIProgressView *progressViewC;

@private
}
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Issue * issue;


//-(void)resolve;
- (void)resolve:(UIProgressView *) progressViewC;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
