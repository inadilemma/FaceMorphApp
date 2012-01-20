//
//  FaceDB.h
//  MyAgingBooth
//
//  Created by Apple on 20/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FaceDB : NSManagedObject

@property (nonatomic, retain) NSNumber * faceID;
@property (nonatomic, retain) NSNumber * leftEye;
@property (nonatomic, retain) NSNumber * rightEye;
@property (nonatomic, retain) NSNumber * mouth;
@property (nonatomic, retain) NSString * thumbnail;

@end
