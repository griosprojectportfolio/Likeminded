//
//  User.h
//  Voteatlas1
//
//  Created by GrepRuby on 30/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * userid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * postalCode;
@property (nonatomic, retain) NSNumber * language;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * role;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * slug;

+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext;
+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext;
+ (void)deleteAllEntityObjects;

@end
