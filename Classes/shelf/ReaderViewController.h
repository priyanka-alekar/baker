//
//  ReaderViewController.h
//  NavControllerTest
//
//  Created by Bart Termorshuizen on 7/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//#import "Pugpig/Pugpig.h"
#import "Issue.h"
#import "IndexViewController.h"
#import "Properties.h"


@class Downloader;

@interface ReaderViewController : UIViewController < UIWebViewDelegate, UIScrollViewDelegate >{
    Issue* issue;
    
    CGRect screenBounds;
	
	NSString *documentsBookPath;
    NSString *bundleBookPath;
    NSString *defaultScreeshotsPath;
    NSString *cachedScreenshotsPath;
    
    NSString *availableOrientation;
    NSString *renderingType;
	
	NSMutableArray *pages;
    NSMutableArray *toLoad;
    NSMutableArray *pageDetails;
    UIImage *backgroundImageLandscape;
    UIImage *backgroundImagePortrait;
    
	NSString *pageNameFromURL;
	NSString *anchorFromURL;
	
    int tapNumber;
    int stackedScrollingAnimations;
    
	BOOL currentPageFirstLoading;
	BOOL currentPageIsDelayingLoading;
    BOOL currentPageHasChanged;
    BOOL currentPageIsLocked;
    
	BOOL discardNextStatusBarToggle;
    
    UIScrollView *scrollView;
	UIWebView *prevPage;
	UIWebView *currPage;
	UIWebView *nextPage;
	
	CGRect upTapArea;
	CGRect downTapArea;
	CGRect leftTapArea;
	CGRect rightTapArea;
    
	int totalPages;
    int lastPageNumber;
	int currentPageNumber;
	
    int pageWidth;
	int pageHeight;
    int currentPageHeight;
	
	NSString *URLDownload;
    Downloader *downloader;
	UIAlertView *feedbackAlert;
    
    IndexViewController *indexViewController;
    
    Properties *properties;
    
}

//@property (nonatomic, retain) IBOutlet KGPagedDocControl *pageControl;
//@property (nonatomic, retain) IBOutlet KGPagedDocThumbnailControl *thumbnailControl;
@property (nonatomic, retain) IBOutlet UIButton* button;
@property (nonatomic, retain) Issue* issue;

#pragma mark - PROPERTIES
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIWebView *currPage;
@property int currentPageNumber;

#pragma mark - INIT
- (void)setupWebView:(UIWebView *)webView;
- (void)setPageSize:(NSString *)orientation;
- (void)setTappableAreaSize;
- (void)resetScrollView;
- (void)initPageDetails;
- (void)showPageDetails;
- (void)resetPageDetails;
- (void)initBookProperties:(NSString *)path;
- (void)initBook:(NSString *)path;
- (void)setImageFor:(UIImageView *)view;
- (void)addSkipBackupAttributeToItemAtPath:(NSString *)path;

#pragma mark - LOADING
- (BOOL)changePage:(int)page;
- (void)gotoPageDelayer;
- (void)gotoPage;
- (void)lockPage:(BOOL)lock;
- (void)addPageLoading:(int)slot;
- (void)handlePageLoading;
- (void)loadSlot:(int)slot withPage:(int)page;
- (BOOL)loadWebView:(UIWebView *)webview withPage:(int)page;

#pragma mark - SCROLLVIEW
- (CGRect)frameForPage:(int)page;
- (void)resetScrollView;

#pragma mark - WEBVIEW
- (void)webView:(UIWebView *)webView hidden:(BOOL)status animating:(BOOL)animating;
- (void)webViewDidAppear:(UIWebView *)webView animating:(BOOL)animating;

#pragma mark - SCREENSHOTS
- (void)initScreenshots;
- (BOOL)checkScreeshotForPage:(int)pageNumber andOrientation:(NSString *)interfaceOrientation;
- (void)takeScreenshotFromView:(UIWebView *)webView forPage:(int)pageNumber andOrientation:(NSString *)interfaceOrientation;
- (void)placeScreenshotForView:(UIWebView *)webView andPage:(int)pageNumber andOrientation:(NSString *)interfaceOrientation;

#pragma mark - GESTURES
- (void)userDidTap:(UITouch *)touch;
- (void)userDidScroll:(UITouch *)touch;

#pragma mark - PAGE SCROLLING
- (void)getPageHeight;
- (void)goUpInPage:(NSString *)offset animating:(BOOL)animating;
- (void)goDownInPage:(NSString *)offset animating:(BOOL)animating;
- (void)scrollPage:(UIWebView *)webView to:(NSString *)offset animating:(BOOL)animating;
- (void)handleAnchor:(BOOL)animating;

#pragma mark - STATUS BAR
- (void)toggleStatusBar;
- (void)hideStatusBar;
- (void)hideStatusBarDiscardingToggle:(BOOL)discardToggle;

#pragma mark - DOWNLOAD NEW BOOKS
- (void)downloadBook:(NSNotification *)notification;
- (void)startDownloadRequest;
- (void)handleDownloadResult:(NSNotification *)notification;
- (void)manageDownloadData:(NSData *)data;

#pragma mark - ORIENTATION
- (NSString *)getCurrentInterfaceOrientation;
-(IBAction) btnClicked:(id) sender;


@end



