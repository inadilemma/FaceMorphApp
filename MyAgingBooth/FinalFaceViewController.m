//
//  FinalFaceViewController.m
//  MyAgingBooth
//
//  Created by Mahmud on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FinalFaceViewController.h"
#import "Globals.h"
#import "MyActivityIndicator.h"
#import "SHKTwitter.h"
#import "SHKFacebook.h"
#import "SHKMail.h"

@implementation FinalFaceViewController
@synthesize finalFaceView, myToolbar, facePhoto;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    // Do any additional setup after loading the view from its nib.
    [myToolbar setBarStyle:UIBarStyleBlack];
    [myToolbar setTranslucent:YES];
    [self.finalFaceView setImage:facePhoto.faceImage];
    [self initToolbarItems];
    
    if (!purchaseManager) 
    {
        purchaseManager= [[InAppPurchaseManager alloc] init];
        purchaseManager.delegate=self;
        [purchaseManager loadStore];
    }
    
    [self checkIfUpgraded];


}

-(void) checkIfUpgraded
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL isPurchased= [prefs boolForKey:@"isProUpgradePurchased" ];
    if (!isPurchased) {
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myButton.frame = CGRectMake(60, 200, 200, 200); // position in the parent view and set the size of the button
        [myButton setImage:[UIImage imageNamed:DemoImageName] forState:UIControlStateNormal];
        [myButton addTarget:self action:@selector(purchaseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.finalFaceView addSubview:myButton];
        [finalFaceView setUserInteractionEnabled:YES];
    }
}


-(void) purchaseButtonClicked
{
    [purchaseManager purchaseProUpgrade];
    
}


//implement this method to perform the actions when purchase are completed.
// check if purchase completed
-(void) proceedToNextScreen:(BOOL)flag
{
    if (flag) {
        //purchase was successful, enable full version
        NSArray *viewsToRemove = [self.finalFaceView subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
    }
    else
    {
        //purchase was unsuccessful 
        [[MyActivityIndicator currentIndicator] displayCompleted:@"Unsuccessful"];
        
    }
    
}

//initilize custom buttons
-(void) initToolbarItems
{
    UIImage *emailIcon= [UIImage imageNamed:@"email.jpeg"];
    UIButton *temp=[UIButton buttonWithType:UIButtonTypeCustom] ;
    temp.frame=CGRectMake(0.0,0.0,emailIcon.size.width, emailIcon.size.height);
    [temp setImage:emailIcon forState:UIControlStateNormal];
    [temp addTarget:self action:@selector(sendEmail) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *emailButton = [[UIBarButtonItem alloc] initWithCustomView:temp];    

    UIBarButtonItem *flexButton1 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                  target:nil action:nil];

    
    
    UIImage *fbIcon= [UIImage imageNamed:@"fb.jpeg"];
    temp=[UIButton buttonWithType:UIButtonTypeCustom] ;
    temp.frame=CGRectMake(0.0,0.0,fbIcon.size.width, fbIcon.size.height);
    [temp setImage:fbIcon forState:UIControlStateNormal];
    [temp addTarget:self action:@selector(shareImageOnFacebook) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *fbButton = [[UIBarButtonItem alloc] initWithCustomView:temp];    
    



    UIImage *twitterIcon= [UIImage imageNamed:@"twitter.jpeg"];
    temp=[UIButton buttonWithType:UIButtonTypeCustom] ;
    temp.frame=CGRectMake(0.0,0.0,fbIcon.size.width, fbIcon.size.height);
    [temp setImage:twitterIcon forState:UIControlStateNormal];
    [temp addTarget:self action:@selector(shareImageOnTwitter) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *twitterButton = [[UIBarButtonItem alloc] initWithCustomView:temp];    
    

    
    UIImage *saveIcon= [UIImage imageNamed:@"save.jpeg"];
    temp=[UIButton buttonWithType:UIButtonTypeCustom] ;
    temp.frame=CGRectMake(0.0,0.0,fbIcon.size.width, fbIcon.size.height);
    [temp setImage:saveIcon forState:UIControlStateNormal];
    [temp addTarget:self action:@selector(saveToDisk) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithCustomView:temp];    
    

    
    myToolbar.items= [[NSArray alloc] initWithObjects:emailButton, flexButton1, fbButton, flexButton1, twitterButton, flexButton1, saveButton, nil];
    

    [flexButton1 release];
    [emailButton release];
    [fbButton release];
    [twitterButton release];
    [saveButton release];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [captionField release];
    [finalFaceView release];
    finalFaceView=nil;    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark handle email,share,save

-(void) getMessageForImage :(NSInteger) tag
{
    UIAlertView* dialog = [[UIAlertView alloc] init];
    dialog.tag=tag; // 
    //tag =1

    [dialog setDelegate:self];
    [dialog setTitle:@"Say something..."];
    [dialog setMessage:@" "];
    [dialog addButtonWithTitle:@"Cancel"];
    [dialog addButtonWithTitle:@"OK"];
    
    captionField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
    [captionField setBackgroundColor:[UIColor whiteColor]];
    [dialog addSubview:captionField];
    //CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, 100.0);
    //[dialog setTransform: moveUp];
    [dialog show];
    [dialog release];
    //[captionField release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex== 1) { //clicked OK
        
        [SHKFacebook shareImage:facePhoto.faceImage title: [captionField text]  ];     
    }
    
}

-(void) sendEmail
{
    [SHKMail shareImage:facePhoto.faceImage title:@"test email"];
}

-(void) shareImageOnFacebook
{
    //[SHKFacebook shareImage:facePhoto.faceImage title:@"my aging booth"];
    [self getMessageForImage: FacebookMessageTag];
}

-(void) shareImageOnTwitter
{
    [SHKTwitter shareImage:facePhoto.faceImage title:@"My Aging Booth"];
    //[self getMessageForImage:TwitterMessageTag];
}

-(void) saveToDisk
{
    UIImageWriteToSavedPhotosAlbum(facePhoto.faceImage, nil, nil, nil);
    [[MyActivityIndicator currentIndicator] displayCompleted:@"saved"];
}


@end
