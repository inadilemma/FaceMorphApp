//
//  MarkFaceViewController.h
//  MyAgingBooth
//
//  Created by Mahmud on 31/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
#import "Draggable.h"
#import "MagnifierView.h"
#import <AudioToolbox/AudioToolbox.h>


@interface UIProgressIndicator : UIActivityIndicatorView {
}

+ (struct CGSize)size;
- (int)progressIndicatorStyle;
- (void)setProgressIndicatorStyle:(int)fp8;
- (void)setStyle:(int)fp8;
- (void)setAnimating:(BOOL)fp8;
- (void)startAnimation;
- (void)stopAnimation;
@end

@interface UIProgressHUD : UIView {
    UIProgressIndicator *_progressIndicator;
    UILabel *_progressMessage;
    UIImageView *_doneView;
    UIWindow *_parentWindow;
    struct {
        unsigned int isShowing:1;
        unsigned int isShowingText:1;
        unsigned int fixedFrame:1;
        unsigned int reserved:30;
    } _progressHUDFlags;
}

- (id)_progressIndicator;
- (id)initWithFrame:(struct CGRect)fp8;
- (void)setText:(id)fp8;
- (void)setShowsText:(BOOL)fp8;
- (void)setFontSize:(int)fp8;
- (void)drawRect:(struct CGRect)fp8;
- (void)layoutSubviews;
- (void)showInView:(id)fp8;
- (void)hide;
- (void)done;
- (void)dealloc;
@end


@interface MarkFaceViewController : UIViewController {
    IBOutlet UIImageView *faceImageView;
    Photo *facePhoto;
    Draggable *leftEyeView,*rightEyeView, *mouthView;
    UIProgressHUD *progressHUD;
    SystemSoundID alertSoundID;

	NSTimer *touchTimer;
	MagnifierView *loop;  
    BOOL faceDetected;
}


@property (nonatomic, retain) NSTimer *touchTimer;
@property (nonatomic, assign)     BOOL faceDetected;
@property (nonatomic,retain) IBOutlet UIImageView *faceImageView;
@property (nonatomic,retain) Photo *facePhoto;
@property (nonatomic,retain) Draggable *leftEyeView,*rightEyeView, *mouthView;

- (void)showProgressIndicator:(NSString *)text;
- (void)hideProgressIndicator;
- (void) handleAction:(id)timerObj;


@end
