//
//  MagnifierView.m
//  SimplerMaskTest
//

#import "MagnifierView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MagnifierView
@synthesize viewToMagnify, touchPoint;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:CGRectMake(0, 0, 80, 80)]) {
		// make the circle-shape outline with a nice border.
		self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
		self.layer.borderWidth = 3;
		self.layer.cornerRadius = 40;
		self.layer.masksToBounds = YES;
        UIImageView *temp=[[UIImageView alloc] initWithFrame:CGRectMake(20,20,40,40)];
        [temp setImage:[UIImage imageNamed:@"markerCenter"]];
        [self addSubview:temp];
        [temp release];
	}
	return self;
}

- (void)setTouchPoint:(CGPoint)pt {
	touchPoint = pt;
	// whenever touchPoint is set, 
	// update the position of the magnifier (to just above what's being magnified)
	self.center = CGPointMake(pt.x, pt.y-60);
}

- (void)drawRect:(CGRect)rect {
	// here we're just doing some transforms on the view we're magnifying,
	// and rendering that view directly into this view,
	// rather than the previous method of copying an image.
    
    
                                UIImage *temp=[UIImage imageNamed:@"Default.png"];
                                [temp drawAtPoint:CGPointZero];
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	CGContextTranslateCTM(context,1*(self.frame.size.width*0.5),1*(self.frame.size.height*0.5));
	CGContextScaleCTM(context, 1.5, 1.5);
    
	CGContextTranslateCTM(context,-1*(touchPoint.x),-1*(touchPoint.y));
    
	[self.viewToMagnify.layer renderInContext:context];
}

- (void)dealloc {
	[viewToMagnify release];
	[super dealloc];
}


@end
