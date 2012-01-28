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
#import "opencv2/objdetect/objdetect.hpp"
#import "opencv2/imgproc/imgproc_c.h"
#import "ImageFilters.h"

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
            NSString *teststr=[imageName substringFromIndex: [imageName rangeOfString:@"FacesBundle.bundle"].location];
            facedata.thumbnail=teststr;
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
//  NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//  if (fetchedObjects == nil) {
        // Handle the error
//  }
    
    [fetchRequest release];
    return rowcount;
}


+(NSArray*) findFourBestMatch: (UIImage*) faceImage
{
    NSArray *bestMatches=nil;
    NSManagedObjectContext *context = [(MyAgingBoothAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FaceDB"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    //NSUInteger rowcount= [context countForFetchRequest:fetchRequest error:&error ];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
      if (fetchedObjects == nil) {
//     Handle the error
    }
    else
    {
        
        IplImage *source= [ ImageFilters CreateIplImageFromUIImage: [ImageFilters resizeImage:faceImage newSize:CGSizeMake(64, 64)]];
        
        NSString *match1=@""; float matchScore1= MAXFLOAT;
        NSString *match2=@""; float matchScore2= MAXFLOAT;
        NSString *match3=@""; float matchScore3= MAXFLOAT;
        NSString *match4=@""; float matchScore4= MAXFLOAT;
        
        for (FaceDB* facedb in fetchedObjects) 
        {
            NSLog(@"M: %@", facedb.thumbnail);
            NSString *sample= [facedb.thumbnail stringByReplacingOccurrencesOfString:@"FacesBundle.bundle/" withString:@"FacesBundle.bundle/sample/resized_"];
            NSLog(@"L: %@", sample);
 
            IplImage *dest= [ImageFilters CreateIplImageFromUIImage:[UIImage imageNamed:sample]];
            float matchScore=cvNorm(source, dest, CV_L2,NULL);
            cvReleaseImage(&dest);
            cvReleaseImage(&source);
            
            if (matchScore <=matchScore1) {
                match4=match3; matchScore4=matchScore3;
                match3=match2; matchScore3=matchScore2;
                match2=match1; matchScore2=matchScore1;
                match1=sample; matchScore1=matchScore;
            }
            else if(matchScore <=matchScore2)
            {
                match4=match3; matchScore4=matchScore3;
                match3=match2; matchScore3=matchScore2;
                match2=sample; matchScore2=matchScore;                
            }
            else if(matchScore <=matchScore3)
            {
                match4=match3; matchScore4=matchScore3;
                match3=sample; matchScore3=matchScore;
            }
            else if(matchScore <=matchScore4)
            {
                match4=sample; matchScore4=matchScore;                
            }
        }
      
         match1 = [match1 stringByReplacingOccurrencesOfString:@"FacesBundle.bundle/sample/resized_" withString:@"FacesBundle.bundle/"];
         match2 = [match2 stringByReplacingOccurrencesOfString:@"FacesBundle.bundle/sample/resized_" withString:@"FacesBundle.bundle/"];
         match3 = [match3 stringByReplacingOccurrencesOfString:@"FacesBundle.bundle/sample/resized_" withString:@"FacesBundle.bundle/"];
         match4 = [match4 stringByReplacingOccurrencesOfString:@"FacesBundle.bundle/sample/resized_" withString:@"FacesBundle.bundle/"];
        

        bestMatches = [[[NSArray alloc] initWithObjects:[[NSString alloc] initWithString:match1],[[NSString alloc] initWithString :match2],[[NSString alloc] initWithString: match3],[[NSString alloc] initWithString: match4], nil] autorelease];
      
    }
        [fetchRequest release];        
    return bestMatches;
}

@end
