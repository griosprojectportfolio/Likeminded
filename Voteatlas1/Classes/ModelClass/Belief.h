//
//  Belief.h
//  Voteatlas1
//
//  Created by GrepRuby on 25/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Belief : NSObject

@property (nonatomic) NSInteger beliefId;
@property (nonatomic) NSInteger userId;
@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSString *statement;
@property (nonatomic) BOOL hasImage;
@property (nonatomic) BOOL hasVideo;
@property (nonatomic) BOOL hasYouTubeUrl;
@property (nonatomic) BOOL hasSuppose;
@property (nonatomic) BOOL hasOppose;
@property (nonatomic) BOOL hasLock;
@property (nonatomic) BOOL isShowAuther;

@property (nonatomic, strong) NSString *weblink;
@property (nonatomic, strong) NSString *profileImg;

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *languageName;
@property (nonatomic, strong) NSString *youtubeUrl;
@property (nonatomic, strong) NSString *videoUrl;
@property (nonatomic, strong) NSDictionary *dictDisposition;
@property (nonatomic, strong) NSString *thumbImage_Url;
@property (nonatomic, strong) NSNumber *languageId;

@end
