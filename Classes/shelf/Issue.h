//
//  Issue.h
//
//  Created by Bart Termorshuizen on 7/10/11.
//  Modified/Adapted for BakerShelf by Andrew Krowczyk @nin9creative on 2/18/2012
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
