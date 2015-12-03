//
//  UsersListView.m
//  Voteatlas1
//
//  Created by GrepRuby3 on 06/11/15.
//  Copyright © 2015 Voteatlas. All rights reserved.
//
//GET
//=====================
//likeminded.co/api/v1/get_supported_dispositions?id=11
//likeminded.co/api/v1/get_opposed_dispositions?id=11

#import "UsersListView.h"
#import "ProfileViewController.h"

@implementation UsersListView
@synthesize btnHideList, tblUserList, activityIndicator;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor =  [UIColor colorWithWhite:0 alpha:0.3];
        [self applyDefaults];
    }
    return self;
}

- (void)applyDefaults {
    
    self.api = [AppApi sharedClient];
    self.public_belief = [[NSMutableArray alloc] init];
    self.non_public_belief = [[NSMutableArray alloc] init];
    [self addActivityIndicator];
    
    btnHideList = [[UIButton alloc] init];
    btnHideList.backgroundColor = [UIColor setCustomDarkBlueColor];
    btnHideList.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [btnHideList setTitle:@"X" forState:UIControlStateNormal];
    [btnHideList setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnHideList addTarget:self action:@selector(hideOpposeUserListWithAnimation) forControlEvents:UIControlEventTouchUpInside];
    btnHideList.titleLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:btnHideList];
    
    tblUserList = [[UITableView alloc] init];
    [tblUserList registerClass:[UITableViewCell class] forCellReuseIdentifier:@"userListCell"];
    tblUserList.delegate = self;
    tblUserList.dataSource = self;
    tblUserList.backgroundColor = [UIColor clearColor];
    tblUserList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tblUserList];
}

#pragma mark - UITableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0;
    if (section == 0) {
        height = self.public_belief.count > 0 ? 25.0: 0.0;
    }else {
        height = self.non_public_belief.count > 0 ? 25.0: 0.0;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *vwHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 25)];
    UILabel *lblText = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width - 15, 25)];
    lblText.textAlignment = NSTextAlignmentLeft;
    lblText.font = [UIFont systemFontOfSize:16.0];
    lblText.textColor = [UIColor darkGrayColor];
    vwHeader.backgroundColor = [UIColor whiteColor];
    [vwHeader addSubview:lblText];
    lblText.text = [self.arrSections objectAtIndex:section];
    return vwHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger intCount = 1;
    if (section == 0) {
        intCount = self.public_belief.count;
    }else {
        intCount = self.non_public_belief.count;
    }
    return intCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"userListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor setCustomLightBlueColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:18.0];

    if (indexPath.section == 0) {
        cell.textLabel.text = [self.public_belief objectAtIndex:indexPath.row];
    }else {
        cell.textLabel.text =  [NSString stringWithFormat:@"Total : %@",[self.non_public_belief objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!indexPath.section) {
        if ([self.delegate respondsToSelector:@selector(showTappedUserProfile:)]) {
            [self.delegate showTappedUserProfile:[self.public_belief objectAtIndex:indexPath.row]];
        }
    }
}



#pragma mark - Load Data from server
- (void)loadOpposeUserListData:(NSInteger)belief_id {

    NSDictionary *param = @{@"id":[NSNumber numberWithInteger:belief_id]};
    [self.api callGETUrl:param method:@"/api/v1/get_opposed_dispositions" success:^(AFHTTPRequestOperation *task, id responseObject) {
        [self processResponseDataToShow:responseObject];
        self.arrSections = [[NSMutableArray alloc] initWithArray:@[@"Profiles Not Likeminded",@"Privately Not Likeminded"]];
    }failure:^(AFHTTPRequestOperation *task, NSError *error) {
        [self stopAnimation];
    }];
}

- (void)loadSupposeUserListData:(NSInteger)belief_id {

    NSDictionary *param = @{@"id":[NSNumber numberWithInteger:belief_id]};
    [self.api callGETUrl:param method:@"/api/v1/get_supported_dispositions" success:^(AFHTTPRequestOperation *task, id responseObject) {
        [self processResponseDataToShow:responseObject];
        self.arrSections = [[NSMutableArray alloc] initWithArray:@[@"Likeminded Profiles",@"Privately Likeminded"]];
    }failure:^(AFHTTPRequestOperation *task, NSError *error) {
        [self stopAnimation];
    }];
}

- (void)processResponseDataToShow:(NSDictionary *)dictResponse {
    
    NSArray *arrPublicBelief = [[NSArray alloc] initWithArray:[dictResponse valueForKey:@"public_belief"]];
    [self.non_public_belief addObject:[dictResponse valueForKey:@"non_public_belief"]];
    for (int i = 0; i < arrPublicBelief.count; i ++) {
        [self.public_belief addObject:[arrPublicBelief[i] valueForKey:@"user_slug"]];
    }
    [self.tblUserList reloadData];
    [self stopAnimation];
}

#pragma mark - Remove Current view
- (void)hideOpposeUserListWithAnimation {
    [UIView animateWithDuration:0.4 animations:^{
        self.frame = CGRectMake(self.frame.size.width/2, self.frame.size.height/2, 0, 0);
        [self removeFromSuperview];
    }];
}

#pragma mark - Add activity indicator
/**************************************************************************************************
 Function to add activity indicator
 **************************************************************************************************/
- (void)addActivityIndicator {
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityIndicator.color = [UIColor whiteColor];
    [self bringSubviewToFront:activityIndicator];
    [self addSubview:activityIndicator];
    [activityIndicator startAnimating];
}

- (void)stopAnimation {
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
}


@end
