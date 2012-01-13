//
//  FinalFaceViewController.h
//  MyAgingBooth
//
//  Created by Mahmud on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
#import "SHK.h"
#import "InAppPurchaseManager.h"

@interface FinalFaceViewController : UIViewController <PurchaseDelegate, UIAlertViewDelegate>{
    IBOutlet UIImageView *finalFaceView;
    IBOutlet UIToolbar *myToolbar;
    Photo *facePhoto;
    InAppPurchaseManager *purchaseManager; //handles everything related to purchase
    UITextField *captionField;
}



-(void) sendEmail;
-(void) shareImageOnFacebook;
-(void) shareImageOnTwitter;
-(void) saveToDisk;
-(void) checkIfUpgraded;


@property(nonatomic,retain) UIImageView *finalFaceView;
@property(nonatomic,retain) UIToolbar *myToolbar;
@property(nonatomic,retain) Photo *facePhoto;
@end
