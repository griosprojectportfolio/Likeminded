//
//  DraftViewController.m
//  Voteatlas1
//
//  Created by GrepRuby on 01/05/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "DraftViewController.h"
#import "User.h"
#import "BelieveViewController.h"

@implementation DraftViewController
@synthesize delegate;

- (void)viewDidLoad {

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[ConstantClass imageAccordingToPhone]];
    self.navigationController.navigationBar.translucent =  YES;
    self.title = @"Saved Draft";

    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnTapped)];
    btnBack.tintColor = [UIColor setCustomColorOfTextField];
    [self.navigationItem setLeftBarButtonItem:btnBack];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSArray *arrFetchedData = [User MR_findAll];
    User *userObject = [arrFetchedData objectAtIndex:0];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId contains[cd] %@", userObject.userid];
    self.arryDraft = [[Draft MR_findAllWithPredicate:predicate]mutableCopy];
    
    self.tbleVwDraft.backgroundColor = [UIColor clearColor];
    self.tbleVwDraft.separatorColor = [UIColor setCustomSignUpColor];
    self.tbleVwDraft.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.tbleVwDraft reloadData];
}

- (void)backBtnTapped {
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITable view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self arryDraft] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  DraftCell *cell = (DraftCell*)[tableView dequeueReusableCellWithIdentifier:@"draftCell"forIndexPath:indexPath];
  Draft *draft = [[self arryDraft] objectAtIndex:indexPath.row];
  cell.lblStatement.text = draft.statement;
  cell.lblStatement.textColor = [UIColor darkGrayColor];
  cell.backgroundColor = [UIColor clearColor];
  return cell;
}

#pragma mark - Table view data Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Draft *draft =  [[self arryDraft] objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(showDraftInfo:)]) {
        [self.delegate showDraftInfo:draft];
    }
    
    if (self.isFromSlider == NO) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        BelieveViewController *vcBelief = [self.storyboard instantiateViewControllerWithIdentifier:@"BelieveID"];
        vcBelief.isFromLeftMenu = TRUE;
        vcBelief.userID = draft.userId;
        vcBelief.objDraft = draft;
        [self.navigationController pushViewController:vcBelief animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (void)tableView:(UITableView *)tableViefw commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

  Draft *draft = [[self arryDraft] objectAtIndex:indexPath.row];
  if (editingStyle == UITableViewCellEditingStyleDelete) {

    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [Draft MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"draftId == %@",draft.draftId] inContext:localContext];
    }completion:^(BOOL success, NSError *error) {

    }];
    [self.arryDraft removeObjectAtIndex:indexPath.row];
    [tableViefw reloadData];
  }
}

@end
