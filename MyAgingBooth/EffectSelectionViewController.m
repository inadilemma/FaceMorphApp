//
//  EffectSelectionViewController.m
//  MyAgingBooth
//
//  Created by Mahmud on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.


#import "EffectSelectionViewController.h"
#import "FinalFaceViewController.h"
#import "Globals.h"
#import "ImageFilters.h"


@implementation EffectSelectionViewController
@synthesize effect1,effect2,effect3,effect4,facePhoto;

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
    
    //set title 
    self.navigationItem.title=@"Select effect";
    
    //set the images
   
    [self.effect1 setImage:facePhoto.faceImage forState:UIControlStateNormal];
    [self.effect1 setImage:facePhoto.faceImage forState:UIControlStateSelected];
    [self.effect1 addTarget:self action:@selector(effectSelected:) forControlEvents:UIControlEventTouchUpInside];

    [self.effect2 setImage:facePhoto.faceImage forState:UIControlStateNormal];
    [self.effect2 setImage:facePhoto.faceImage forState:UIControlStateSelected];
    [self.effect2 addTarget:self action:@selector(effectSelected:) forControlEvents:UIControlEventTouchUpInside];

    facePhoto.faceImage=[ImageFilters gaussianBlurWithUIImage:facePhoto.faceImage];
    
    [self.effect3 setImage:facePhoto.faceImage forState:UIControlStateNormal];
    [self.effect3 setImage:facePhoto.faceImage forState:UIControlStateSelected];
    [self.effect3 addTarget:self action:@selector(effectSelected:) forControlEvents:UIControlEventTouchUpInside];

    [self.effect4 setImage:facePhoto.faceImage forState:UIControlStateNormal];
    [self.effect4 setImage:facePhoto.faceImage forState:UIControlStateSelected];
    [self.effect4 addTarget:self action:@selector(effectSelected:) forControlEvents:UIControlEventTouchUpInside];

}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationItem.title=@"Select effect.";
    
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
    [self.effect1 release];
    [self.effect2 release];
    [self.effect3 release];
    [self.effect4 release];
    
    self.effect1=nil;
    self.effect2=nil;
    self.effect3=nil;
    self.effect4=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// our event handlers

-(void) effectSelected:(id)sender
{
    UIButton *resultButton = (UIButton *)sender;
    
    NSInteger tag=resultButton.tag;
    facePhoto.selectedEffect=tag;
    
    if (tag==EFFECT1) {
        //effect 1 selected .... start in-app purchase
        // set the product details
    }
    else if(tag==EFFECT2)
    {
        //effect 2 selected .... start in-app purchase
                // set the product details
    }
    else if(tag==EFFECT3)
    {
        //effect 3 selected .... start in-app purchase
        // set the product details        
    }
    else if(tag==EFFECT4)
    {
        //effect 4 selected .... start in-app purchase
        // set the product details
    }
    

    
    
    //this is just a temporary code to proceedToNextScreen ... when in-app purchase is complete the method proceedToNextScreen will be called automatically
    
    //temp code 
     FinalFaceViewController *finalViewController;
     finalViewController=[[FinalFaceViewController alloc] initWithNibName:@"FinalFaceViewController" bundle:nil];
     finalViewController.facePhoto=facePhoto;
     [self.navigationController pushViewController:finalViewController animated:YES];
     [finalViewController release];
    
}



@end
