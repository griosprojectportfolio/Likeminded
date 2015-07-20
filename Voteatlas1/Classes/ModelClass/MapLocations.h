//
//  MapLocations.h
//  Voteatlas1
//
//  Created by GrepRuby on 06/04/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapLocations : NSObject

@property (nonatomic) float latitute;
@property (nonatomic) float longitute;

@property (nonatomic, strong) NSString*title;
@property (nonatomic, strong) NSNumber *suppose;
@property (nonatomic, strong) NSNumber *oppose;

@end
