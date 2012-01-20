//
//  DataManager.h
//  MyAgingBooth
//
//  Created by Apple on 20/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject


@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

+(void) createFacesDB;
+(NSUInteger) countFaces;


@end
