//
//  IssueViewController.h
//
//  Created by Bart Termorshuizen on 6/18/11.
//  Modified/Adapted for BakerShelf by Andrew Krowczyk @nin9creative on 2/18/2012
//

#import <UIKit/UIKit.h>

@class Issue;


@interface IssueViewController : UIViewController {
    Issue* issue;
    IBOutlet UILabel* labelView;
    IBOutlet UITextView* descriptionView;
    IBOutlet UIView* issueView;
    IBOutlet UIImageView* coverView;
    IBOutlet UIButton* buttonView;
    IBOutlet UIProgressView* progressView;
}

@property (nonatomic, retain) Issue* issue;


-(IBAction) btnClicked:(id) sender;
-(IBAction) btnRead:(id) sender;

- (void) resolvedCover:(NSNotification *) notification;
- (void) downloadedContent:(NSNotification *) notification;

@end
