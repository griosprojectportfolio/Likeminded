//
//  Draft.m
//  Voteatlas1
//
//  Created by GrepRuby on 01/05/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "Draft.h"

@implementation Draft

@dynamic draftId;
@dynamic statement;
@dynamic auther;
@dynamic langName, languageId;
@dynamic categories;
@dynamic userId;

+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {

  Draft *obj = [Draft MR_findFirstByAttribute:@"draftId" withValue:anID inContext:localContext];
  if (!obj) {
    obj = [Draft MR_createInContext:localContext];
  }

  return obj;
}

+ (void)entityWithDictionary:(NSDictionary *)aDictionaty inContext:(NSManagedObjectContext *)localContext {
    [Draft entityFromDictionary:aDictionaty inContext:localContext];
}


#pragma mark - Save structure of user detail
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {

    // if (![[aDictionary objectForKey:@"draftId"] isKindOfClass:[NSNull class]]){

    Draft *obj = (Draft*)[Draft MR_createInContext:localContext];

      //[User MR_createInContext:localContext];
      //MediaData *obj = [MediaData MR_createEntity];

    obj.draftId =[aDictionary objectForKey:@"draftId"];

  if (![[aDictionary objectForKey:@"userid"] isKindOfClass:[NSNull class]])
        obj.userId = [aDictionary objectForKey:@"userid"];

    if (![[aDictionary objectForKey:@"statement"] isKindOfClass:[NSNull class]])
      obj.statement = [aDictionary valueForKey:@"statement"] ;

    if (![[aDictionary objectForKey:@"categories"] isKindOfClass:[NSNull class]])
      obj.categories = [aDictionary objectForKey:@"categories"];

    if (![[aDictionary objectForKey:@"language"] isKindOfClass:[NSNull class]])
      obj.langName = [aDictionary objectForKey:@"language"];

    if (![[aDictionary objectForKey:@"languageId"] isKindOfClass:[NSNull class]])
      obj.languageId = [aDictionary valueForKey:@"languageId"];

    if (![[aDictionary objectForKey:@"auther"] isKindOfClass:[NSNull class]])
      obj.auther = [NSNumber numberWithBool:[[aDictionary valueForKey:@"auther"] boolValue]];
    return obj;
    // }
  return nil;
}

@end
