//
//  Photo.m
//  MyAgingBooth
//
//  Created by Mahmud on 31/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Photo.h"
#import "ImageFilters.h"
#import "DataManager.h"

@implementation Photo

@synthesize faceImage,imageAfterEffect1, imageAfterEffect2, imageAfterEffect3, imageAfterEffect4,leftEyeLocation,rightEyeLocation,mouthLocation, selectedEffect;

//helper method for drawing face markers
+ (UIImage*)imageWithImage:(UIImage*)image 
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void) scaleToTarget{
    if (faceImage) {
        
        UIImage *temp = [Photo imageWithImage:faceImage scaledToSize:CGSizeMake(640.0,640.0*faceImage.size.height/faceImage.size.width)];
        // Get the Core Graphics Reference to the Image
        CGImageRef cgImage = [temp CGImage];
        
        // Make a new image from the CG Reference
        faceImage = [[UIImage alloc] initWithCGImage:cgImage];
    }
}


//apply the filter

-(void) applyFilter
{
    //faceImage = [ImageFilters gaussianBlurWithUIImage:faceImage param1:10 param2:10 param3:0 param4:0];
    NSArray *fourMatches=[[DataManager findFourBestMatch:faceImage] retain];
    //[ImageFilters getRGB:faceImage xIndex:20 yIndex:30];
    //faceImage = [ImageFilters grayscaleImage:faceImage];
    
    imageAfterEffect1 = [UIImage imageNamed:(NSString*) [fourMatches objectAtIndex:0]];
    imageAfterEffect2 = [UIImage imageNamed:(NSString*) [fourMatches objectAtIndex:1]];
    imageAfterEffect3 = [UIImage imageNamed:(NSString*) [fourMatches objectAtIndex:2]];
    imageAfterEffect4 = [UIImage imageNamed:(NSString*) [fourMatches objectAtIndex:3]];    
    
    //imageAfterEffect2= [ImageFilters grayscaleImage:imageAfterEffect2];
    //imageAfterEffect1= [ImageFilters gaussianBlurWithUIImage:imageAfterEffect1 param1:17 param2:17 param3:0 param4:0];
    
    [fourMatches release];
  /*  [self transformImage:EFFECT1];
    [self transformImage:EFFECT2];
    [self transformImage:EFFECT3];
    [self transformImage:EFFECT4];*/
}

//do the actual transformation on the face image when called with the appropriate filer number
-(void) transformImage:(EffectType) effect
{
    if (effect==EFFECT1) {
        //apply first type of effect to generate imageAfterEffect1 ......
        
        //just a template assigning the original image as the transformed one
        imageAfterEffect1=faceImage;
    }
    else if (effect==EFFECT2) {
        //apply first type of effect to generate imageAfterEffect1 ......
        
        //just a template assigning the original image as the transformed one
        imageAfterEffect2=faceImage;
    }
    else if (effect==EFFECT3) {
        //apply first type of effect to generate imageAfterEffect1 ......
        
        //just a template assigning the original image as the transformed one
        imageAfterEffect3=faceImage;
    }
    else if (effect==EFFECT4) {
        //apply first type of effect to generate imageAfterEffect1 ......
        
        //just a template assigning the original image as the transformed one
        imageAfterEffect4=faceImage;
    }

}

@end
