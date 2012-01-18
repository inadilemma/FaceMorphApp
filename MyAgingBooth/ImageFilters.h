//
//  ImageFilters.h
//  MyAgingBooth
//
//  Created by Apple on 17/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    CGFloat r;
    CGFloat g;
    CGFloat b;
} RGBValue;

@interface ImageFilters : NSObject


+ (UIImage *) grayscaleImage: (UIImage *) image ;
+ (RGBValue) getRGB: (UIImage *) image xIndex: (UInt8) x yIndex: (UInt8) y;
@end
