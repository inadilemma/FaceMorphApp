//
//  ImageFilters.m
//  MyAgingBooth
//
//  Created by Apple on 17/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageFilters.h"
#import "Globals.h"
#import "UIImage+DSP.h"

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

+ (UIImage*)resizeImage:(UIImage*)image 
              newSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/*
 param1
 The first parameter of smoothing operation.
 param2
 The second parameter of smoothing operation. In case of simple scaled/non-scaled and Gaussian blur if param2 is zero, it is set to param1.
 param3
 In case of Gaussian kernel this parameter may specify Gaussian sigma (standard deviation). If it is zero, it is calculated from the kernel size:
 sigma = (n/2 - 1)*0.3 + 0.8, where n=param1 for horizontal kernel,
 n=param2 for vertical kernel.
 
 With the standard sigma for small kernels (3×3 to 7×7) the performance is better. If param3 is not zero, while param1 and param2 are zeros, the kernel size is calculated from the sigma (to provide accurate enough operation).
 param4
 In case of non-square Gaussian kernel the parameter may be used to specify a different (from param3) sigma in the vertical direction.
 The function cvSmooth smooths image using one of several methods. Every of the methods has some features and restrictions listed below
 
 Blur with no scaling works with single-channel images only and supports accumulation of 8-bit to 16-bit format (similar to cvSobel and cvLaplace) and 32-bit floating point to 32-bit floating-point format.
 
 Simple blur and Gaussian blur support 1- or 3-channel, 8-bit and 32-bit floating point images. These two methods can process images in-place.
 
 Median and bilateral filters work with 1- or 3-channel 8-bit images and can not process images in-place.
 */

//Gaussian blur
/*
+ (UIImage *)gaussianBlurWithUIImage:(UIImage *)anImage param1:(int) param1 param2:(int) param2  param3:(int) param3 param4:(int) param4 {
    
    // Create an IplImage from UIImage
    IplImage *img_color = [self CreateIplImageFromUIImage:anImage];
    
    //obtain a 4channel RGB reference from the above
    IplImage *img = cvCreateImage(cvGetSize(img_color), IPL_DEPTH_8U, 4);
    
    //release the source. we don't care any more about it
    cvReleaseImage(&img_color);
    
    //make the Blur
    cvSmooth(img, img, CV_GAUSSIAN, param1, param2, param3, param4);
    
    //return the resulting image
    UIImage *retUIImage = [self UIImageFromIplImage:img];
    
    //release any allocated memory
    cvReleaseImage(&img);
    
    return retUIImage;
}

////Gaussian blur
+ (UIImage *)simpleBlurWithUIImage:(UIImage *)anImage {
    
    // Create an IplImage from UIImage
    IplImage *img_color = [self CreateIplImageFromUIImage:anImage];
    
    //obtain a 4channel RGB reference from the above
    IplImage *img = cvCreateImage(cvGetSize(img_color), IPL_DEPTH_8U, 4);
    
    //release the source. we don't care any more about it
    cvReleaseImage(&img_color);
    
    //make the Blur
    cvSmooth(img, img, CV_BLUR, 17, 17, 0, 0);
    
    //return the resulting image
    UIImage *retUIImage = [self UIImageFromIplImage:img];
    
    //release any allocated memory
    cvReleaseImage(&img);
    
    return retUIImage;
}
*/

// NOTE you SHOULD cvReleaseImage() for the return value when end of the code.
+ (IplImage *)CreateIplImageFromUIImage:(UIImage *)image {
	CGImageRef imageRef = image.CGImage;
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	IplImage *iplimage = cvCreateImage(cvSize(image.size.width, image.size.height), IPL_DEPTH_8U, 4);
	CGContextRef contextRef = CGBitmapContextCreate(iplimage->imageData, iplimage->width, iplimage->height,
													iplimage->depth, iplimage->widthStep,
													colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
	CGContextDrawImage(contextRef, CGRectMake(0, 0, image.size.width, image.size.height), imageRef);
	CGContextRelease(contextRef);
	CGColorSpaceRelease(colorSpace);
    
	IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 3);
	cvCvtColor(iplimage, ret, CV_RGBA2BGR);
	cvReleaseImage(&iplimage);
    
	return ret;
}

// NOTE You should convert color mode as RGB before passing to this function
+ (UIImage *)UIImageFromIplImage:(IplImage *)image {
	NSLog(@"IplImage (%d, %d) %d bits by %d channels, %d bytes/row %s", image->width, image->height, image->depth, image->nChannels, image->widthStep, image->channelSeq);
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	NSData *data = [NSData dataWithBytes:image->imageData length:image->imageSize];
	CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
	CGImageRef imageRef = CGImageCreate(image->width, image->height,
										image->depth, image->depth * image->nChannels, image->widthStep,
										colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault,
										provider, NULL, false, kCGRenderingIntentDefault);
	UIImage *ret = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CGDataProviderRelease(provider);
	CGColorSpaceRelease(colorSpace);
	return ret;
}


+ (UIImage *) toLABColorSpace: (UIImage *) image
{
    IplImage *src= [self CreateIplImageFromUIImage:image];
    cvCvtColor(src, src, CV_RGB2Lab);
    
    return [self UIImageFromIplImage:src];
}


//mask type AND,OR,XOR
+ (UIImage *) applyMask: (UIImage *) imageSrc scalerMask:(int) scalerMask maskType: (int) maskType
{
    IplImage *src= [self CreateIplImageFromUIImage:imageSrc];

    if (maskType == AND) {
        cvAndS(src, cvRealScalar(*(float*)&scalerMask ) , src, 0);
    }
    else if(maskType == OR)
    {
        cvOrS(src, cvRealScalar(*(float*)&scalerMask ) , src, 0);

    }
    else if (maskType == XOR)
    {
        cvXorS(src, cvRealScalar(*(float*)&scalerMask ) , src, 0);

    }
    
    UIImage* ret=[self UIImageFromIplImage:src];
    
    cvReleaseImage(&src);
    return ret;
}

//use only odd valued kernel size

+ (UIImage *) gaussianBlur: (UIImage *) image kernelSize:(int) ksize sigmaSq:(float) sigmaSq
{
    return [image imageByApplyingGaussianBlurOfSize:ksize withSigmaSquared:sigmaSq];
}


+ (UIImage *) boxBlur3x3: (UIImage *) image 
{
    return [image imageByApplyingBoxBlur3x3];
}

+ (UIImage *) motionBlur5x5: (UIImage *) image 
{
    return [image imageByApplyingDiagonalMotionBlur5x5] ;
}


+ (UIImage *) motionBlur7x7 : (UIImage *) image 
{
    return [image imageByApplyingDiagonalMotionBlur7x7] ;
}

+ (UIImage *) embossImage : (UIImage *) image 
{
    return [image imageByApplyingEmboss3x3 ] ;
}

+ (UIImage *)  sharpenImage : (UIImage *) image 
{
    return [image imageByApplyingSharpen3x3 ] ;
}


@end

