//
//  SideBarView.h
//  Voteatlas1
//
//  Created by GrepRuby on 05/05/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sideBarDelegate <NSObject>

- (void)logoutBtnTapped;
- (void)gotoAdminPart;

@end

@interface SideBarView : UIView <UITableViewDataSource, UITableViewDelegate> 

@property (unsafe_unretained) id <sideBarDelegate> delegate;
@property (nonatomic, strong) UITableView *tbleVwSideBar;
@property (nonatomic, strong) NSMutableArray *arrMenuOption;
@property (nonatomic, strong) UIStoryboard *storyboard;

- (void)reloadSideTable;

@end
