//
//  MyActivityIndicator.h
//  MyAgingBooth
//
//  Created by Mahmud on 27/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyActivityIndicator : UIView {
    
	UILabel *centerMessageLabel;
	UILabel *subMessageLabel;
	
	UIActivityIndicatorView *spinner;
}

@property (nonatomic, retain) UILabel *centerMessageLabel;
@property (nonatomic, retain) UILabel *subMessageLabel;

@property (nonatomic, retain) UIActivityIndicatorView *spinner;


+ (MyActivityIndicator *)currentIndicator;

- (void)show;
- (void)hideAfterDelay;
- (void)hide;
- (void)hidden;
- (void)displayActivity:(NSString *)m;
- (void)displayCompleted:(NSString *)m;
- (void)setCenterMessage:(NSString *)message;
- (void)setSubMessage:(NSString *)message;
- (void)showSpinner;
- (void)setProperRotation;
- (void)setProperRotation:(BOOL)animated;

@end


