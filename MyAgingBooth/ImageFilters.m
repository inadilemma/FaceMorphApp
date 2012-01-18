//
//  ImageFilters.m
//  MyAgingBooth
//
//  Created by Apple on 17/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageFilters.h"

@implementation ImageFilters

+ (UIImage *) grayscaleImage: (UIImage *) image 
{ 
	CGSize size = image.size; 
	//CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
	CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height); 
	NSLog([NSString stringWithFormat:@"width: %g",image.size.width]);
	NSLog([NSString stringWithFormat:@"height: %g",image.size.height]);
	// Create a mono/gray color space 
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray(); 
	CGContextRef context = CGBitmapContextCreate(nil, size.width, 
                                                 size.height, 8, 0, colorSpace, kCGImageAlphaNone); 
	
	//CGContextTranslateCTM(context, image.size.width, 0);
	CGColorSpaceRelease(colorSpace); 
	// Draw the image into the grayscale context 
	CGContextDrawImage(context, rect, [image CGImage]); 
	CGImageRef grayscale = CGBitmapContextCreateImage(context); 
	CGContextRelease(context); 
	// Recover the image 
	UIImage *img = [UIImage imageWithCGImage:grayscale]; 
	CFRelease(grayscale); 

	return img; 
    
}

+ (RGBValue) getRGB: (UIImage *) image xIndex: (UInt8)x yIndex: (UInt8)y
{
    CGImageRef imageref = image.CGImage;
    NSUInteger width = CGImageGetWidth(imageref);
    NSUInteger height = CGImageGetHeight(imageref);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    UInt8 * rawData = malloc(height * width * 4);
    
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * width;
    
    NSUInteger bitsPerComponent = 8;
    CGContextRef context1 = CGBitmapContextCreate(
                                                  rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace,
                                                  kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big
                                                  );
    
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context1, CGRectMake(0, 0, width, height), imageref);

    RGBValue rgb;
    rgb.r= rawData[y * bytesPerRow + x * bytesPerPixel + 1];      
    rgb.g= rawData[y * bytesPerRow + x * bytesPerPixel + 1] ; 
    rgb.b=rawData[y * bytesPerRow + x * bytesPerPixel + 2]  ;
    
    CGContextRelease(context1);
    return rgb;
}


@end

//+ (UIImage *) gaussianBlur: (UIImage *) image
//{
    
//}
