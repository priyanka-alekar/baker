//
//  ModalViewControllerDelegate.h
//  Baker
//
//  Created by Bart on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ModalViewControllerDelegate <NSObject>
- (void) modalViewControllerIsDone;
- (void) modalViewControllerCanceled;
@end

