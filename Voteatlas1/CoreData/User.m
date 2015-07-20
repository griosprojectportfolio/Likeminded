//
//  User.m
//  Voteatlas1
//
//  Created by GrepRuby on 30/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "User.h"


@implementation User

@dynamic id;
@dynamic userid;
@dynamic name;
@dynamic country;
@dynamic state;
@dynamic city;
@dynamic language;
@dynamic gender;
@dynamic password;
@dynamic postalCode;
@dynamic role;
@dynamic slug;

+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {

    User *obj = [User MR_findFirstByAttribute:@"userid" withValue:anID inContext:localContext];
    if (!obj) {
        obj = [User MR_createInContext:localContext];
    }

    return obj;
}

+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {

    for(NSDictionary *aDictionary in aArray) {
        [User entityFromDictionary:aDictionary inContext:localContext];
    }
}


#pragma mark - Save structure of user detail
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {

    if (![[aDictionary objectForKey:@"email"] isKindOfClass:[NSNull class]]){

        User *obj = (User*)[self findOrCreateByID:[[aDictionary objectForKey:@"user"]objectForKey:@"email"] inContext:localContext];

            //[User MR_createInContext:localContext];
            //MediaData *obj = [MediaData MR_createEntity];

        obj.id = [NSNumber numberWithInteger:[[[aDictionary  objectForKey:@"user"] objectForKey:@"id"] integerValue]];

        if (![[[aDictionary objectForKey:@"user"]objectForKey:@"email"] isKindOfClass:[NSNull class]])
            obj.userid = [[aDictionary objectForKey:@"user"]valueForKey:@"email"];

        if (![[[aDictionary objectForKey:@"user"]objectForKey:@"name"] isKindOfClass:[NSNull class]])
            obj.name = [[aDictionary objectForKey:@"user"]objectForKey:@"name"];

        if (![[[aDictionary objectForKey:@"user"]objectForKey:@"slug"] isKindOfClass:[NSNull class]])
          obj.slug = [[aDictionary objectForKey:@"user"]objectForKey:@"slug"];

        if (![[aDictionary objectForKey:@"language"] isKindOfClass:[NSNull class]])

            obj.language=[NSNumber numberWithInteger:[[[aDictionary objectForKey:@"language"]valueForKey:@"id"]integerValue]];
            NSLog(@"%@", obj.language);

        if (![[aDictionary objectForKey:@"city"] isKindOfClass:[NSNull class]])

            obj.city = [aDictionary valueForKey:@"city"];

        if (![[[aDictionary objectForKey:@"location"]objectForKey:@"country"] isKindOfClass:[NSNull class]])

            obj.country = [[aDictionary objectForKey:@"location"] valueForKey:@"country"] ;

        if (![[[aDictionary objectForKey:@"location"]objectForKey:@"state"] isKindOfClass:[NSNull class]])
            
            obj.state = [[aDictionary objectForKey:@"location"] valueForKey:@"state"];

        if (![[aDictionary objectForKey:@"role"]count] != 0) {
            if ([[aDictionary valueForKey:@"role"] count] > 0)
                obj.role = [[aDictionary valueForKey:@"role"] objectAtIndex:0];
        }
        if (![[[aDictionary objectForKey:@"user"] objectForKey:@"gender"] isKindOfClass:[NSNull class]])
            
            obj.gender = [[aDictionary objectForKey:@"user"] valueForKey:@"gender"];

        if (![[[aDictionary valueForKey:@"location"]valueForKey:@"postal_code"] isKindOfClass:[NSNull class]])

            obj.postalCode  = [[aDictionary valueForKey:@"location"]valueForKey:@"postal_code"] ;

        return obj;
    }
    return nil;
}

#pragma mark - Delete all entity
/**************************************************************************************************
 Function to delete all entry
 **************************************************************************************************/
+ (void)deleteAllEntityObjects {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {

        NSArray *arrEntities = [[NSArray alloc] initWithObjects:@"User",nil];
        for (int i=0; i < arrEntities.count; i++) {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

            NSEntityDescription *entity = [NSEntityDescription entityForName:[arrEntities objectAtIndex:i] inManagedObjectContext:localContext];
            [fetchRequest setEntity:entity];
            NSError *error;
            NSArray *items = [localContext executeFetchRequest:fetchRequest error:&error];

            for (NSManagedObject *managedObject in items) {
                [localContext deleteObject:managedObject];
            }
            if (![localContext save:&error]) {

            }
        }
    }];
}

@end
