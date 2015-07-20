//
//  SupportCommentViewController.h
//  Voteatlas1
//
//  Created by GrepRuby on 31/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHFComposeBarView.h"

@interface SupportCommentViewController : UIViewController <PHFComposeBarViewDelegate>

@property (nonatomic, strong)NSString *strSupposeOrOppose;
@property (nonatomic) BOOL isSupport;
@property (nonatomic) BOOL isTrash;
@property (nonatomic) NSInteger belief_Id;
@property (nonatomic, strong) NSString *strTitle;
@property(nonatomic,strong)AppApi *api;

@end
