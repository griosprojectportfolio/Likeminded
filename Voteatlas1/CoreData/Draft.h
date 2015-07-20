//
//  Draft.h
//  Voteatlas1
//
//  Created by GrepRuby on 01/05/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <CoreData/CoreData.h>

@interface Draft : NSManagedObject

@property (nonatomic, retain) NSString *draftId;
@property (nonatomic, retain) NSString *categories;
@property (nonatomic, retain) NSString *langName;
@property (nonatomic, retain) NSString *statement;
@property (nonatomic, retain) NSString *languageId;
@property (nonatomic, retain) NSNumber *auther;
@property (nonatomic, retain) NSString *userId;

+ (void)entityWithDictionary:(NSDictionary *)aDictionaty inContext:(NSManagedObjectContext *)localContext;



@end
