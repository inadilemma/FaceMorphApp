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

+ (UIImage *)gaussianBlurWithUIImage:(UIImage *)anImage param1:(int) param1 param2:(int) param2  param3:(int) param3 param4:(int) param4 ;
+ (UIImage *)simpleBlurWithUIImage:(UIImage *)anImage;

+ (UIImage*) grayscaleImage: (UIImage *) image ;
+ (RGBValue) getRGB: (UIImage *) image xIndex: (UInt8) x yIndex: (UInt8) y;
+ (UIImage*) resizeImage:(UIImage*)image newSize:(CGSize)newSize;
+ (UIImage *)UIImageFromIplImage:(IplImage *)image ;
+ (IplImage *)CreateIplImageFromUIImage:(UIImage *)image ;

@end
