//
//  Photo.h
//  MyAgingBooth
//
//  Created by Mahmud on 31/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Globals.h"

@interface Photo : NSManagedObject {
    
    // REMEMBER: to use scaling factor to convert these screen cordinates to image coordinates
    //
    
    CGPoint leftEyeLocation;
    CGPoint rightEyeLocation;
    CGPoint mouthLocation;
    EffectType selectedEffect;
}

@property (nonatomic, assign) EffectType selectedEffect;
@property (nonatomic,assign) CGPoint leftEyeLocation;
@property (nonatomic,assign) CGPoint rightEyeLocation;
@property (nonatomic,assign) CGPoint mouthLocation;

@property (nonatomic, retain) UIImage *faceImage;

@property (nonatomic, retain) UIImage *imageAfterEffect1;
@property (nonatomic, retain) UIImage *imageAfterEffect2;
@property (nonatomic, retain) UIImage *imageAfterEffect3;
@property (nonatomic, retain) UIImage *imageAfterEffect4;

-(void) transformImage:(EffectType) effect;
-(void) applyFilter;
-(void) scaleToTarget;

@end
