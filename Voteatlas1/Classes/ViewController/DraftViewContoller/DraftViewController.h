//
//  DraftViewController.h
//  Voteatlas1
//
//  Created by GrepRuby on 01/05/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraftCell.h"
#import "Draft.h"

@protocol DraftDelegates <NSObject>

- (void)showDraftInfo:(Draft *)draft;

@end

@interface DraftViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tbleVwDraft;
@property (nonatomic) BOOL isFromSlider;
@property (nonatomic, strong) NSMutableArray *arryDraft;
@property (unsafe_unretained)id <DraftDelegates>delegate;

@end
