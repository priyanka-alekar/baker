//
//  Issue.h
//  SitelessMagazine
//
//  Created by Bart Termorshuizen on 7/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Issue : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * descr;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * mag;
@property (nonatomic, retain) NSManagedObject * content;
@property (nonatomic, retain) NSManagedObject * cover;

@end
