//
//  ToolbarViewController.m
//  Baker
//
//  ==========================================================================================
//  
//  Copyright (c) 2010-2011, Davide Casali, Marco Colombo, Alessandro Morandi
//  All rights reserved.
//  
//  Redistribution and use in source and binary forms, with or without modification, are 
//  permitted provided that the following conditions are met:
//  
//  Redistributions of source code must retain the above copyright notice, this list of 
//  conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this list of 
//  conditions and the following disclaimer in the documentation and/or other materials 
//  provided with the distribution.
//  Neither the name of the Baker Framework nor the names of its contributors may be used to 
//  endorse or promote products derived from this software without specific prior written 
//  permission.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
//  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT 
//  SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
//  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
//  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//  

#import "ToolbarViewController.h"

#import "BakerAppDelegate.h"    // **************
#import "InterceptorWindow.h"   // **************


@implementation ToolbarViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        disabled = NO;
        indexHeight = 0;
        
        [self setPageSizeForOrientation:UIInterfaceOrientationPortrait];
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

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    // Create toolbar
    UIToolbar *toolbar = [UIToolbar new];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.tintColor = [UIColor blackColor];
    toolbar.alpha = 0.9;
    [toolbar sizeToFit];
    toolbar.frame = CGRectMake(0, -60, pageWidth, 44);

    // Add buttons to toolbar
    UIBarButtonItem *systemItem1 = [[UIBarButtonItem alloc] initWithTitle:@"See all issues" 
                                                                    style:UIBarButtonItemStyleBordered 
                                                                   target:self 
                                                                   action:@selector(btnClicked:)];
    
    // Use this to put space in between your toolbox buttons
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    
    // Add buttons to the array
    NSArray *items = [NSArray arrayWithObjects: flexItem, systemItem1, nil];
    
    // Add array of buttons to toolbar
    [toolbar setItems:items animated:NO];
    
    // Set view
    self.view = toolbar;
    
    // Release buttons and toolbar
    [systemItem1 release];
    [flexItem release];
    [toolbar release];
    
    //[self loadContent];
}

- (void)setPageSizeForOrientation:(UIInterfaceOrientation)orientation {
	//CGRect screenBounds = [[UIScreen mainScreen] bounds];
	
	if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
		//pageWidth = screenBounds.size.height;
		//pageHeight = screenBounds.size.width;
		pageWidth = 1024;
    } else {
        //pageWidth = screenBounds.size.width;
		//pageHeight = screenBounds.size.height;
        pageWidth = 768;
	}
    
    UIApplication *sharedApplication = [UIApplication sharedApplication];
    if (sharedApplication.statusBarHidden) {
        pageY = 20;
    } else {
        pageY = -5;
    }
    
    NSLog(@"Set ToolbarView size to %dx%d, with pageY set to %d", pageWidth, pageHeight, pageY);
}

- (BOOL)isToolbarViewHidden {
    return [UIApplication sharedApplication].statusBarHidden;
}

- (BOOL)isDisabled {
    return disabled;
}

- (void)setToolbarViewHidden:(BOOL)hidden withAnimation:(BOOL)animation {
    CGRect frame;
    if (hidden) {
        //frame = CGRectMake(0, pageHeight + pageY, pageWidth, indexHeight);
        frame = CGRectMake(0, -60 + pageY, pageWidth, 44); // ******************

    } else {
        //frame = CGRectMake(0, pageHeight + pageY - indexHeight, pageWidth, indexHeight);
        frame = CGRectMake(0, pageY, pageWidth, 44);    //**************
    }
    
    if (animation) {
        [UIView beginAnimations:@"slideToolbarView" context:nil]; {
            [UIView setAnimationDuration:0.3];
            
            self.view.frame = frame;
        }
        [UIView commitAnimations];
    } else {
        self.view.frame = frame;
    }
    
}

- (void)fadeOut {
    [UIView beginAnimations:@"fadeOutToolbarView" context:nil]; {
        [UIView setAnimationDuration:0.0];
        
        self.view.alpha = 0.0;
    }
    [UIView commitAnimations];
}

- (void)fadeIn {
    [UIView beginAnimations:@"fadeInToolbarView" context:nil]; {
        [UIView setAnimationDuration:0.2];
        
        self.view.alpha = 1.0;
    }
    [UIView commitAnimations];
}

- (void)willRotate {
    [self fadeOut];
}

- (void)rotateFromOrientation:(UIInterfaceOrientation)fromInterfaceOrientation toOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    BOOL hidden = [self isToolbarViewHidden]; // cache hidden status before setting page size
    
    [self setPageSizeForOrientation:toInterfaceOrientation];
    [self setToolbarViewHidden:hidden withAnimation:NO];
    [self fadeIn];
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
    NSLog(@"button clicked");
    
    BakerAppDelegate *appDelegate = (BakerAppDelegate *)[[UIApplication sharedApplication] delegate];
    //UINavigationController* navigationController = [appDelegate navigationController];
    
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration: 0.50];
    
    //Hook To MainView
    //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:navigationController.view cache:YES];
    
    //avigationController popViewControllerAnimated:NO];    
    //[navigationController setToolbarHidden:NO animated:NO];
    
    
    //[UIView commitAnimations];
    //self.scrollView.delegate = nil;
    
    [self.view removeFromSuperview];
    
    [appDelegate reloadShelf];
    
    //appDelegate.window = nil;
    
    //appDelegate.window =[[[InterceptorWindow alloc] initWithTarget:rvc.scrollView eventsDelegate:rvc frame:[[UIScreen mainScreen]bounds]] autorelease];
    //appDelegate.window.backgroundColor = [UIColor whiteColor];
    //[appDelegate.window addSubview:rvc.view];
    //[appDelegate.window makeKeyAndVisible];
    
}



@end
