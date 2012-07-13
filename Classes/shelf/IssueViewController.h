//
//  IssueViewController.h
//
//  Created by Bart Termorshuizen on 6/18/11.
//  Modified/Adapted for BakerShelf by Andrew Krowczyk @nin9creative on 2/18/2012
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
#import <UIKit/UIKit.h>
#import "Publisher.h"


@interface IssueViewController : UIViewController <NSURLConnectionDownloadDelegate>{ 
    IBOutlet UILabel* labelView;
    IBOutlet UITextView* descriptionView;
    IBOutlet UIView* issueView;
    IBOutlet UIImageView* coverView;
    IBOutlet UIButton* buttonView;
    IBOutlet UIProgressView* progressView;
    IBOutlet UIActivityIndicatorView* activityView;
    NKIssue *nkIssue;
}

@property (nonatomic, retain) Publisher* publisher;
@property int index;

-(IBAction) btnClicked:(id) sender;
-(IBAction) btnRead:(id) sender;
-(void) openBakerThred;


@end


@interface alertView: UIAlertView <UIActionSheetDelegate> {
    
}
@end
