//
//  Toolbar.m
//  Baker
//
//  Created by Heberti Almeida on 26/02/12.
//

#import "Toolbar.h"

@implementation Toolbar

/*
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    return self;
}
*/


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void) drawRect:(CGRect)rect
{
    // Drawing code    
    UIImage *image = [UIImage imageNamed:@"toolbar"];
    [image drawAsPatternInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}


@end
