//
//  Publisher.m
//  Newsstand
//
//  Created by Carlo Vigiani on 18/Oct/11.
//  Copyright (c) 2011 viggiosoft. All rights reserved.
//

#import "Publisher.h"
#import <NewsstandKit/NewsstandKit.h>
#import "JSON.h"



@interface Publisher ()



@end

@implementation Publisher 

@synthesize ready;

-(id)init {
    self = [super init];
    if(self) {
        ready = NO;
        issues = nil;
    }
    return self;
}

-(void)dealloc {
    [issues release];
    [super dealloc];
}

-(void)getIssuesList {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
                   ^{
                       // The Info.plist is considered the mainBundle.
                       NSBundle* mainBundle = [NSBundle mainBundle]; 
                       NSString* library_url = [NSString stringWithFormat:@"%@issueslist.json", [mainBundle objectForInfoDictionaryKey:@"IssueListURL"]];
                       NSData* tmpData = [NSData dataWithContentsOfURL:[NSURL URLWithString:library_url]]; 
                       
                       NSString* cacheDir = CacheDirectory;
                       NSString* cachePath = [cacheDir stringByAppendingPathComponent:@"issueslist.json"];
                       
                       if (!tmpData){
                           // attempt to get the data from the cache
                           tmpData = [NSData dataWithContentsOfFile:cachePath];
                       }
                       
                       if(!tmpData) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                                   [[NSNotificationCenter defaultCenter] postNotificationName:kPublisherFailedUpdateNotification object:self];
                           });
                          
                       } else {
                           //write in the cachedir
                           
                           [tmpData writeToFile:cachePath atomically:YES];
                           
                           NSString *jsonString = [[NSString alloc] initWithData:tmpData encoding:NSASCIIStringEncoding];
                           NSDictionary *results = [jsonString JSONValue];
                           
                           // Build an array from the dictionary for easy access to each entry
                           NSArray * json_issues = [[NSArray arrayWithArray: [results objectForKey:@"issues"]] retain];
                           
                           if(issues) {
                               [issues release];
                           }
                           issues = [[NSArray alloc] initWithArray:json_issues];
                           ready = YES;
                           [self addIssuesInNewsstand];
                           NSLog(@"%@",issues);
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [[NSNotificationCenter defaultCenter] postNotificationName:kPublisherDidUpdateNotification object:self];
                           });
                       }
                   });
}

-(void)addIssuesInNewsstand {
    NKLibrary *nkLib = [NKLibrary sharedLibrary];
    [issues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *name = [(NSDictionary *)obj objectForKey:@"title"];
        NKIssue *nkIssue = [nkLib issueWithName:name];
        if(!nkIssue) {
            // date has format 2011-02-01
            NSDateFormatter* df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd"];
            NSDate* d = [df dateFromString:[(NSDictionary *)obj objectForKey:@"date"]];
            nkIssue = [nkLib addIssueWithName:name date:d];
        }
    }];
    ready = YES;
}

-(NSInteger)numberOfIssues {
    if([self isReady] && issues) {
        return [issues count];
    } else {
        return 0;
    }
}

-(NSDictionary *)issueAtIndex:(NSInteger)index {
    return [issues objectAtIndex:index];
}

-(NSString *)titleOfIssueAtIndex:(NSInteger)index {
    return [[self issueAtIndex:index] objectForKey:@"title"];
}

-(NSString *)descriptionOfIssueAtIndex:(NSInteger)index {
   return [[self issueAtIndex:index] objectForKey:@"descr"];    
}

-(void)setCoverOfIssueAtIndex:(NSInteger)index  completionBlock:(void(^)(UIImage *img))block {
    NSURL *coverURL = [NSURL URLWithString:[[self issueAtIndex:index] objectForKey:@"coverurl"]];
    NSString *coverFileName = [coverURL lastPathComponent];
    NSString *coverFilePath = [CacheDirectory stringByAppendingPathComponent:coverFileName];
    UIImage *image = [UIImage imageWithContentsOfFile:coverFilePath];
    if(image) {
        block(image);
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
                       ^{
                           NSData *imageData = [NSData dataWithContentsOfURL:coverURL];
                           UIImage *image = [UIImage imageWithData:imageData];
                           if(image) {
                               [imageData writeToFile:coverFilePath atomically:YES];
                               block(image);
                           }
                       });
    }
}

-(UIImage *)coverImageForIssue:(NKIssue *)nkIssue {
    NSString *name = nkIssue.name;
    for(NSDictionary *issueInfo in issues) {
        if([name isEqualToString:[issueInfo objectForKey:@"Name"]]) {
            NSString *coverPath = [issueInfo objectForKey:@"Cover"];
            NSString *coverName = [coverPath lastPathComponent];
            NSString *coverFilePath = [CacheDirectory stringByAppendingPathComponent:coverName];
            UIImage *image = [UIImage imageWithContentsOfFile:coverFilePath];
            return image;
        }
    }
    return nil;
}

-(NSURL *)contentURLForIssueWithName:(NSString *)name {
    __block NSURL *contentURL=nil;
    [issues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *aName = [(NSDictionary *)obj objectForKey:@"title"];
        if([aName isEqualToString:name]) {
            contentURL = [[NSURL URLWithString:[(NSDictionary *)obj objectForKey:@"issueurl"]] retain];
            *stop=YES;
        }
    }];
    NSLog(@"Content URL for issue with name %@ is %@",name,contentURL);
    return [contentURL autorelease];
}

-(NSString *)downloadPathForIssue:(NKIssue *)nkIssue {
    return [nkIssue.contentURL path];
}

-(NKIssue*)removeIssueAtIndex:(NSInteger)index
{
    NKLibrary *nkLib = [NKLibrary sharedLibrary];
    NSString* name = [self titleOfIssueAtIndex:index];
    NKIssue *nkIssue = [nkLib issueWithName:name];
    [nkLib removeIssue:nkIssue];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate* d = [df dateFromString:[(NSDictionary *)[issues objectAtIndex:index] objectForKey:@"date"]];
    NKIssue* ret = [nkLib addIssueWithName:name date:d];
    
    return ret;
}

@end
