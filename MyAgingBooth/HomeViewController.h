//
//  HomeViewController.h
//  MyAgingBooth
//
//  Created by Mahmud on 29/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomeViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    UIButton *BtnFromCamera;
    UIButton *BtnFromLibrary;
    
}

@property (nonatomic, retain) IBOutlet UIButton *BtnFromCamera;
@property (nonatomic, retain) IBOutlet UIButton *BtnFromLibrary;

- (IBAction) TakePhoto;
- (IBAction) ChooseFromLibrary;


@end
