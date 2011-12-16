//
//  LibraryViewController.h
//  SitelessMag
//
//  Created by Bart Termorshuizen on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IssueViewController;


@interface LibraryViewController : UIViewController {

    NSMutableArray *issueViewControllers;
    IBOutlet UIScrollView *scrollView;
    
    NSManagedObjectContext *managedObjectContext;
    
    NSMutableArray *issuesArray;
    @private NSInteger numberOfIssuesShown; 
    @private NSInteger numberOfPagesShown; 
    
    NSMutableData * receivedData;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *issuesArray;
@property (nonatomic) NSInteger numberOfIssuesShown;
@property (nonatomic) NSInteger numberOfPagesShown;


- (void)sync:(id) sender;

- (void) layout:(IssueViewController *)ivc;
- (void) resolvedCover:(NSNotification *) notification;
- (void) downloadedContent:(NSNotification *) notification;
- (void) archivedContent:(NSNotification *) notification;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
