//
//  MarkFaceViewController.m
//  MyAgingBooth
//
//  Created by Mahmud on 31/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MarkFaceViewController.h"
#import "Globals.h"
#import "EffectSelectionViewController.h"
#import "opencv2/objdetect/objdetect.hpp"
#import "opencv2/imgproc/imgproc_c.h"

@implementation MarkFaceViewController

@synthesize faceImageView, facePhoto, touchTimer, leftEyeView, rightEyeView,mouthView,faceDetected;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //flag used to maintain face detection only the first time the view appears
        faceDetected=NO;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    
    //add a title 
    
    self.navigationItem.title=@"Adjust markers";
    //add a right bar button item proceed to next.
    UIBarButtonItem *proceedButton = [[UIBarButtonItem alloc]initWithTitle:@"Proceed" style:UIBarButtonItemStylePlain target:self action:@selector(proceedToNext)];
    self.navigationItem.rightBarButtonItem=proceedButton;
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [proceedButton release];
    
    //set the selected photo as source for the imageview
    faceImageView.image=facePhoto.faceImage;
    faceImageView.userInteractionEnabled=YES;

}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationItem.title=@"Adjust markers";
    
}

-(void) viewDidAppear:(BOOL)animated
{
    if (!faceDetected) 
    {
        
        UIImage *image = nil;    
        [self showProgressIndicator:@"Detecting"];
        [self performSelectorInBackground:@selector(opencvFaceDetect:) withObject:image];    
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    self.navigationItem.title=@"Back";    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
   // [faceImageView.image release];
    [faceImageView release];
    
    [leftEyeView release];
    self.leftEyeView=nil;
    
    [self.rightEyeView release];
    self.rightEyeView=nil;
    
    [self.mouthView release];
    self.mouthView=nil;
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//event handlers
//called once the marking has done and proceeding to next stage
-(void) proceedToNext
{
    

    facePhoto.leftEyeLocation=leftEyeView.center;
    facePhoto.rightEyeLocation=rightEyeView.center;
    facePhoto.mouthLocation=mouthView.center;
    
   // now generate the the transformed image by applying filters
    [facePhoto applyFilter];
    //show some indicator for the time required for applying the filter
    //    ...........
    
    
    //move to the effect selection screen once the 
    EffectSelectionViewController *effectSelectionViewController=[[EffectSelectionViewController alloc] initWithNibName:@"EffectSelectionViewController" bundle:nil];
    
    //assign the Photo with applied filters to the selection view photo holder
    
    effectSelectionViewController.facePhoto=facePhoto;
    [self.navigationController pushViewController:effectSelectionViewController animated:YES];
    [effectSelectionViewController release];
    

}

#pragma mark -
#pragma mark OpenCV Support Methods

// NOTE you SHOULD cvReleaseImage() for the return value when end of the code.
- (IplImage *)CreateIplImageFromUIImage:(UIImage *)image {
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
- (UIImage *)UIImageFromIplImage:(IplImage *)image {
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

#pragma mark -
#pragma mark Utilities for internal use

- (void)showProgressIndicator:(NSString *)text {
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	self.view.userInteractionEnabled = FALSE;
	if(!progressHUD) {
		CGFloat w = 160.0f, h = 120.0f;
		progressHUD = [[UIProgressHUD alloc] initWithFrame:CGRectMake((self.view.frame.size.width-w)/2, (self.view.frame.size.height-h)/2, w, h)];
		[progressHUD setText:text];
		[progressHUD showInView:self.view];
	}
}

- (void)hideProgressIndicator {
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	self.view.userInteractionEnabled = TRUE;
	if(progressHUD) {
		[progressHUD hide];
		[progressHUD release];
		progressHUD = nil;
        
		AudioServicesPlaySystemSound(alertSoundID);
	}
}


//handle touches on imageview for magnifying effect
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	self.touchTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                       target:self
                                                     selector:@selector(addLoop)
                                                     userInfo:nil
                                                      repeats:NO];
    
	// just create one loop and re-use it.
	if(loop == nil){
		loop = [[MagnifierView alloc] init];
		loop.viewToMagnify =  self.faceImageView;
	}
    
    
	
	UITouch *touch = [touches anyObject];
    if (touch.view == leftEyeView) {
        loop.touchPoint=leftEyeView.center;
    }
    else if (touch.view == rightEyeView) {
        loop.touchPoint=rightEyeView.center;
    }
    else if (touch.view == mouthView) {
        loop.touchPoint=mouthView.center;
    }
    
//	loop.touchPoint = //[touch locationInView:self.view];
	[loop setNeedsDisplay];

}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[self handleAction:touches];
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.touchTimer invalidate];
	self.touchTimer = nil;
    
	[loop removeFromSuperview];
}

- (void)addLoop {
	// add the loop to the superview.  if we add it to the view it magnifies, it'll magnify itself!
	[self.view.superview addSubview:loop];
	// here, we could do some nice animation instead of just adding the subview...
}

