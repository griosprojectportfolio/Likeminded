//
//  Believe.h
//  Voteatlas1
//
//  Created by GrepRuby on 18/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Believe : NSManagedObject

@property (nonatomic, retain) NSString * statement;
@property (nonatomic, retain) NSString * userid;
@property (nonatomic, retain) NSManagedObject *user;

@end
