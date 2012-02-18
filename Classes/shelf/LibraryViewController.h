//
//  LibraryViewController.h
//
//  Created by Bart Termorshuizen on 6/17/11.
//  Modified/Adapted for BakerShelf by Andrew Krowczyk @nin9creative on 2/18/2012
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
    
    IBOutlet UIToolbar *shelfToolBar;
    IBOutlet UILabel *shelfTitle;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *issuesArray;
@property (nonatomic) NSInteger numberOfIssuesShown;
@property (nonatomic) NSInteger numberOfPagesShown;


//- (void)sync:(id) sender;
-(IBAction) sync:(id) sender;

//- (void) layout:(IssueViewController *)ivc;
- (void) layout: (IssueViewController *)ivc setOrientation: (UIInterfaceOrientation) interfaceOrientation;
- (void) resolvedCover:(NSNotification *) notification;
- (void) downloadedContent:(NSNotification *) notification;
- (void) archivedContent:(NSNotification *) notification;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