- (void)handleAction:(id)timerObj {
	NSSet *touches = timerObj;

	UITouch *touch = [touches anyObject];
    if (touch.view == leftEyeView) {
        loop.touchPoint=leftEyeView.center;
    }
    else if (touch.view == rightEyeView) {
        loop.touchPoint=rightEyeView.center;
    }
    else if (touch.view == mouthView) {
        loop.touchPoint=mouthView.center;
    }
	//UITouch *touch = [touches anyObject];
//	loop.touchPoint = [touch locationInView:self.view];
	[loop setNeedsDisplay];
}




#pragma mark face detection code

- (void) opencvFaceDetect:(UIImage *)overlayImage {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
	if(faceImageView.image) {
		cvSetErrMode(CV_ErrModeParent);
        
		IplImage *image = [self CreateIplImageFromUIImage:faceImageView.image];
		
        
		// Scaling down
		IplImage *small_image = cvCreateImage(cvSize(image->width/2,image->height/2), IPL_DEPTH_8U, 3);
		cvPyrDown(image, small_image, CV_GAUSSIAN_5x5);
		int scale = 2;
		
		// Load XML
		NSString *path = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_default" ofType:@"xml"];
		CvHaarClassifierCascade* cascade = (CvHaarClassifierCascade*)cvLoad([path cStringUsingEncoding:NSASCIIStringEncoding], NULL, NULL, NULL);
		CvMemStorage* storage = cvCreateMemStorage(0);
		
		// Detect faces and draw rectangle on them
		CvSeq* faces = cvHaarDetectObjects(small_image, cascade, storage, 1.2f, 2, CV_HAAR_DO_CANNY_PRUNING, cvSize(0,0), cvSize(20, 20));
		cvReleaseImage(&small_image);
		
		// Create canvas to show the results
		CGImageRef imageRef = faceImageView.image.CGImage;
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef contextRef = CGBitmapContextCreate(NULL, faceImageView.image.size.width, faceImageView.image.size.height,
														8, faceImageView.image.size.width * 4,
														colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
		CGContextDrawImage(contextRef, CGRectMake(0, 0, faceImageView.image.size.width, faceImageView.image.size.height), imageRef);
		
		CGContextSetLineWidth(contextRef, 4);
		CGContextSetRGBStrokeColor(contextRef, 0.0, 0.0, 1.0, 0.5);
		
		// Draw results on the iamge
        NSLog(@"no of faces=%d",faces->total);
        
        if(faces->total == 0)
        {
            facePhoto.leftEyeLocation=CGPointMake(defaultLeftEyeX,defaultLeftEyeY);
            facePhoto.rightEyeLocation=CGPointMake(defaultRightEyeX,defaultRightEyeY);
            facePhoto.mouthLocation=CGPointMake(defaultMouthX,defaultMouthY);


            //draggable markers
            //left eye
            
            UIImage *eye=[[UIImage imageNamed:eyeMarkerImage] retain];
            CGRect cellRectangle = CGRectMake(facePhoto.leftEyeLocation.x,facePhoto.leftEyeLocation.y,eye.size.width ,eye.size.height );
            leftEyeView = [[Draggable alloc] initWithFrame:cellRectangle];    
            [leftEyeView setImage:eye];
            [leftEyeView setUserInteractionEnabled:YES];
            [self.view addSubview:leftEyeView];
            [eye release];
            
            //right eye marker
            eye=[[UIImage imageNamed:eyeMarkerImage] retain];
            cellRectangle = CGRectMake(facePhoto.rightEyeLocation.x,facePhoto.rightEyeLocation.y,eye.size.width ,eye.size.height );
            rightEyeView = [[Draggable alloc] initWithFrame:cellRectangle];    
            [rightEyeView setImage:eye];
            [rightEyeView setUserInteractionEnabled:YES];
            [self.view  addSubview:rightEyeView];    
            [eye release];
            
            //mouth marker
            eye=[[UIImage imageNamed:mouthMarkerImage] retain];
            cellRectangle = CGRectMake(facePhoto.mouthLocation.x,facePhoto.mouthLocation.y,eye.size.width ,eye.size.height );
            mouthView= [[Draggable alloc] initWithFrame:cellRectangle];    
            [mouthView setImage:eye];
            [mouthView setUserInteractionEnabled:YES];
            [self.view  addSubview:mouthView];    
            [eye release];
            
            
        }
        else
        {
			//NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
			
			// Calc the rect of faces
			CvRect cvrect = *(CvRect*)cvGetSeqElem(faces, 0);
			CGRect face_rect = CGContextConvertRectToDeviceSpace(contextRef, CGRectMake(cvrect.x * scale, cvrect.y * scale, cvrect.width * scale, cvrect.height * scale));
			
               NSLog(@"CVRECT: X=%d  Y=%d Width=%d Height=%d Scale=%d",cvrect.x, cvrect.y,cvrect.width,cvrect.height,scale);
            NSLog(@"FACERECT: X=%f  Y=%f Width=%f Height=%f Scale=%d",face_rect.origin.x, face_rect.origin.y,face_rect.size.width,face_rect.size.height,scale);
            
            //detect the eye,mouth and chin locations
            
            //scaling factor to convert image coordinate to screen cordinate
      //      float scaleImageToScreenHorizontal=self.view.frame.size.width/facePhoto.faceImage.size.width;  
            
        //    float scaleImageToScreenVertical=self.view.frame.size.height/facePhoto.faceImage.size.height;
            
            NSLog(@"imageWidth = %f,  imageHeight = %f",faceImageView.image.size.width,faceImageView.image.size.height);
            

          /*  
            facePhoto.leftEyeLocation = CGPointMake((face_rect.origin.x+face_rect.size.width/3)*scaleImageToScreenHorizontal - defaultFaceMarkerWidth/2,(face_rect.origin.y+face_rect.size.height*2/5)*scaleImageToScreenVertical);
            facePhoto.rightEyeLocation = CGPointMake((face_rect.origin.x+face_rect.size.width*2/3)*scaleImageToScreenHorizontal - defaultFaceMarkerWidth/2, (face_rect.origin.y+face_rect.size.height*2/5)*scaleImageToScreenVertical);
            facePhoto.mouthLocation = CGPointMake((face_rect.origin.x+face_rect.size.width/2)*scaleImageToScreenHorizontal - defaultFaceMarkerWidth/2, (face_rect.origin.y+face_rect.size.height*4/5)*scaleImageToScreenVertical);*/
            
            facePhoto.leftEyeLocation = CGPointMake((cvrect.x+cvrect.width/3)-defaultFaceMarkerWidth/2,(cvrect.y+cvrect.height*2/5)-defaultFaceMarkerWidth/2);
            facePhoto.rightEyeLocation = CGPointMake((cvrect.x+cvrect.width*2/3)-defaultFaceMarkerWidth/2, (cvrect.y+cvrect.height*2/5)-defaultFaceMarkerWidth/2);
            facePhoto.mouthLocation = CGPointMake((cvrect.x+cvrect.width/2)-defaultFaceMarkerWidth/2, (cvrect.y+cvrect.height*4/5));
            
            
			if(overlayImage) {
				CGContextDrawImage(contextRef, face_rect, overlayImage.CGImage);
			} else {
				CGContextStrokeRect(contextRef, face_rect);
			} 
            
            CGImageRef tempref= CGBitmapContextCreateImage(contextRef);
            
            UIImage *markedFace = [UIImage imageWithCGImage:tempref];

            [faceImageView setImage:markedFace];
            CGImageRelease(tempref);
                        //without context ref
           // [markedFace release];
  
#pragma mark draw markers            
            //draggable markers


            //left eye
            
            UIImage *eye=[[UIImage imageNamed:eyeMarkerImage] retain];
            CGRect cellRectangle = CGRectMake(facePhoto.leftEyeLocation.x,facePhoto.leftEyeLocation.y,eye.size.width ,eye.size.height );
            leftEyeView = [[Draggable alloc] initWithFrame:cellRectangle];    
            [leftEyeView setImage:eye];
            [leftEyeView setUserInteractionEnabled:YES];
            [self.view  addSubview:leftEyeView];
            [eye release];
            
            //right eye marker
            eye=[[UIImage imageNamed:eyeMarkerImage] retain];
            cellRectangle = CGRectMake(facePhoto.rightEyeLocation.x,facePhoto.rightEyeLocation.y,eye.size.width ,eye.size.height );
            rightEyeView = [[Draggable alloc] initWithFrame:cellRectangle];    
            [rightEyeView setImage:eye];
            [rightEyeView setUserInteractionEnabled:YES];
            [self.view  addSubview:rightEyeView];    
            [eye release];
            
            //mouth marker

            eye=[[UIImage imageNamed:mouthMarkerImage] retain];
            cellRectangle = CGRectMake(facePhoto.mouthLocation.x,facePhoto.mouthLocation.y,eye.size.width ,eye.size.height );
            mouthView= [[Draggable alloc] initWithFrame:cellRectangle];    
            [mouthView setImage:eye];
            [mouthView setUserInteractionEnabled:YES];
            [self.view  addSubview:mouthView];    
            [eye release];
            
#pragma mark -      
		}
        
		//record if face detection was called 
        
        faceDetected=YES;

		CGContextRelease(contextRef);
		CGColorSpaceRelease(colorSpace);
		
		cvReleaseMemStorage(&storage);
		cvReleaseHaarClassifierCascade(&cascade);
        
		[self hideProgressIndicator];
        
        //enable the naviagation to next screen
        
        [self.navigationItem.rightBarButtonItem setEnabled:YES];

        
        
	}
    
	[pool release];
    
    
}



@end
