//
//  IssueViewController.h
//  SitelessMag
//
//  Created by Bart Termorshuizen on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
