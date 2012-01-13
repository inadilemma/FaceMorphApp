//
//  Constants.h
//  MyAgingBooth
//
//  Created by Mahmud on 29/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//welcome screen image sizes

#define welcomeScreenTopSegment   76
#define welcomeScreenBottomSegment 78
#define welcomeScreenMidSection 306


//third screen face detection and marker placement
//use image with transparent background

#define eyeMarkerImage      @"eye.png" 
#define mouthMarkerImage    @"mouth.png"
#define chinMarkerImage     @"chin.png"

// default marker height and width

#define defaultFaceMarkerWidth  50
#define defaultFaceMarkerHeight 50

// default marker location, incase of face detection failure

#define defaultLeftEyeX 100
#define defaultLeftEyeY 180

#define defaultRightEyeX 160
#define defaultRightEyeY 180

#define defaultMouthX   130
#define defaultMouthY   230
  
#define defaultChinX    130
#define defaultChinY    260



#define magnifyerMarkerCenterImage @"markerCenter.png" //use a transarent background 40x40 png image

//second screen
#define CameraButtonImage  @"camera.jpg"
#define ChooseFileImage  @"choose.jpg"




#define defaultImageTitle @""




//final sharing screen

#define DemoImageName @"demo.png"
#define TwitterMessageTag  1
#define FacebookMessageTag 2

#define defaultFacebookCaption  @"Aging Booth Test"
#define defaultTwitterCaption @"Aging Booth Test"

typedef enum
{
    EFFECT1,
    EFFECT2,
    EFFECT3,
    EFFECT4
}EffectType;