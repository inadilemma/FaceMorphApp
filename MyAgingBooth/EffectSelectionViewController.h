//
//  EffectSelectionViewController.h
//  MyAgingBooth
//
//  Created by Mahmud on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface EffectSelectionViewController : UIViewController {
    IBOutlet UIButton *effect1;
    IBOutlet UIButton *effect2;
    IBOutlet UIButton *effect3;
    IBOutlet UIButton *effect4;
    Photo *facePhoto;
}

@property(nonatomic,retain) UIButton *effect1;
@property(nonatomic,retain) UIButton *effect2;
@property(nonatomic,retain) UIButton *effect3;
@property(nonatomic,retain) UIButton *effect4;
@property(nonatomic,retain) Photo *facePhoto;


-(void) effectSelected: (id)sender;

@end
