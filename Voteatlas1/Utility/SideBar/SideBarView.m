//
//  SideBarView.m
//  Voteatlas1
//
//  Created by GrepRuby on 05/05/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "SideBarView.h"
#import "SearchDetailViewController.h"
#import "SignUpViewController.h"
#import "DraftViewController.h"
#import "ProfileViewController.h"
#import "FaqsViewController.h"

@implementation SideBarView 

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        [self addSideTbleVw:frame];
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        self.arrMenuOption = [[NSMutableArray alloc]init];
        self.storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
    return self;
}

- (void)addSideTbleVw:(CGRect)frame {

    UIView *vwBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2,  self.frame.size.height)];
    vwBg.backgroundColor = [UIColor setCustomColorOfTextField];
    [self addSubview:vwBg];
    
    UIImageView *imgVwName = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width/2 - 110)/2, 40, 110 , 90)];
    imgVwName.image = [UIImage imageNamed:@"VoteAtlas-Logo-Globel"];
    imgVwName.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imgVwName];

    self.tbleVwSideBar = [[UITableView alloc]initWithFrame:CGRectMake(0, 160, self.frame.size.width/2,  self.frame.size.height)];
    self.tbleVwSideBar.bounces = NO;
    self.tbleVwSideBar.delegate = self;
    self.tbleVwSideBar.dataSource = self;
    self.tbleVwSideBar.backgroundColor = [UIColor clearColor];
    self.tbleVwSideBar.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview: self.tbleVwSideBar];

    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:leftSwipe];
}

#pragma mark - UITable view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrMenuOption count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellIdentifier = @"CellIdentifier1";

    UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.row == 0) {
    }
    cell.backgroundColor = [UIColor clearColor];
        //text field
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [self.arrMenuOption objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50;
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer*)gesture {

    sharedAppDelegate.isSliderOPen = NO;
    [UIView animateWithDuration:0.3 animations:^(void) {
        [self setFrame:CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    }];
}

- (void)reloadSideTable {

    if (self.arrMenuOption.count == 0) {

        [self.arrMenuOption addObject: @"Filter"];
        [self.arrMenuOption addObject: @"Drafts"];
        [self.arrMenuOption addObject: @"My Account"];
        [self.arrMenuOption addObject: @"My Profile"];
        [self.arrMenuOption addObject: @"Logout"];
        [self.arrMenuOption addObject: @"FAQ's"];
        //[self.arrMenuOption addObject: @"Admin"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    sharedAppDelegate.isSliderOPen = NO;
    [UIView animateWithDuration:0.3 animations:^(void) {
        [self setFrame:CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    }];

    //push view controller
    switch (indexPath.row) {

        case 0:
            [self filterBtnTapped:nil];
            break;

        case 1:
            [self draftsBtnTapped:nil];
            break;

        case 2:
            [self myAccountBtnTapped:nil];
            break;

        case 3:
            [self myProfileBtnTapped:nil];
            break;

        case 4:
            [self logoutBtnTapped:nil];
            break;

        case 5:
            [self faqsBtnTapped:nil];
            break;
            
        case 6:
            [self adminBtnTapped:nil];
            break;

        default:
            break;
    }
}

#pragma mark - Home btn tapped
/************************************************************
 Function to go to Fitler view
 *************************************************************/

- (void)filterBtnTapped:(id)sender {

    UIViewController *vwController = [sharedAppDelegate.arryNavController objectAtIndex:sharedAppDelegate.arryNavController.count - 1];
    if ([vwController isKindOfClass:[SearchDetailViewController class]])  {
        return;
    }

    for (UIViewController *vwController in sharedAppDelegate.arryNavController) {

        if ([vwController isKindOfClass:[SearchDetailViewController class]]) {
            [sharedAppDelegate.navController popViewControllerAnimated:YES];
            return;
        }
    }

    UIViewController *vwControllerFilter = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchVC"];
    [sharedAppDelegate.navController pushViewController:vwControllerFilter animated:YES];
}


- (void)draftsBtnTapped:(id)sender {

    UIViewController *vwController = [sharedAppDelegate.arryNavController objectAtIndex:sharedAppDelegate.arryNavController.count - 1];
    if ([vwController isKindOfClass:[SearchDetailViewController class]])  {
        return;
    }

    for (UIViewController *vwController in sharedAppDelegate.arryNavController) {

        if ([vwController isKindOfClass:[SearchDetailViewController class]]) {
            [sharedAppDelegate.navController popViewControllerAnimated:YES];
            return;
        }
    }

    DraftViewController *draftVwController = [self.storyboard instantiateViewControllerWithIdentifier:@"DraftVC"];
    draftVwController.isFromSlider = YES;
    [sharedAppDelegate.navController pushViewController:draftVwController animated:YES];
}

- (void)myAccountBtnTapped:(id)sender {

    UIViewController *vwController = [sharedAppDelegate.arryNavController objectAtIndex:sharedAppDelegate.arryNavController.count - 1];
    if ([vwController isKindOfClass:[SearchDetailViewController class]])  {
        return;
    }

    for (UIViewController *vwController in sharedAppDelegate.arryNavController) {

        if ([vwController isKindOfClass:[SearchDetailViewController class]]) {
            [sharedAppDelegate.navController popViewControllerAnimated:YES];
            return;
        }
    }

    SignUpViewController *vcSignUp = [self.storyboard instantiateViewControllerWithIdentifier:@"signupID"];
    vcSignUp.btnUpdatetag = 5;
    [sharedAppDelegate.navController pushViewController:vcSignUp animated:YES];
}

- (void)myProfileBtnTapped:(id)sender {

    UIViewController *vwController = [sharedAppDelegate.arryNavController objectAtIndex:sharedAppDelegate.arryNavController.count - 1];
    if ([vwController isKindOfClass:[SearchDetailViewController class]])  {
        return;
    }

    for (UIViewController *vwController in sharedAppDelegate.arryNavController) {

        if ([vwController isKindOfClass:[SearchDetailViewController class]]) {
            [sharedAppDelegate.navController popViewControllerAnimated:YES];
            return;
        }
    }

    ProfileViewController *vwControllerProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfilID"];
    vwControllerProfile.userName = @"LoginUser";
    [sharedAppDelegate.navController pushViewController:vwControllerProfile animated:YES];
}

- (void)faqsBtnTapped:(id)sender {
    
    UIViewController *vwController = [sharedAppDelegate.arryNavController objectAtIndex:sharedAppDelegate.arryNavController.count - 1];
    if ([vwController isKindOfClass:[FaqsViewController class]])  {
        return;
    }
    
    for (UIViewController *vwController in sharedAppDelegate.arryNavController) {
        
        if ([vwController isKindOfClass:[FaqsViewController class]]) {
            [sharedAppDelegate.navController popViewControllerAnimated:YES];
            return;
        }
    }
    
    FaqsViewController *vwControllerProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"FaqsID"];
    [sharedAppDelegate.navController pushViewController:vwControllerProfile animated:YES];
}


- (void)logoutBtnTapped:(id)sender {

    if ([self.delegate respondsToSelector:@selector(logoutBtnTapped)]) {
        [self.delegate logoutBtnTapped];
    }
}

- (void)adminBtnTapped:(id)sender {

    if ([self.delegate respondsToSelector:@selector(gotoAdminPart)]) {
        [self.delegate gotoAdminPart];
    }
}

@end
