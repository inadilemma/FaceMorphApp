//
//  HomeViewController.m
//  MyAgingBooth
//
//  Created by Mahmud on 29/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "MarkFaceViewController.h"
#import "Globals.h"

@implementation HomeViewController

@synthesize BtnFromCamera, BtnFromLibrary;

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
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent; 
    UIImage *camera=[UIImage imageNamed:CameraButtonImage];
    UIImage *file=[UIImage imageNamed:ChooseFileImage];
    
    [self.BtnFromCamera setImage:camera forState:UIControlStateNormal];
    [self.BtnFromCamera setImage:camera forState:UIControlStateSelected];
    
    [self.BtnFromLibrary setImage:file forState:UIControlStateNormal];
    [self.BtnFromLibrary setImage:file forState:UIControlStateSelected];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//Action handlers for the buttons

// take snap with camera

- (IBAction) TakePhoto
{
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    
    [self presentModalViewController:imagePickerController animated:NO];
    [imagePickerController release];

}

// select image from library
- (IBAction) ChooseFromLibrary
{
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:imagePickerController animated:NO];
    [imagePickerController release];   
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo {
    
    //allocate the Photo object .. from this point this will
    //be our storage of the photo and associated info
    
    Photo *photo=[Photo alloc];
    photo.faceImage=selectedImage;
    [photo scaleToTarget];
    
    MarkFaceViewController *faceViewController=[[MarkFaceViewController alloc] initWithNibName:@"MarkFaceViewController" bundle:nil];
    faceViewController.facePhoto=photo;
    [photo release];
    [self.navigationController pushViewController:faceViewController animated:YES];
    [faceViewController release];

    
    [self dismissModalViewControllerAnimated:YES];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    // The user canceled -- simply dismiss the image picker.
    [self dismissModalViewControllerAnimated:YES];
}


@end
