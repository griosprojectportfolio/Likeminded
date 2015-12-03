//
//  UsersListView.h
//  Voteatlas1
//
//  Created by GrepRuby3 on 06/11/15.
//  Copyright © 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserListDelegate <NSObject>
- (void)showTappedUserProfile:(NSString *)userName;
@end

@interface UsersListView : UIView < UITableViewDelegate, UITableViewDataSource >
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIButton *btnHideList;
@property (nonatomic, strong) UITableView *tblUserList;
@property (nonatomic, strong) AppApi *api;
@property (unsafe_unretained)id <UserListDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *public_belief;
@property (nonatomic, strong) NSMutableArray *non_public_belief;
@property (nonatomic, strong) NSMutableArray *arrSections;
- (void)loadOpposeUserListData:(NSInteger)belief_id;
- (void)loadSupposeUserListData:(NSInteger)belief_id;
@end
