//
//  TPMultiLayoutViewController.h
//
//  Created by Michael Tyson on 14/08/2011.
//  https://github.com/michaeltyson/TPMultiLayoutViewController
//  
#import <UIKit/UIKit.h>

@interface TPMultiLayoutViewController : UIViewController {
    UIView *portraitView;
    UIView *landscapeView;
    
@private
    NSDictionary *portraitAttributes;
    NSDictionary *landscapeAttributes;
    BOOL viewIsCurrentlyPortrait;
}

// Call directly to use with custom animation (override willRotateToInterfaceOrientation to disable the switch there)
- (void)applyLayoutForInterfaceOrientation:(UIInterfaceOrientation)newOrientation;

@property (nonatomic, retain) IBOutlet UIView *landscapeView;
@property (nonatomic, retain) IBOutlet UIView *portraitView;
@end