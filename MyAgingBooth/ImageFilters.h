//
//  ImageFilters.h
//  MyAgingBooth
//
//  Created by Apple on 17/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "opencv2/objdetect/objdetect.hpp"
#import "opencv2/imgproc/imgproc_c.h"

typedef struct {
    CGFloat r;
    CGFloat g;
    CGFloat b;
} RGBValue;

@interface ImageFilters : NSObject

+ (UIImage *) gaussianBlur: (UIImage *) image kernelSize:(int) ksize sigmaSq:(float) sigmaSq;
+ (UIImage *) boxBlur3x3: (UIImage *) image ;
+ (UIImage *) motionBlur5x5: (UIImage *) image; 
+ (UIImage *) motionBlur7x7 : (UIImage *) image ;
+ (UIImage *) embossImage : (UIImage *) image ;
+ (UIImage *)  sharpenImage : (UIImage *) image ;

+ (UIImage*) grayscaleImage: (UIImage *) image ;
+ (RGBValue) getRGB: (UIImage *) image xIndex: (UInt8) x yIndex: (UInt8) y;
+ (UIImage*) resizeImage:(UIImage*)image newSize:(CGSize)newSize;
+ (UIImage *)UIImageFromIplImage:(IplImage *)image ;
+ (IplImage *)CreateIplImageFromUIImage:(UIImage *)image ;

@end
