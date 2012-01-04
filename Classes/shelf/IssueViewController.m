//
//  IssueViewController.m
//  SitelessMag
//
//  Created by Bart Termorshuizen on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IssueViewController.h"
#import "Issue.h"
#import "Cover.h"
#import "Content.h"
#import "BakerAppDelegate.h"
#import "InterceptorWindow.h"

@implementation IssueViewController

@synthesize issue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // Initiate issue status
        [issue setStatus:[NSNumber numberWithInt:-1]];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGRect frame = issueView.frame;                    
    [[self view] setFrame:frame];
    
    [labelView setText:[issue title]];
    [descriptionView setText:[issue descr]];
    
    Cover *c =(Cover *)[issue cover];
    if ([[c path] isEqualToString:@""] || [c path] == nil) {
        // use dummy image
    }
    else {
        UIImage * coverImage = [[UIImage alloc] initWithContentsOfFile:[(Cover *)[issue cover] path]];
        [coverView setImage:coverImage];
        [coverImage release];
    }
    
    if ([[issue status] intValue] == 1 ) // issue is not downloaded
    {
        [buttonView setTitle:@"Download" forState:UIControlStateNormal];
    }
    if ([[issue status] intValue] == 2) // issue is downloaded - can be archived
    {
        [buttonView setTitle:@"Archive" forState:UIControlStateNormal];
    }    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resolvedCover:) name:@"coverResolved" object:nil ] ;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadedContent:) name:@"contentDownloaded" object:nil ] ;

    
    // Clear the progressbar and make it invisible
    progressView.progress = 0;
    progressView.hidden = YES;
    
    return;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(IBAction) btnClicked:(id) sender {
    
    if ([[issue status] intValue] != 0 ) // issue is NOT downloading
    {
      if ([[issue status] intValue] == 1 ) // issue is not downloaded
      {
          // Set status do 0 -> DOWNLOADING
          [issue setStatus:[NSNumber numberWithInt:0]];
          [buttonView setTitle:@"Wait..." forState:UIControlStateNormal];

          // Set progressView to Content
          [(Content *)[issue content] resolve:progressView];
      }
      else if ([[issue status] intValue] == 2 ) // issue is downloaded - needs to be archived
      {
          NSError * error = nil;
          [[NSFileManager defaultManager] removeItemAtPath:[(Content *)[issue content] path]  error:&error];
          if (error) {
              // implement error handling
          }
          else {
              Content * c = (Content *)[issue content];
              [c setPath:@""];
              [issue setStatus:[NSNumber numberWithInt:1]];
              [buttonView setTitle:@"Download" forState:UIControlStateNormal];
              // notify all interested parties of the archived content
              [[NSNotificationCenter defaultCenter] postNotificationName:@"contentArchived" object:self]; // make sure its persisted!
          }
      }
    }
}

-(IBAction) btnRead:(id) sender{
    if ([[issue status] intValue] == 2 ) // issue is downloaded
    {

        // Create the application window
        //self.window = [[[InterceptorWindow alloc] initWithTarget:self.rootViewController.scrollView eventsDelegate:self.rootViewController frame:[[UIScreen mainScreen]bounds]] autorelease];
        //window.backgroundColor = [UIColor whiteColor];
        
        // Add the root view to the application window
        //[window addSubview:rootViewController.view];
        //[window makeKeyAndVisible];
    
        
        NSLog(@"IssueViewController - opening reader");  
        BakerAppDelegate *appDelegate = (BakerAppDelegate *)[[UIApplication sharedApplication] delegate];
        //UINavigationController* navigationController = [appDelegate navigationController];
        ReaderViewController* rvc = [appDelegate rvc];
        
        [rvc setIssue:issue];
        [rvc init];
        
        appDelegate.window =[[[InterceptorWindow alloc] initWithTarget:rvc.scrollView eventsDelegate:rvc frame:[[UIScreen mainScreen]bounds]] autorelease];
        //appDelegate.window.backgroundColor = [UIColor whiteColor];
        [appDelegate.window addSubview:rvc.view];
        [appDelegate.window makeKeyAndVisible];
        
        
        
        //[UIView beginAnimations:nil context:NULL];
        //[UIView setAnimationDuration: 0.50];
        
        //Hook To MainView
        //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:navigationController.view cache:YES];
        
        //[navigationController pushViewController:(UIViewController*)rvc animated:YES];    
        //[navigationController setToolbarHidden:YES animated:NO];
        
        //[UIView commitAnimations];
            
    }
    else // issue is not downloaded 
    {
        NSLog(@"Cannot read");        
    }
}

- (void) resolvedCover:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"coverResolved"]){
        // check if it is the correct cover
        if ([notification object] == [issue cover]){
            NSLog (@"IssueViewController: Received the coverResolved notification!");
            UIImage * coverImage = [[UIImage alloc] initWithContentsOfFile:[(Cover *)[issue cover] path]];
            [coverView setImage:coverImage];
            [coverImage release];
        }
                
    }
    
}

- (void) downloadedContent:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"contentDownloaded"]){
        // check if it is the correct cover
        if ([notification object] == [issue content]){
            NSLog (@"IssueViewController: Received the contentDownloaded notification!");
            [issue setStatus:[NSNumber numberWithInt:2]];
            [buttonView setTitle:@"Archive" forState:UIControlStateNormal];
        }
        
    }
    
}

@end
