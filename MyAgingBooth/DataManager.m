//
//  DataManager.m
//  MyAgingBooth
//
//  Created by Apple on 20/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"
#import "MyAgingBoothAppDelegate.h"
#import "FaceDB.h"

@implementation DataManager

@synthesize fetchedResultsController=__fetchedResultsController;

@synthesize managedObjectContext=__managedObjectContext;

+(void) createFacesDB
{
    if ([self countFaces]==0) {
        
        
        NSBundle* myBundle;
        // Obtain a reference to a loadable bundle.
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"FacesBundle" ofType:@"bundle"];
        myBundle = [NSBundle bundleWithPath:bundlePath];    
        
        NSArray* myImages = [myBundle pathsForResourcesOfType:@"jpg"
                                                  inDirectory:nil];
        //    NSString *imgName = @"bundlename.bundle/my-image.png";
        //    UIImage *myImage = [UIImage imageNamed:imgName]; 
        
        NSManagedObjectContext *context = [(MyAgingBoothAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
        
        int i=0;
        
        for (NSString *imageName in myImages) {
            
            NSLog(@"%@", imageName);
            FaceDB *facedata = [NSEntityDescription
                                insertNewObjectForEntityForName:@"FaceDB"
                                inManagedObjectContext:context];
            facedata.faceID= [NSNumber numberWithInt:   i++];
            facedata.leftEye=[NSNumber numberWithInt: 100];
            facedata.rightEye=[NSNumber numberWithInt: 100];
            facedata.mouth=[NSNumber numberWithInt: 100];
            facedata.thumbnail=imageName;
        }
        
        
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"error %@", error);
            
        }
    }
}

+(NSUInteger) countFaces
{
    
    NSManagedObjectContext *context = [(MyAgingBoothAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FaceDB"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSUInteger rowcount= [context countForFetchRequest:fetchRequest error:&error ];
//    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
  //  if (fetchedObjects == nil) {
        // Handle the error
    //}
    
    [fetchRequest release];
    return rowcount;
}



@end
